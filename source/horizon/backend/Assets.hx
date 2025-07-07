/*
	Copyright 2025 CCobaltDev

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		https://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package horizon.backend;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets;
import flxanimate.frames.FlxAnimateFrames;
import haxe.Json;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.system.System;
import sys.FileSystem;
import sys.io.File;

@:publicFields
class Assets
{
	private static var assets:Map<String, Map<String, String>> = [];
	private static var imageCache:Map<String, FlxGraphic> = [];
	private static var audioCache:Map<String, Sound> = [];
	private static var usageTracker:Map<String, Int> = [];
	private static var activeKeys:Array<String> = [];
	private static var exclusions:Array<String> = [];

	static function init():Void
	{
		clearExclusions();
		readFolder('assets');
		activeKeys.push('assets');
		FlxG.signals.preStateCreate.add(_ -> clearMemory);
		FlxG.signals.postStateSwitch.add(clearUnusedMemory);
	}

	static function clearMemory():Void
	{
		@:privateAccess {
			for (key in FlxG.bitmap._cache.keys())
				if (!imageCache.exists(key) && !exclusions.contains(key))
					destroyGraphic(FlxG.bitmap.get(key));

			for (key in audioCache.keys())
				if ((!usageTracker.exists(key) || usageTracker[key] == 0) && !exclusions.contains(key))
				{
					openfl.Assets.cache.clear(key);
					audioCache[key].close();
					audioCache.remove(key);
				}

			usageTracker.clear();
		}
	}

	static function clearUnusedMemory():Void
	{
		for (key in imageCache.keys())
			if ((!usageTracker.exists(key) || usageTracker[key] == 0) && !exclusions.contains(key))
			{
				destroyGraphic(imageCache[key]);
				imageCache.remove(key);
			}

		System.gc();
	}

	static function image(key:String, gpuCaching:Bool = true):FlxGraphic
	{
		var path = getAsset('$key.png');

		if (path == null)
		{
			Log.warn('Image \'$key\' not found');
			return FlxGraphic.fromAssetKey('flixel/images/logo/default.png');
		}

		var cacheKey = pathToCacheKey(path);
		if (imageCache.exists(cacheKey))
		{
			usageTracker[cacheKey]++;
			return imageCache[cacheKey];
		}

		return cacheImage(path, gpuCaching);
	}

	static function audio(key:String, streamed:Bool = false):Sound
	{
		var path = getAsset('$key.ogg');

		if (path == null)
		{
			Log.warn('Audio \'$key\' not found. Playing beep');
			return FlxAssets.getSoundAddExtension('flixel/sounds/beep');
		}

		var cacheKey = pathToCacheKey(path);
		if (audioCache.exists(cacheKey))
		{
			usageTracker[cacheKey]++;
			return audioCache[cacheKey];
		}

		return cacheAudio(path, streamed);
	}

	@:keep static inline function font(key:String):String
		return getAsset('$key.ttf') ?? getAsset('$key.otf');

	static function json(key:String):Dynamic
	{
		var path = getAsset('$key.json');
		if (path != null)
			return Json.parse(File.getContent(path));
		return null;
	}

	@:keep static inline function xml(key:String):String
		return getAsset('$key.xml');

	static function txt(key:String):String
	{
		var path = getAsset('$key.txt');
		if (path != null)
			return File.getContent(path);
		return null;
	}

	static function atlas(key:String):FlxAtlasFrames
	{
		var image = image(key);
		var xmlAtlas = xml(key);
		if (xmlAtlas != null)
			return FlxAnimateFrames.fromSparrow(xmlAtlas, image);

		var txtAtlas = txt(key);
		if (txtAtlas != null)
			return FlxAtlasFrames.fromSpriteSheetPacker(image, txtAtlas);

		var jsonAtlas = json(key);
		if (jsonAtlas != null)
			return FlxAtlasFrames.fromAseprite(image, jsonAtlas);
		return null;
	}

	// Referenced from PsychEngine and https://github.com/Ralsin/FNF-MintEngine/blob/main/source/funkin/api/FileManager.hx#L45
	static function cacheImage(path:String, gpuCaching:Bool = true):FlxGraphic
	{
		var bitmap = BitmapData.fromFile(path);

		if (Settings.gpuCaching && gpuCaching)
			@:privateAccess {
			if (bitmap.__texture == null)
			{
				bitmap.image.premultiplied = true;
				bitmap.getTexture(FlxG.stage.context3D);
			}
			bitmap.disposeImage();
			bitmap.image.data = null;
			bitmap.image = null;
		}

		var cacheKey = pathToCacheKey(path);
		var graphic = FlxGraphic.fromBitmapData(bitmap, false, cacheKey, false);
		graphic.persist = true;
		imageCache.set(cacheKey, graphic);
		usageTracker[cacheKey] = 1;

		return graphic;
	}

	static function cacheAudio(path:String, streamed:Bool = false):Sound
	{
		var sound = (streamed && Settings.streamedAudio) ? Sound.fromAudioBuffer(AudioBuffer.fromVorbisFile(VorbisFile.fromFile(path))) : Sound.fromFile(path);
		var cacheKey = pathToCacheKey(path);
		audioCache.set(cacheKey, sound);
		usageTracker[cacheKey] = 1;
		return sound;
	}

	static function getAsset(key:String):String
	{
		for (folder in activeKeys)
			if (assets[folder].exists(key))
				return assets[folder][key];
		return null;
	}

	static function readFolder(folder:String):Void
	{
		var tempAssets:Map<String, Array<String>> = [];
		assets.set(folder, []);
		recurse(folder, path ->
		{
			var key = PathUtil.withoutDirectory(path);
			tempAssets[key] ??= [];
			tempAssets[key].push(path);
		});

		for (key => value in tempAssets)
			if (value.length > 1)
				for (path in value)
					assets[folder].set('${PathUtil.withoutDirectory(PathUtil.directory(path))}-$key', path);
			else
				assets[folder].set(key, value[0]);
	}

	static function clearExclusions():Void
	{
		exclusions = [];
		addExclusion('gettinFreaky.ogg');
		addExclusion('confirm.ogg');
		addExclusion('scroll.ogg');
		addExclusion('cancel.ogg');
	}

	@:keep static inline function addExclusion(key:String):Void
		exclusions.push(pathToCacheKey(getAsset(key)));

	@:keep static inline function setActiveFolders(folders:Array<String>):Void
		activeKeys = folders;

	private static inline function pathToCacheKey(path:String):String
		return 'hz-${PathUtil.directory(PathUtil.directory(path))}-${PathUtil.withoutDirectory(path)}'.replace('\\', '/');

	private static inline function destroyGraphic(graphic:FlxGraphic):Void
	{
		@:privateAccess graphic.bitmap?.__texture?.dispose();
		FlxG.bitmap.remove(graphic);
	}

	private static function recurse(path:String, callback:String->Void, ?exclude:String->Bool, max:Int = 5):Void
	{
		if (max < 1)
			return;

		for (entry in FileSystem.readDirectory(path))
		{
			var realPath = PathUtil.combine(path, entry);
			if (FileSystem.isDirectory(realPath))
				recurse(realPath, callback, exclude, max - 1);
			else if (exclude == null || !exclude(realPath))
				callback(realPath);
		}
	}
}

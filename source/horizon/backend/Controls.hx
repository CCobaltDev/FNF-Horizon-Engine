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

import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;

@:publicFields
class Controls
{
	private static var keyTracker:Map<FlxKey, Bool> = [F11 => false, F3 => false, ENTER => false];

	static var pressed:Array<FlxKey> = [];
	static var pressSignals:Map<FlxKey, FlxSignal> = [];
	static var releaseSignals:Map<FlxKey, FlxSignal> = [];

	static function onPress(key:Array<FlxKey>, callback:Void->Void):Void
	{
		for (key in key)
		{
			if (!pressSignals.exists(key))
				pressSignals.set(key, new FlxSignal());
			if (!keyTracker.exists(key))
				keyTracker.set(key, false);
			pressSignals[key].add(callback);
		}
	}

	static function onRelease(key:Array<FlxKey>, callback:Void->Void):Void
	{
		for (key in key)
		{
			if (!releaseSignals.exists(key))
				releaseSignals.set(key, new FlxSignal());
			if (!keyTracker.exists(key))
				keyTracker.set(key, false);
			releaseSignals[key].add(callback);
		}
	}

	static function init():Void
	{
		FlxG.signals.preStateSwitch.add(() ->
		{
			for (signal in pressSignals)
				signal.destroy();
			for (signal in releaseSignals)
				signal.destroy();
			pressSignals.clear();
			releaseSignals.clear();
			pressed = [];
		});

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, event ->
		{
			if (!keyTracker[event.keyCode])
			{
				pressed.push(event.keyCode);
				keyTracker[event.keyCode] = true;
				pressSignals[event.keyCode]?.dispatch();
			}
		});

		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, event ->
		{
			pressed.remove(event.keyCode);
			keyTracker[event.keyCode] = false;
			releaseSignals[event.keyCode]?.dispatch();
		});

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, event ->
		{
			if (event.keyCode == FlxKey.ENTER && !keyTracker[ENTER])
			{
				// I stole this from swordcube
				// Credits go to nebulazorua and crowplexus
				if (event.altKey)
					event.stopImmediatePropagation();
			}

			if (event.keyCode == FlxKey.F11 && !keyTracker[F11])
			{
				keyTracker[F11] = true;
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			if (event.keyCode == FlxKey.F3 && !keyTracker[F3])
			{
				keyTracker[F3] = true;
				Globals.debugDisplay = !Globals.debugDisplay;
				Globals.fps.refresh();
			}
		}, false, 10);

		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, event ->
		{
			if (event.keyCode == FlxKey.F11 && keyTracker[F11])
				keyTracker[F11] = false;
			if (event.keyCode == FlxKey.F3 && keyTracker[F3])
				keyTracker[F3] = false;
		});

		if (Globals.verboseLogging)
			Log.info('Controls Initialized');
	}
}

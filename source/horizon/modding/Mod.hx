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

package horizon.modding;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;

#if MOD_SUPPORT
@:publicFields
class Mod
{
	var name:String;
	var description:String;
	var version:String;
	var color:FlxColor;
	var global:Bool;
	var modCompat:Int;
	var folder:String;

	function new() {}

	static function fromFolder(folder:String):Mod
	{
		var m = new Mod();
		var json:ModJSON = null;
		if (FileSystem.exists('mods/$folder/mod.json'))
			json = Json.parse(File.getContent('mods/$folder/mod.json'));

		m.name = json?.name ?? "Unnamed Mod";
		m.description = json?.description ?? "N/A";
		m.version = json?.version ?? "1.0.0";
		m.color = json != null ? FlxColor.fromRGB(json.color[0] ?? 255, json.color[1] ?? 255, json.color[2] ?? 255) : 0xFFFFFFFF;
		m.global = json?.global ?? true;
		m.modCompat = json?.modCompat ?? Globals.modCompatVersion;
		m.folder = folder;
		return m;
	}
}

typedef ModJSON =
{
	var name:Null<String>;
	var description:Null<String>;
	var version:Null<String>;
	var color:Array<Int>;
	var global:Null<Bool>;
	var modCompat:Null<Int>;
}
#end

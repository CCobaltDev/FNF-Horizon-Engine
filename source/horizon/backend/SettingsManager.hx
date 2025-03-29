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

import lime.app.Application;

class SettingsManager
{
	public static function save():Void
	{
		for (setting in Type.getClassFields(Settings))
			Reflect.setField(FlxG.save.data, setting, Reflect.field(Settings, setting));

		Settings.fullscreen = FlxG.fullscreen;
		FlxG.save.data.volume = FlxG.sound.volume;
		FlxG.save.data.muted = FlxG.sound.muted;
		FlxG.save.flush();

		if (Globals.verboseLogging)
			Log.info('Settings Saved');
	}

	public static function load():Void
	{
		for (setting in Type.getClassFields(Settings))
			if (Reflect.hasField(FlxG.save.data, setting))
				Reflect.setField(Settings, setting, Reflect.field(FlxG.save.data, setting));

		FlxG.fullscreen = Settings.fullscreen;
		FlxG.sound.volumeUpKeys = Settings.keybinds['volume_up'];
		FlxG.sound.volumeDownKeys = Settings.keybinds['volume_down'];
		FlxG.sound.muteKeys = Settings.keybinds['volume_mute'];
		FlxG.sound.volume = FlxG.save.data.volume ?? 1;
		FlxG.sound.muted = FlxG.save.data.muted ?? false;
		FlxSprite.defaultAntialiasing = Settings.antialiasing;
		FlxG.fixedTimestep = FlxObject.defaultMoves = false;

		// Thank you superpowers04
		FlxG.drawFramerate = FlxG.updateFramerate = Settings.framerate == 0 ? Std.int(Application.current.window.displayMode.refreshRate >= 120 ? Application.current.window.displayMode.refreshRate : Application.current.window.frameRate >= 120 ? Application.current.window.frameRate : 120) : Settings.framerate;

		if (Globals.verboseLogging)
			Log.info('Settings Loaded');
	}
}

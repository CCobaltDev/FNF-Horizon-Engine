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

package horizon.states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.ui.Toolkit;
import haxe.ui.backend.flixel.CursorHelper;

class InitState extends MusicState
{
	override function create():Void
	{
		OSUtil.setDPIAware();
		OSUtil.setWindowDarkMode(FlxG.stage.window.title, true);
		Log.init();
		SettingsManager.load();
		Assets.init();
		Conductor.init();
		Controls.init();

		Toolkit.init();
		Toolkit.theme = 'horizon';
		CursorHelper.useCustomCursors = false;
		if (Globals.verboseLogging)
			Log.info('HaxeUI Setup Complete');

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, 0xFF000000, .25, new FlxPoint(-1));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, 0xFF000000, .25, new FlxPoint(1));
		Globals.checkUpdate();

		super.create();

		MusicState.switchState(Settings.saved ? new TitleState() : new AccessibilityState());
	}
}

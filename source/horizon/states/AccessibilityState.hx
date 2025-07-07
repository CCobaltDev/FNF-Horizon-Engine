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

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;

class AccessibilityState extends MusicMenuState
{
	var checkboxes:Array<Checkbox> = [];

	override function create():Void
	{
		super.create();

		add(bg = new FlxBackdrop(FlxGridOverlay.create(64, 64, 256, 256, true, 0xFF252525, 0xFF404040).graphic));
		bg.cameras = [menuCam];
		bg.velocity.set(10, 10);
		bg.moves = true;

		var option = new Alphabet(150, 300, "flashing lights", true, LEFT, .8);
		option.alpha = .6;
		menuOptions.add(option);

		var checkbox = new Checkbox(option.x, option.y, .8, true, value -> Settings.flashingLights = value);
		option.cameras = checkbox.cameras = [optionsCam];
		checkbox.offsetY = (option.height - checkbox.height) * 0.25;
		checkbox.tracker = option;
		checkboxes.push(checkbox);
		add(checkbox);

		var option = new Alphabet(175, 420, "reduced motion", true, LEFT, .8);
		option.alpha = .6;
		menuOptions.add(option);

		var checkbox = new Checkbox(option.x, option.y, .8, false, value -> Settings.reducedMotion = value);
		option.cameras = checkbox.cameras = [optionsCam];
		checkbox.offsetY = (option.height - checkbox.height) * 0.25;
		checkbox.tracker = option;
		checkboxes.push(checkbox);
		add(checkbox);

		var option = new Alphabet(200, 540, "continue", true, LEFT, .8);
		option.cameras = [optionsCam];
		option.alpha = .6;
		menuOptions.add(option);

		changeSelection();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (i => option in menuOptions.members)
		{
			option.x = Util.fpsLerp(option.x, 150 + 25 * (i - curSelected), 5);
			option.y = Util.fpsLerp(option.y, 300 + 120 * (i - curSelected), 5);
		}
	}

	override function changeSelection(change:Int = 0):Void
	{
		menuOptions.members[curSelected].alpha = .6;
		super.changeSelection(change);
		menuOptions.members[curSelected].alpha = 1;
	}

	override function exitState():Void
	{
		super.exitState();
		if (curSelected == menuOptions.length - 1)
		{
			SettingsManager.save();
			if (Settings.flashingLights)
				FlxFlicker.flicker(menuOptions.members[curSelected], 0.5, 0.04, false, true, flicker -> MusicState.switchState(new TitleState()));
			else
				FlxTimer.wait(0.5, MusicState.switchState.bind(new TitleState(), false, false));
		}
		else
		{
			checkboxes[curSelected].toggle();
			leaving = false;
		}
	}

	override function returnState():Void {}
}

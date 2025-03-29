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

class MusicMenuState extends MusicState
{
	var curSelected:Int = 0;
	var menuOptions:FlxTypedGroup<FlxSprite>;

	var menuCam:FlxCamera;
	var optionsCam:FlxCamera;
	var otherCam:FlxCamera;

	var menuFollow:FlxObject;
	var optionFollow:FlxObject;

	var bg:FlxSprite;

	var customInput:Bool = false;
	var setupCams:Bool = true;

	override function create()
	{
		if (setupCams)
		{
			menuCam = Create.camera();
			optionsCam = Create.camera();
			otherCam = Create.camera();
			menuFollow = new FlxObject(FlxG.width * .5, FlxG.height * .5);
			optionFollow = new FlxObject(FlxG.width * .5, FlxG.height * .5);
			menuCam.follow(menuFollow, LOCKON, .1);
			optionsCam.follow(optionFollow, LOCKON, .15);
			bopCams.push(menuCam);
			bopCams.push(optionsCam);
		}

		super.create();

		add(menuOptions = new FlxTypedGroup<FlxSprite>());

		if (!customInput)
		{
			Controls.onPress(Settings.keybinds['ui_down'], () -> if (!leaving) changeSelection(1));
			Controls.onPress(Settings.keybinds['ui_up'], () -> if (!leaving) changeSelection(-1));
			Controls.onPress(Settings.keybinds['accept'], () -> if (!leaving) exitState());
			Controls.onPress(Settings.keybinds['back'], () -> if (!leaving) returnState());
		}
	}

	override function destroy()
	{
		if (setupCams)
		{
			menuFollow.destroy();
			optionFollow.destroy();
		}
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		if (change != 0)
			FlxG.sound.play(Assets.audio('scroll'), .7);

		curSelected = (curSelected + change + menuOptions.length) % menuOptions.length;
	}

	function exitState():Void
	{
		leaving = true;
		FlxG.sound.play(Assets.audio('confirm'), .7);
	}

	function returnState():Void
	{
		leaving = true;
		FlxG.sound.play(Assets.audio('confirm'), .7);
	}
}

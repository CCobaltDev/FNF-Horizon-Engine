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

import horizon.backend.Conductor.TimeSignature;
import horizon.modding.JSONTypes.TitleJSON;

class TitleState extends MusicState
{
	var logo:FlxSprite;
	var enter:FlxSprite;
	var dancer:FlxSprite;

	var introSkipped:Bool = false;
	var titleTimer:Float = 0;

	var introTexts:Array<Alphabet> = [];
	var introImages:Array<FlxSprite> = [];
	var dynamicTexts:Array<String>;

	static var titleData:TitleJSON;
	static var returning:Bool = false;

	override function create():Void
	{
		super.create();

		persistentUpdate = true;

		titleData ??= Assets.json('titleData');
		Conductor.timeSignature = TimeSignature.fromString(titleData.timeSignature ?? '4/4');
		Conductor.bpm = titleData.bpm ?? 102;

		var textList = Assets.txt('introTexts').split('\n');
		dynamicTexts = textList[FlxG.random.int(0, textList.length - 1)].split('--');

		dancer = Create.atlas(titleData.dancerPosition[0], titleData.dancerPosition[1], Assets.atlas('gfDanceTitle'), 0.9);
		dancer.animation.addByPrefix('left', 'left', 24);
		dancer.animation.addByPrefix('right', 'right', 24);
		dancer.visible = false;
		add(dancer);

		logo = Create.atlas(titleData.logoPosition[0], titleData.logoPosition[1], Assets.atlas('logoBumpin'));
		logo.animation.addByPrefix('bop', 'logo bumpin', 24, false);
		logo.visible = false;
		add(logo);

		enter = Create.atlas(titleData.enterPosition[0], titleData.enterPosition[1], Assets.atlas('titleEnter'));
		enter.animation.addByPrefix('pressed', 'ENTER PRESSED', 24, true);
		enter.animation.addByPrefix('idle', 'ENTER IDLE', 24, true);
		enter.animation.play('idle');
		enter.visible = false;
		add(enter);

		FlxTween.num(0, 1, 2, {type: PINGPONG, ease: FlxEase.quadInOut}, num -> titleTimer = num);

		if (returning)
			skipIntro();
		else if (FlxG.sound.music != null)
			FlxG.sound.playMusic(Assets.audio('gettinFreaky', true), 0);

		Controls.onPress(Settings.keybinds['accept'], () -> {});
	}

	function skipIntro():Void {}
}

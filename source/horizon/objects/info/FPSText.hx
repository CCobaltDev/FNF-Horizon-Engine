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

package horizon.objects.info;

import openfl.text.TextField;
import openfl.text.TextFormat;

class FPSText extends TextField
{
	public var curFPS:Int;

	var curTime:Float = 0;
	var frames:Int = 0;

	public function new()
	{
		super();

		selectable = mouseEnabled = false;
		multiline = true;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat(Assets.font('JetBrainsMonoNL-SemiBold'), 16, 0xFFFFFF);
		curFPS = FlxG.updateFramerate;
	}

	override function __enterFrame(deltaTime:Float):Void
	{
		curTime += deltaTime * 0.001;
		frames++;

		if (curTime >= .1)
		{
			curFPS = Math.floor(frames / curTime);
			curTime = frames = 0;
			text = 'FPS: $curFPS';
		}
	}
}

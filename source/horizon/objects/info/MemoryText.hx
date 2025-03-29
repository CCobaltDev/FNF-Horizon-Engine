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

import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class MemoryText extends TextField
{
	var curMemory:Float = 0;
	var maxMemory:Float = 0;
	var curTime:Float = 0;

	var maxFormat:TextFormat;
	var maxMemoryText:String;

	public function new()
	{
		super();

		selectable = mouseEnabled = false;
		multiline = true;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat(Assets.font('JetBrainsMonoNL-SemiBold'), 14, 0xFFFFFF);
		maxFormat = new TextFormat(Assets.font('JetBrainsMonoNL-SemiBold'), 12, 0x505050);
	}

	override function __enterFrame(deltaTime:Float):Void
	{
		curTime += deltaTime * 0.001;

		if (curTime >= .1)
		{
			var mem = OSUtil.getMemory();
			if (curMemory != mem)
			{
				curMemory = mem;
				if (curMemory > maxMemory)
				{
					maxMemory = curMemory;
					maxMemoryText = '(${Util.formatBytes(maxMemory)})';
				}

				text = 'Memory: ${Util.formatBytes(curMemory)} $maxMemoryText';
				setTextFormat(maxFormat, length - maxMemoryText.length - 1, length);
			}

			curTime = 0;
		}
	}
}

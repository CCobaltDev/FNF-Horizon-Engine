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

package horizon.objects;

import horizon.objects.info.*;
import openfl.display.Sprite;

// Based on PsychEngine's FPSCounter.hx
class EngineInfo extends Sprite
{
	static var fps:FPSText;
	static var memory:MemoryText;
	static var debug:DebugText;

	public function new()
	{
		super();

		x = y = 2;

		fps = new FPSText();
		memory = new MemoryText();
		debug = new DebugText();

		refresh();
	}

	public function refresh():Void
	{
		removeChild(fps);
		removeChild(memory);
		removeChild(debug);
		if (Settings.showFPS)
			addChild(fps);
		if (Settings.showMemory)
			addChild(memory);
		if (Globals.debugDisplay)
			addChild(debug);

		for (i in 0...numChildren)
			getChildAt(i).y = 20 * i;
	}
}

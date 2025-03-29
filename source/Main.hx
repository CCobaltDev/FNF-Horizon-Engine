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

package;

import flixel.FlxG;
import flixel.FlxGame;
import horizon.backend.Globals;
import horizon.objects.EngineInfo;
import horizon.states.InitState;
import lime.graphics.Image;
import openfl.Lib;
import openfl.display.Sprite;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('#define GAMEMODE_AUTO')
#end
class Main extends Sprite
{
	function new()
	{
		super();

		#if linux Lib.current.stage.window.setIcon(Image.fromFile('icon.png')); #end
		addChild(new FlxGame(1280, 720, InitState, 120, 120, true));
		addChild(Globals.fps = new EngineInfo());

		// shader coords fix (stolen from PsychEngine)
		FlxG.signals.gameResized.add((w, h) ->
		{
			if (FlxG.cameras != null)
				for (cam in FlxG.cameras.list)
					if (cam?.filters != null)
					{
						cam.flashSprite.__cacheBitmap = null;
						cam.flashSprite.__cacheBitmapData = null;
					};

			if (FlxG.game != null)
			{
				FlxG.game.__cacheBitmap = null;
				FlxG.game.__cacheBitmapData = null;
			}
		});

		// TODO: Lib.current.loaderInfo.uncaughtErrorEvents and __global__.__hxcpp_set_critical_error_handler
	}
}

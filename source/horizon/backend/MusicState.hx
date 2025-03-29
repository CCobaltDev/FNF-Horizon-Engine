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

import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxDestroyUtil;

class MusicState extends FlxTransitionableState
{
	var curStep(get, never):Int;
	var curBeat(get, never):Int;
	var curMeasure(get, never):Int;

	static var bopZoom:Float = 1.035;
	static var zoomTarget:Float = 1;

	var bopCams:Array<FlxCamera> = [];
	var zoom:Bool = true;
	var bop:Bool = true;
	var leaving:Bool = false;

	function onStep():Void {}

	function onBeat():Void
	{
		if (!leaving && bop)
			for (cam in bopCams)
				cam.zoom = bopZoom;
	}

	function onMeasure():Void {}

	public override function create()
	{
		Conductor.stepSignal.add(onStep);
		Conductor.beatSignal.add(onBeat);
		Conductor.measureSignal.add(onMeasure);
		bopCams.push(FlxG.camera);
		super.create();
	}

	public override function update(elapsed:Float):Void
	{
		if (zoom)
			for (cam in bopCams)
				cam.zoom = Util.fpsLerp(cam.zoom, zoomTarget, 5);
		super.update(elapsed);
	}

	public override function destroy():Void
	{
		bopCams = FlxDestroyUtil.destroyArray(bopCams);
		Conductor.stepSignal.remove(onStep);
		Conductor.beatSignal.remove(onBeat);
		Conductor.measureSignal.remove(onMeasure);
		super.destroy();
	}

	public static function switchState(state:FlxState, skipTransIn:Bool = false, skipTransOut:Bool = false):Void
	{
		FlxTransitionableState.skipNextTransIn = skipTransIn;
		FlxTransitionableState.skipNextTransOut = skipTransOut;
		FlxG.switchState(() -> state);
		if (Globals.verboseLogging)
			Log.info('State Switch: ${Type.getClassName(Type.getClass(state)).split('.').pop()}');
	}

	@:noCompletion inline function get_curStep():Int
		return Conductor.curStep;

	@:noCompletion inline function get_curBeat():Int
		return Conductor.curBeat;

	@:noCompletion inline function get_curMeasure():Int
		return Conductor.curMeasure;
}

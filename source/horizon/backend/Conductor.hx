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

import sys.thread.Thread;

@:publicFields
class Conductor
{
	static var bpm(default, set):Float;

	static var curStep:Int = 0;
	static var curBeat:Int = 0;
	static var curMeasure:Int = 0;

	static var time:Float = 0;
	static var song(default, set):FlxSound;
	static var timeSignature(default, set):TimeSignature = TimeSignature.fromString('4/4');
	static var switchToMusic:Bool = true;

	static var stepLength:Float = -1;
	static var beatLength:Float = -1;
	static var measureLength:Float = -1;

	static var stepSignal:FlxSignal;
	static var beatSignal:FlxSignal;
	static var measureSignal:FlxSignal;

	private static var stepTracker:Float = 0;
	private static var beatTracker:Float = 0;
	private static var measureTracker:Float = 0;

	private static var lastTime:Float = 0;
	private static var startTime:Float = 0;
	@:unreflective private static var thread:Thread;

	static function init()
	{
		stepSignal = new FlxSignal();
		beatSignal = new FlxSignal();
		measureSignal = new FlxSignal();

		reset();

		startTime = Sys.time();
		thread = Thread.create(() -> while (true)
		{
			var dt = Sys.time() - startTime;

			if (song != null)
			{
				if (song.playing)
				{
					if (song.time == lastTime)
						time += dt * 1000;
					else
					{
						time = song.time + Settings.songOffset;
						lastTime = song.time;
					}
				}
			}
			else if (FlxG.sound.music != null && switchToMusic)
			{
				if (Globals.verboseLogging)
					Log.info('Setting song to FlxG.sound.music');
				song = FlxG.sound.music;
			}

			while (time >= stepTracker + stepLength)
			{
				stepTracker += stepLength;
				curStep++;
				stepSignal.dispatch();
			}

			while (time >= beatTracker + beatLength)
			{
				beatTracker += beatLength;
				curBeat++;
				beatSignal.dispatch();
			}

			while (time >= measureTracker + measureLength)
			{
				measureTracker += measureLength;
				curMeasure++;
				measureSignal.dispatch();
			}

			var remainingTime = (1 / 240) - (Sys.time() - startTime);
			startTime = Sys.time();
			if (remainingTime > 0)
				Sys.sleep(remainingTime);
		});

		if (Globals.verboseLogging)
			Log.info('Conductor Initialized');
	}

	static function reset():Void
	{
		timeSignature = TimeSignature.fromString('4/4');
		bpm = 100;
		switchToMusic = true;
		stepTracker = beatTracker = measureTracker = time = lastTime = startTime = 0;
		curStep = curBeat = curMeasure = 0;
		song = null;
	}

	static inline function recalculateLengths():Void
	{
		beatLength = 60 / bpm * 1000 * (4 / timeSignature.denominator);
		stepLength = beatLength * .25;
		measureLength = beatLength * timeSignature.numerator;
	}

	@:noCompletion static function set_bpm(val:Float):Float
	{
		bpm = val;
		recalculateLengths();
		return val;
	}

	@:noCompletion static function set_song(val:FlxSound):FlxSound
	{
		if (val != null)
			val.onComplete = reset;
		return song = val;
	}

	@:noCompletion static function set_timeSignature(val:TimeSignature):TimeSignature
	{
		timeSignature = val;
		recalculateLengths();
		return val;
	}
}

@:structInit
class TimeSignature
{
	public var numerator:Float;
	public var denominator:Float;

	public static function fromString(sig:String):TimeSignature
	{
		if (!sig.contains('/'))
			return {numerator: 4, denominator: 4}

		var split = sig.trim().split('/');
		return {numerator: Std.parseFloat(split[0].trim()), denominator: Std.parseFloat(split[1].trim())}
	}

	public function toString(sig:TimeSignature):String
		return '$numerator/$denominator';
}

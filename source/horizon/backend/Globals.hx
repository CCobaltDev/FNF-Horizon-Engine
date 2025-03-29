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

import haxe.Http;

// Globals/Constants
@:publicFields
class Globals
{
	static var version:String = MacroUtil.getVersion();
	static var verboseLogging:Bool = MacroUtil.defined('debug');
	static var debugDisplay:Bool = MacroUtil.defined('debug');
	static var modCompatVersion:Int = 1;
	static var updateAvaliable:Bool = false;
	static var onlineVer:String;
	static var fps:EngineInfo;

	static function checkUpdate():Void
	{
		var request = new Http('https://raw.githubusercontent.com/CCobaltDev/FNF-Horizon-Engine/main/.build');
		request.onData = data ->
		{
			onlineVer = data.trim();
			updateAvaliable = Std.parseInt(onlineVer) > Std.parseInt(version);
			if (updateAvaliable)
				Log.info('Update avaliable ($onlineVer > $version)');
		}
		request.onError = msg -> Log.error('Error while checking for update: $msg');
		request.request();
	}
}
/*
	public static final HEALTH_MAX:Float = 2.0;
	public static final HEALTH_STARTING = HEALTH_MAX / 2.0;
	public static final HEALTH_MIN:Float = 0.0;
	public static final HEALTH_SICK_BONUS:Float = 1.5 / 100.0 * HEALTH_MAX;
	public static final HEALTH_GOOD_BONUS:Float = 0.75 / 100.0 * HEALTH_MAX;
	public static final HEALTH_BAD_BONUS:Float = 0.0 / 100.0 * HEALTH_MAX;
	public static final HEALTH_SHIT_BONUS:Float = -1.0 / 100.0 * HEALTH_MAX;
	public static final HEALTH_HOLD_BONUS_PER_SECOND:Float = 7.5 / 100.0 * HEALTH_MAX;
	public static final HEALTH_MISS_PENALTY:Float = 4.0 / 100.0 * HEALTH_MAX;
	public static final HEALTH_GHOST_MISS_PENALTY:Float = 2.0 / 100.0 * HEALTH_MAX;

	public static final PBOT1_MAX_SCORE:Int = 500;
	public static final PBOT1_SCORING_OFFSET:Float = 54.99;
	public static final PBOT1_SCORING_SLOPE:Float = 0.080;
	public static final PBOT1_MIN_SCORE:Float = 9.0;
	public static final PBOT1_MISS_SCORE:Int = 0;
	public static final PBOT1_PERFECT_THRESHOLD:Float = 5.0;
	public static final PBOT1_MISS_THRESHOLD:Float = 160.0;
	public static final PBOT1_SICK_THRESHOLD:Float = 45.0;
	public static final PBOT1_GOOD_THRESHOLD:Float = 90.0;
	public static final PBOT1_BAD_THRESHOLD:Float = 135.0;
	public static final PBOT1_SHIT_THRESHOLD:Float = 160.0;

	case(_ > PBOT1_MISS_THRESHOLD) => true:
		PBOT1_MISS_SCORE;
	case(_ < PBOT1_PERFECT_THRESHOLD) => true:
		PBOT1_MAX_SCORE;
	default:
		var factor:Float = 1.0 - (1.0 / (1.0 + Math.exp(-PBOT1_SCORING_SLOPE * (absTiming - PBOT1_SCORING_OFFSET))));
		var score:Int = Std.int(PBOT1_MAX_SCORE * factor + PBOT1_MIN_SCORE);
		score;
 */

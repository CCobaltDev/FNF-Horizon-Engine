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

import flixel.input.keyboard.FlxKey;

@:publicFields
class Settings
{
	static var noteRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
	];

	static var downscroll:Bool = false;
	static var middlescroll:Bool = false;
	static var ghostTapping:Bool = true;
	static var safeFrames:Int = 10;
	static var hitWindows:Array<Float> = [45, 90, 135, 160];

	static var opponentStrums:Bool = true;
	static var comboOffsets:Array<Float> = [0, 0];
	static var showFPS:Bool = true;
	static var showMemory:Bool = true;

	static var antialiasing:Bool = true;
	static var framerate:Int = 0;
	static var gpuCaching:Bool = true; // I'm aware that this is a misnomer. -Cobalt
	static var streamedAudio:Bool = true;

	static var flashingLights:Bool = true;
	static var reducedMotion:Bool = false;
	static var enableShaders:Bool = true;

	static var keybinds:Map<String, Array<FlxKey>> = [
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R],
		'volume_up' => [PLUS, NUMPADPLUS],
		'volume_down' => [MINUS, NUMPADMINUS],
		'volume_mute' => [P, NUMPADMULTIPLY],
		'debug' => [LBRACKET, RBRACKET],
	];

	static var fullscreen:Bool = false;
	static var autoPause:Bool = true;
	static var songOffset:Float = 0;
	static var inputOffset:Float = 0;
	static var saved:Bool = false;
}

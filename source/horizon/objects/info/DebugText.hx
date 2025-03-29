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

import lime.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import sys.io.Process;

class DebugText extends TextField
{
	static final libText:String = 'Haxe:            ${MacroUtil.libHash('haxe')}\n'
		+ 'Flixel:          ${MacroUtil.libHash('flixel')}\n'
		+ 'Flixel-Addons:   ${MacroUtil.libHash('flixel-addons')}\n'
		+ 'Flixel-Waveform: ${MacroUtil.libHash('flixel-waveform')}\n'
		+ 'FlxAnimate:      ${MacroUtil.libHash('flxanimate')}\n'
		+ 'HaxeUI-Core:     ${MacroUtil.libHash('haxeui-core')}\n'
		+ 'HaxeUI-Flixel:   ${MacroUtil.libHash('haxeui-flixel')}\n'
		+ 'HxVLC:           ${MacroUtil.libHash('hxvlc')}\n'
		+ 'Lime:            ${MacroUtil.libHash('lime')}\n'
		+ 'OpenFL:          ${MacroUtil.libHash('openfl')}\n';

	public function new()
	{
		super();

		selectable = mouseEnabled = false;
		multiline = true;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat(Assets.font('JetBrainsMonoNL-SemiBold'), 12, 0xFFFFFF);

		text = 'Horizon Engine Build ${Globals.version}\n';

		var cpuProc = new Process(#if windows 'wmic cpu get name' #elseif linux 'lscpu | grep \'Model name\' | cut -f 2 -d \":\" | awk \'{$1=$1}1\'' #end);
		var cpu:String = 'N/A';

		if (cpuProc.exitCode() == 0)
		{
			var arr = cpuProc.stdout.readAll().toString().trim().split('\n');
			cpu = arr[arr.length - 1];
		}

		// Thanks to CoreCat for the code to get the GPU and OS data
		text += 'OS:  ${System.platformLabel} ${System.platformVersion}\n';
		text += 'CPU: $cpu\n';
		text += 'GPU: ${@:privateAccess Std.string(FlxG.stage.context3D.gl.getParameter(FlxG.stage.context3D.gl.RENDERER)).split('/')[0].trim()}\n\n';
		text += libText;
	}
}

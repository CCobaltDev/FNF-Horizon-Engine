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

package horizon.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class MacroUtil
{
	public static macro function libHash(lib:String):ExprOf<String>
	{
		#if macro
		#if !display
		var ret:String;
		var proc = new Process('haxelib libpath $lib');
		if (proc.exitCode() == 0)
		{
			var ver = proc.stdout.readAll().toString().trim();
			if (ver.indexOf('git') != -1)
			{
				var commitProc = new Process('git -C $ver rev-parse --short=8 HEAD');
				if (commitProc.exitCode() == 0)
					ret = '${Context.definedValue(lib)}@${commitProc.stdout.readAll().toString().trim()}';

				commitProc.close();
			}
		}
		proc.close();
		return macro $v{ret ?? Context.definedValue(lib)};
		#end
		return macro "N/A";
		#end
	}

	public static macro function getVersion():ExprOf<String>
	{
		#if macro
		#if !display
		if (FileSystem.exists('.build'))
			return macro $v{File.getContent('.build')};
		#end
		return macro $v{'N/A'};
		#end
	}

	public static macro function defined(flag:String):ExprOf<Bool>
	{
		#if macro
		return macro $v{Context.defined(flag)};
		#end
	}
}

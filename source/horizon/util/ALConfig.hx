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

package horizon.util;

// Based off https://github.com/ShadowMario/FNF-PsychEngine/pull/15536
@:keep class ALConfig
{
	static function __init__():Void
	{
		var configPath:String = PathUtil.directory(PathUtil.withoutExtension(Sys.programPath()));

		#if windows
		configPath += "/assets/alsoft.ini";
		#elseif mac
		// Please make an issue if this breaks, I have no way to test it
		configPath = PathUtil.directory(configPath) + "/Resources/assets/alsoft.conf";
		#elseif linux
		configPath += "/assets/alsoft.conf";
		#end

		Sys.putEnv("ALSOFT_CONF", configPath);
	}
}

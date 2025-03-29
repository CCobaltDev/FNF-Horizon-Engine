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

import openfl.system.System;

@:publicFields
class OSUtil
{
	#if windows
	static function setDPIAware():Void
	{
		if (!Windows.setDPIAware())
			Log.error("Failed to make process DPI-aware");
	}

	static function setWindowDarkMode(windowTitle:String, value:Bool):Void
	{
		if (!Windows.setWindowDarkMode(windowTitle, value))
			Log.error('Failed to set window $windowTitle ${value ? "dark" : "light"}');
	}
	#end

	static function getMemory():Float
	{
		return #if windows Windows #else Linux #end.getMemory() ?? System.totalMemoryNumber;
	}
}

@:publicFields
#if windows
@:cppInclude('windows.h')
@:cppInclude('dwmapi.h')
@:cppInclude('psapi.h')
@:buildXml('<target id="haxe">
	<lib name="dwmapi.lib" />
	<lib name="psapi.lib" />
</target>')
private class Windows
{
	@:functionCode('PROCESS_MEMORY_COUNTERS_EX2 memCounters;
	GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS*)&memCounters, sizeof(memCounters));
	return memCounters.PrivateWorkingSetSize;')
	static function getMemory():Null<Float>
	{
		return null;
	}

	@:functionCode('int darkMode = (value ? 1 : 0);
		HWND window = FindWindowA(NULL, windowTitle.c_str());
		if (window == NULL)
			window = FindWindowExA(GetActiveWindow(), NULL, NULL, windowTitle.c_str());

		if (window != NULL) {
			if (DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode)) != S_OK) {
				return DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode)) == S_OK;
			}else return TRUE;
		}else return FALSE;')
	static function setWindowDarkMode(windowTitle:String, value:Bool):Bool
	{
		return false;
	}

	@:functionCode('return SetProcessDPIAware();')
	static function setDPIAware():Bool
	{
		return false;
	}
}
#else
private class Linux
{
	static function getMemory():Null<Float>
	{
		return null;
	}
}
#end

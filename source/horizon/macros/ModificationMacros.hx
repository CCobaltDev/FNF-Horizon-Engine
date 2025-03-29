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
#end

class ModificationMacros
{
	// FunkinCrew/Funkin FlxMacro
	public static function FlxBasic()
	{
		#if macro
		var fields = Context.getBuildFields();
		fields.push({
			name: "zIndex",
			pos: Context.currentPos(),
			access: [APublic],
			kind: FVar(macro :Int, macro idEnumerator),
		});
		return fields;
		#end
	}

	public static function FlxSprite()
	{
		#if macro
		var fields = Context.getBuildFields();
		var set_clipRect = [for (field in fields) if (field.name == 'set_clipRect') field][0];
		switch (set_clipRect.kind)
		{
			case FFun(f):
				set_clipRect.kind = FFun({
					args: f.args,
					params: f.params,
					ret: f.ret,
					expr: macro
					{
						clipRect = rect;

						frame = frames?.frames[animation.frameIndex];

						return rect;
					}
				});
			default:
		}
		return fields;
		#end
	}

	public static function LocaleManager()
	{
		#if macro
		var fields = Context.getBuildFields();

		var init:Field = [for (field in fields) if (field.name == 'init') field][0];

		switch (init.kind)
		{
			case FFun(f):
				init.kind = FFun({
					args: f.args,
					params: f.params,
					ret: f.ret,
					expr: macro
					{
						#if !haxeui_dont_detect_locale
						var autoDetectedLocale = Platform.instance.getSystemLocale();
						if (!_localeSet && autoSetLocale && autoDetectedLocale != null && hasLocale(autoDetectedLocale))
						{
							#if debug
							horizon.util.Log.info("System locale detected as: " + autoDetectedLocale, {
								methodName: 'init',
								lineNumber: 46,
								fileName: 'haxe/ui/locale/LocaleManager.hx',
								className: 'LocaleManager'
							});
							#end
							_language = autoDetectedLocale;
							applyLocale(_language);
						}
						#end
					}
				});
			default:
		}

		return fields;
		#end
	}
}

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

package horizon.objects;

// Based off https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/objects/CheckboxThingie.hx
@:publicFields
class Checkbox extends FlxCopySprite
{
	var value(default, set):Bool;
	var onValueChanged:Bool->Void;

	function new(x:Float, y:Float, initScale:Float, defaultValue:Bool, valueChanged:Bool->Void)
	{
		super(x, y);

		frames = Assets.atlas("checkbox");
		animation.addByPrefix("checked", "checked", 24, false);
		animation.addByPrefix("unchecked", "unchecked", 24, false);
		animation.addByPrefix("checking", "checking", 24, false);
		animation.addByPrefix("unchecking", "unchecking", 24, false);
		setGraphicSize(Std.int(0.9 * width));
		updateHitbox();
		scale *= initScale;
		scaleMult = scale.x;
		offsetX = -130;

		animation.onFinish.add(animName ->
		{
			if (animName == "checking")
			{
				animation.play("checked", true);
				offset.set(3 * (scale.x + 0.1), 12 * (scale.y + 0.1));
			}
			else if (animName == "unchecking")
			{
				animation.play("unchecked", true);
				offset.set(0, 2 * (scale.y + 0.1));
			}
		});

		animation.play(defaultValue ? "checked" : "unchecked");
		value = defaultValue;
		offset.set(defaultValue ? 3 * (scale.x + 0.1) : 0, defaultValue ? 12 * (scale.y + 0.1) : 2 * (scale.y + 0.1));
		onValueChanged = valueChanged;
	}

	function toggle():Void
	{
		value = !value;
	}

	@:noCompletion function set_value(val:Bool):Bool
	{
		if (val)
		{
			if (animation.curAnim.name.startsWith("uncheck"))
			{
				animation.play("checking", true);
				offset.set(34 * (scale.x + 0.1), 25 * (scale.y + 0.1));
			}
		}
		else if (animation.curAnim.name.startsWith("check"))
		{
			animation.play("unchecking", true);
			offset.set(25 * (scale.x + 0.1), 28 * (scale.y + 0.1));
		}

		if (onValueChanged != null)
			onValueChanged(val);

		return value = val;
	}
}

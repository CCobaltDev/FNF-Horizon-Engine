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

@:publicFields
class FlxCopySprite extends FlxSprite
{
	var tracker:FlxSprite;
	var copyAlpha:Bool = true;
	var copyScale:Bool = true;

	var offsetX:Float = 0;
	var offsetY:Float = 0;
	var scaleMult:Float = 1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (tracker != null)
		{
			if (copyAlpha && alpha != tracker.alpha)
				alpha = tracker.alpha;

			if (x != tracker.x + offsetX)
				x = tracker.x + offsetX;

			if (y != tracker.y + offsetY)
				y = tracker.y + offsetY;

			if (copyScale)
				if (scale.x != tracker.scale.x * scaleMult || scale.y != tracker.scale.y * scaleMult)
					scale.set(tracker.scale.x * scaleMult, tracker.scale.y * scaleMult);
		}
	}
}

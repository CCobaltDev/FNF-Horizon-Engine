package horizon.states;

import lime.app.Application;

class MainMenuState extends MusicMenuState
{
	var flashBG:FlxBackdrop;
	var modCount:Int = 0;
	var targets:Array<FlxPoint> = [];

	static var prevSelected:Int = 0;

	public override function create():Void
	{
		Path.clearStoredMemory();
		super.create();
		persistentUpdate = true;

		add(bg = Create.backdrop(Path.image('menuBG'), [menuCam], 1.1));

		add(flashBG = Create.backdrop(Path.image('menuBGMagenta'), [menuCam], 1.1));
		flashBG.visible = false;

		for (val in Mods.all)
			modCount++;

		for (name in ['storymode', 'freeplay', 'mods', 'credits', 'merch', 'options'])
		{
			if (name == 'mods' && modCount == 0)
				continue;
			var option = Create.atlas(0, 0, Path.sparrow(name), [optionsCam]);
			option.animation.addByPrefix('selected', name + ' selected', 24, true);
			option.animation.addByPrefix('idle', name + ' idle', 24, true);
			option.animation.play('idle');
			option.updateHitbox();
			option.centerOffsets();
			add(option);
			menuOptions.push(option);
		}

		// TODO replace `target` with bezier in `update`
		for (i in 0...menuOptions.length)
			targets[i] = Misc.quadBezier(FlxPoint.weak(-FlxG.width * .25), FlxPoint.weak(FlxG.width * .5, FlxG.height * .5),
				FlxPoint.weak(-FlxG.width * .25, FlxG.height), i / (menuOptions.length - (modCount == 0 ? 2 : 2.5)));

		curSelected = prevSelected;
		changeSelection(0);

		var horizonEngineText = Create.text(5, FlxG.height - 55, 'Horizon Engine v${Application.current.meta["version"]} - build ${Main.horizonVer}', 24,
			Path.font('vcr'), 0xFFFFFFFF, LEFT)
			.setBorderStyle(OUTLINE, 0xFF000000, 2);
		horizonEngineText.cameras = [otherCam];
		add(horizonEngineText);

		var fnfVersion = Create.text(5, FlxG.height - 30, 'Friday Night Funkin\' v0.4.1', 24, Path.font('vcr'), 0xFFFFFFFF, LEFT)
			.setBorderStyle(OUTLINE, 0xFF000000, 2);

		fnfVersion.cameras = [otherCam];
		add(fnfVersion);

		Path.clearUnusedMemory();
	}

	public override function update(elapsed:Float):Void
	{
		for (i in 0...menuOptions.length)
		{
			var index = ((i + 1) - curSelected + menuOptions.length) % menuOptions.length;
			if (targets[index] != null)
			{
				menuOptions[i].x = FlxMath.lerp(menuOptions[i].x, targets[index].x, FlxMath.bound(elapsed * 10, 0, 1));
				menuOptions[i].y = FlxMath.lerp(menuOptions[i].y, targets[index].y, FlxMath.bound(elapsed * 10, 0, 1));
			}
		}
		super.update(elapsed);
	}

	public override function changeSelection(change:Int):Void
	{
		menuOptions[curSelected].x -= menuOptions[curSelected].width * .5;
		menuOptions[curSelected].animation.play('idle');
		menuOptions[curSelected].x += menuOptions[curSelected].width * .5;

		super.changeSelection(change);

		menuOptions[curSelected].x -= menuOptions[curSelected].width * .5;
		menuOptions[curSelected].animation.play('selected');
		menuOptions[curSelected].x += menuOptions[curSelected].width * .5;
	}

	public override function exitState():Void
	{
		super.exitState();
		transitioningOut = false;
		if (curSelected == (4 - (modCount == 0 ? 1 : 0)))
			Misc.openURL('https://needlejuicerecords.com/pages/friday-night-funkin');
		else
		{
			if (Settings.flashingLights)
				FlxFlicker.flicker(flashBG, 1.1, .15, false);
			optionsCam.follow(menuOptions[curSelected], LOCKON, .12);
			transitioningOut = true;

			FlxTween.tween(optionsCam, {zoom: 1.2}, 1, {
				ease: FlxEase.expoOut,
				type: ONESHOT,
			});
			FlxTween.tween(menuCam, {zoom: .9}, 1, {
				ease: FlxEase.expoOut,
				type: ONESHOT,
			});
			if (Settings.flashingLights)
				FlxFlicker.flicker(menuOptions[curSelected], 1.3, .06, false, false, flicker -> out());
			else
				FlxTimer.wait(1.3, () -> out());
			for (i in 0...menuOptions.length)
				if (i != curSelected)
					FlxTween.tween(menuOptions[i], {alpha: 0}, .3, {
						ease: FlxEase.quintOut,
						type: ONESHOT,
						onComplete: tween -> menuOptions[i].destroy()
					});
		}
	}

	public override function returnState():Void
	{
		super.returnState();
		MusicState.switchState(new TitleState());
	}

	inline function out():Void
		if (modCount == 0)
			switch (curSelected)
			{
				case 0:
					// MusicState.switchState(new StoryMenuState());
				case 1:
					// MusicState.switchState(new FreeplayState());
				case 3:
					// MusicState.switchState(new CreditsState());
				case 5:
					// MusicState.switchState(new OptionsState());
			}
		else
			switch (curSelected)
			{
				case 0:
					// MusicState.switchState(new StoryMenuState());
				case 1:
					// MusicState.switchState(new FreeplayState());
				case 2:
					MusicState.switchState(new ModsMenuState());
				case 3:
					// MusicState.switchState(new CreditsState());
				case 5:
					// MusicState.switchState(new OptionsState());
			}
}
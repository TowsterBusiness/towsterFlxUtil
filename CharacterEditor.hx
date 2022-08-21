package towsterFlxUtil;

import flixel.FlxSprite;
#if sys
import sys.FileSystem;
#end
import towsterFlxUtil.TowSprite.AnimationJson;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class CharacterEditor extends FlxState
{
	var spriteChanger:FlxText;
	var spriteChangerPointer:Int = 0;
	var spritePathList:Array<String> = [];
	var spriteJsonList:Array<String> = [];

	var tempXOffset:Int = 0;
	var tempYOffset:Int = 0;

	var scale:Float = 1;
	var scaleText:FlxText;

	var animationChanger:FlxText;
	var animationChangerPointer:Int = 0;
	var animationList:Array<String> = [];

	var character:TowSprite;

	var BG:Background;

	override function create()
	{
		super.create();

		#if sys
		if (!FileSystem.exists(TowPaths.getFilePath('data/characters')))
		{
			trace('please change this as necessary');
			return;
		}

		for (filePath in FileSystem.readDirectory(TowPaths.getFilePath('data/characters')))
		{
			var filePathSplit = filePath.split('.');

			if (filePathSplit.contains('json') && filePathSplit.length == 2)
			{
				var charJson:AnimationJson = TowPaths.getFile('characters/' + filePathSplit[0], JSON);
				spriteJsonList.push(filePathSplit[0]);
				spritePathList.push(charJson.imagePath);
			}
		}
		#else
		trace("please don't use flash for this");
		return;
		#end

		trace(spritePathList);
		trace(spriteJsonList);

		BG = new Background('day');
		add(BG);

		spriteChanger = new FlxText(10, 0, 0, spritePathList[0], 20);
		spriteChanger.autoSize = true;
		add(spriteChanger);

		animationChanger = new FlxText(10, 40, 0, '', 20);
		animationChanger.autoSize = true;
		add(animationChanger);

		scaleText = new FlxText(10, 80, 0, 'Scale: 1', 20);
		scaleText.autoSize = true;
		add(scaleText);

		character = new TowSprite(300, 100, spritePathList[0]);
		character.loadAnimations('characters/' + spriteJsonList[0]);
		add(character);

		updateAnimationList();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(spriteChanger) && FlxG.mouse.justPressed)
		{
			spriteChangerPointer++;
			spriteChangerPointer %= spritePathList.length;
			spriteChanger.text = spritePathList[spriteChangerPointer];
			updateCharacter();
			updateAnimationList();
			tempXOffset = 0;
			tempYOffset = 0;
		}

		if (FlxG.mouse.overlaps(animationChanger) && FlxG.mouse.justPressed)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				animationChangerPointer--;
				if (animationChangerPointer < 0)
					animationChangerPointer = animationList.length - 1;
			}
			else
			{
				animationChangerPointer++;
				animationChangerPointer %= animationList.length;
			}
			animationChanger.text = animationList[animationChangerPointer];
			character.playAnim(animationList[animationChangerPointer]);

			var charOffset = character.offsetMap.get(animationList[animationChangerPointer]);
			if (charOffset != null)
			{
				tempXOffset = Math.floor(charOffset[0]);
				tempYOffset = Math.floor(charOffset[1]);
			}
			else
			{
				tempXOffset = 0;
				tempYOffset = 0;
			}
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			character.playAnim(animationList[animationChangerPointer]);
		}

		if (FlxG.keys.anyJustPressed([UP, DOWN, RIGHT, LEFT]))
		{
			var multiplier:Int = FlxG.keys.pressed.SHIFT ? 10 : 1;

			if (FlxG.keys.justPressed.UP)
				tempYOffset += multiplier;
			if (FlxG.keys.justPressed.DOWN)
				tempYOffset -= multiplier;
			if (FlxG.keys.justPressed.RIGHT)
				tempXOffset -= multiplier;
			if (FlxG.keys.justPressed.LEFT)
				tempXOffset += multiplier;

			character.addOffset(animationList[animationChangerPointer], tempXOffset, tempYOffset);
			character.playAnim(animationList[animationChangerPointer]);

			haxe.Log.trace('=Animation=', {
				fileName: "",
				lineNumber: 0,
				className: "",
				methodName: "",
			});
			for (anim in animationList)
			{
				var tempOffset:Array<Float> = character.offsetMap.get(anim);
				if (tempOffset != null)
				{
					haxe.Log.trace(anim + ': ' + tempOffset[0] + ', ' + tempOffset[1], {
						fileName: "",
						lineNumber: 0,
						className: "",
						methodName: "",
					});
				}
			}
		}

		if (FlxG.keys.anyJustPressed([ONE, TWO]))
		{
			var multiplier:Float = FlxG.keys.pressed.SHIFT ? 0.01 : 0.1;

			if (FlxG.keys.justPressed.ONE)
				scale -= multiplier;
			if (FlxG.keys.justPressed.TWO)
				scale += multiplier;

			character.scale.set(scale, scale);
			character.updateHitbox();

			scaleText.text = 'Scale: ' + scale;
		}
	}

	function updateCharacter()
	{
		var charJson:AnimationJson = TowPaths.getFile('characters/' + spriteJsonList[spriteChangerPointer], JSON);
		character.animation.destroyAnimations();
		character.frames = TowPaths.getAnimation(charJson.imagePath);
		character.loadAnimations('characters/' + spriteJsonList[spriteChangerPointer]);
	}

	function updateAnimationList()
	{
		var charJson:AnimationJson = TowPaths.getFile('characters/' + spriteJsonList[spriteChangerPointer], JSON);
		animationList = [];
		for (anim in charJson.animation)
		{
			animationList.push(anim.name);
		}
		animationChangerPointer = 0;
		animationChanger.text = animationList[0];
		character.playAnim(animationList[0]);
	}
}

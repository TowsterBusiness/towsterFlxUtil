package towsterFlxUtil;

import flixel.FlxSprite;

typedef AnimationJson =
{
	var animation:Array<MovementJson>;
}

typedef MovementJson =
{
	var prefix:String;
	var name:String;
	var offset:Array<Int>;
	var isLoop:Bool;
	var flipX:Bool;
	var frameRate:Int;
}

class TowSprite extends FlxSprite
{
	var offsetMap:Map<String, Array<Float>>;

	public function new(x:Float, y:Float, path:String)
	{
		super(x, y);
		offsetMap = new Map<String, Array<Float>>();
		frames = TowPaths.getAnimation(path);
	}

	public function addOffset(name:String, x:Float, y:Float)
	{
		offsetMap.set(name, [x, y]);
	}

	public function playAnim(name:String)
	{
		animation.play(name);

		if (!offsetMap.exists(name))
		{
			updateHitbox();
			return;
		}

		var animOffset:Array<Float> = offsetMap.get(name);
		offset.set(animOffset[0], animOffset[1]);
	}

	public function loadAnimations(jsonPath:String)
	{
		var animationJson:AnimationJson = TowPaths.getFile(jsonPath, JSON);
		for (move in animationJson.animation)
		{
			animation.addByPrefix(move.name, move.prefix, move.frameRate, move.isLoop, move.flipX);
		}
	}
}
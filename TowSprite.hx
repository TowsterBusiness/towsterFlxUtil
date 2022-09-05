package towsterFlxUtil;

import flixel.FlxSprite;

typedef AnimationJson =
{
	var imagePath:String;
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
	public var offsetMap:Map<String, Array<Float>>;

	public function new(x:Float, y:Float, path:String, ?loadAnim:Bool = false)
	{
		super(x, y);
		offsetMap = new Map<String, Array<Float>>();

		if (loadAnim)
		{
			loadAnimations(path);
		}
		else
		{
			frames = TowPaths.getAnimation(path);
		}
	}

	public function addOffset(name:String, x:Float, y:Float)
	{
		offsetMap.set(name, [x, y]);
	}

	public function playAnim(name:String)
	{
		animation.play(name);
		updateHitbox();

		if (!offsetMap.exists(name))
			return;

		var animOffset:Array<Float> = offsetMap.get(name);
		offset.set(offset.x + animOffset[0], offset.y + animOffset[1]);
	}

	public function loadAnimations(jsonPath:String)
	{
		var animationJson:AnimationJson = TowPaths.getFile(jsonPath, JSON);

		frames = TowPaths.getAnimation(animationJson.imagePath);

		for (move in animationJson.animation)
		{
			animation.addByPrefix(move.name, move.prefix, move.frameRate, move.isLoop, move.flipX);
			addOffset(move.name, move.offset[0], move.offset[1]);
		}
	}
}

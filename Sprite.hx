package towsterFlxUtil;

import flixel.FlxSprite;

class Sprite extends FlxSprite
{
	var offsetMap:Map<String, Array<Float>>;

	public function new(x:Float, y:Float, path:String)
	{
		offsetMap = new Map<String, Array<Float>>();
		frames = Paths.getAnimation(path);
		super(x, y);
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
			offset.set(0, 0);
			return;
		}

		var animOffset:Array<Float> = offsetMap.get(name);
		offset.set(animOffset[0], animOffset[1]);
	}
}

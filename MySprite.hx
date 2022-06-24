import flixel.FlxSprite;

class MySprite extends FlxSprite
{
	var offsetMap:Map<String, Array<Float>>;

	public function new(x:Float, y:Float, path:String)
	{
		offsetMap = new Map<String, Array<Float>>();
		super(x, y);
		frames = Paths.getAnimation('button');
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

package towsterFlxUtil;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	/**
	 * assets/images/"path".png
	 * &
	 * assets/images/"path".xml
	**/
	static public function getAnimation(path:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow('assets/images/' + path + '.png', 'assets/images/' + path + '.xml');
	}

	static public function imagePath(name:String):String
	{
		return 'assets/images/' + name + '.png';
	}
}

package towsterFlxUtil;

import flixel.FlxObject;
import flixel.text.FlxText;

class TowUtils
{
	public static var windowWidth:Float = 640;
	public static var windowHeight:Float = 480;

	static var traceTextNum:Int = 0;

	public static function traceText(message:String):FlxText
	{
		traceTextNum++;
		var text = new FlxText(30, 15 * traceTextNum, -1, message);
		return text;
	}

	/**
		outsPuts Either a Float or int
	**/
	public static function percentFromHeight(percent:Float, ?doesRoundToInt = false):Float
	{
		return percent * windowHeight;
	}

	public static function percentFromWidth(percent:Float, ?doesRoundToInt = false):Float
	{
		return percent * windowWidth;
	}

	public static function debug(obj:FlxObject, ?id:String)
	{
		if (id == null)
			trace(obj.x + ' , ' + obj.y);
		else
			trace(id + ': ' + obj.x + ' , ' + obj.y);
	}
}

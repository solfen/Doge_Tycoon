package externs;

//ScenesManger can load new scenes just with a scene name

@:native("FB")
extern class FB 
{	
	public static function getLoginStatus(callback:Dynamic):Void;
	public static function ui(params:Dynamic={},callback:Dynamic):Void;

}
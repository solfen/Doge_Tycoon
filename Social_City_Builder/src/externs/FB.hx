package externs;

@:native("FB")
extern class FB 
{	
	public static function getLoginStatus(callback:Dynamic):Void;
	public static function ui(params:Dynamic={},callback:Dynamic):Void;
	public static function login(params:Dynamic={},callback:Dynamic):Void;
	public static function api(request:String, type:String, params:Dynamic={},callback:Dynamic):Void;

}
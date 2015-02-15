package utils.events;

/**
 * I've absolutely no idea what this class does but it seems important (maxime)
 * @author Mathieu ANTHOINE
 */
class Event
{
	public static inline var COMPLETE: String="Event.COMPLETE";
	public static inline var GAME_LOOP: String = "Event.GAME_LOOP";
	public static inline var RESIZE: String = "Event.RESIZE";

	// les getter/setter c'est moisi avec Reflect.field, ca retourne la variable privée
	public var type : String;
	public var target : Dynamic;

	public function new ( pType: String ) { 
		type = pType;
	}

	private function formatToString (pArgs:Array<String>):String { 
		var lCompleteClassName : String = Type.getClassName(Type.getClass(this));
		var lPackage:Int = lCompleteClassName.lastIndexOf(".");
		
		var lClassName: String = lPackage ==-1 ? lCompleteClassName : lCompleteClassName.substr(lPackage + 1);
		
		var lTxt:String = "[" + lClassName;
		for ( i in 0...pArgs.length) lTxt +=" "+pArgs[i]+"="+Reflect.field(this,pArgs[i]);
		return lTxt + "]";	
		
	}
	
	public function toString (): String { 
		return formatToString(["type"]);
	}
	
}
package com.isartdigital.utils.events;

/**
 * ...
 * @author Mathieu ANTHOINE
 */
class GameStageEvent extends Event
{

	public static inline var RESIZE: String="GameStageEvent.RESIZE";	
	
	public var width : Int;
	public var height : Int;
	
	
	public function new(pType:String,pWidth:Int,pHeight:Int) 
	{
		super(pType);
		width = pWidth;
		height = pHeight;
	}
	
	override public function toString (): String { 
		return formatToString(["type","width","height"]);
	}
	
}
package com.isartdigital.myGame.ui.popin;
import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.myGame.ui.popin.PopinManager;
import pixi.InteractionData;

//PopinBuild is lauched on HudBuild click
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinBuild extends MyPopin
{
	private static var instance: PopinBuild;

	public static function getInstance (?startX:Float,?startY:Float, ?texture:String): PopinBuild {
		if (instance == null) instance = new PopinBuild(startX,startY, texture);
		return instance;
	}
	
	private function new(?startX:Float,?startY:Float, ?texture:String) 
	{
		super(startX,startY, texture);
		addIcon(0,0,"closeButton","closeButton");
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target.name == "closeButton"){
			PopinManager.getInstance().closePopin("PopinBuild");
		}
	}
}
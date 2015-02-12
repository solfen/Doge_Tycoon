package com.isartdigital.myGame.ui.popin;

import com.isartdigital.Main;
import com.isartdigital.myGame.ui.popin.PopinBuild;
import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.utils.events.GameStageEvent;
import pixi.InteractionData;

// HudManger serves as a container for the HUD, spwans the HudIcons and manage the resize
class PopinManager extends pixi.display.DisplayObjectContainer
{
	private static var instance: PopinManager;
	private var childs:Map<String, MyPopin> = new Map();
	//private var currentChild: MyPopin;

	public static function getInstance (): PopinManager {
		if (instance == null) instance = new PopinManager();
		return instance;
	}	
	
	public function new()  {
		super();
		Main.getInstance().getStage().addChild(this);
	}
	

	private function onResize (pEvent:GameStageEvent=null): Void { // A VENIR ?

	}

	//instantiate any popIn just with its name so that anywhere in the code we can open a popin just by doing PopinManager.getInstance().openPopin("popinName")
	public function openPopin(popinName:String, ?pX:Float, ?pY:Float){
		childs[popinName] = Type.createInstance( Type.resolveClass("com.isartdigital.myGame.ui.popin."+popinName), [pX,pY] );
		addChild(childs[popinName]);
	}
	public function closePopin(popinName:String){
		removeChild(childs[popinName]);
		childs.remove(popinName);
	}
	public function closeAllPopin(){
		for(key in childs.keys()){
			removeChild(childs[key]);
	 	}
	 	childs = new Map();
	}

	// removes all childs then 
	public function destroy (): Void {
		closeAllPopin();
		Main.getInstance().getStage().removeChild(this);
		instance = null;
	}

}
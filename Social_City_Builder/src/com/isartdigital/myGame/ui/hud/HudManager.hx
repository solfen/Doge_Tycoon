package com.isartdigital.myGame.ui.hud;

import com.isartdigital.Main;
import com.isartdigital.myGame.ui.hud.HudBuild;
import com.isartdigital.myGame.ui.IconHud;
import com.isartdigital.utils.events.GameStageEvent;
import pixi.InteractionData;

// HudManger serves as a container for the HUD, spwans the HudIcons and manage the resize
class HudManager extends pixi.display.DisplayObjectContainer
{
	private static var instance: HudManager;
	private var childs:Array<IconHud> = [];
	private var currentChild: IconHud;

	public static function getInstance (): HudManager {
		if (instance == null) instance = new HudManager();
		return instance;
	}	
	
	public function new()  {
		super();
		interactive = true;
		click = onClick;

		//childs creation
		currentChild = new HudBuild(50,50);
		childs.push(currentChild);
		addChild(currentChild);		
		childs.push(new HudBuild(0,0));
		addChild(childs[childs.length-1]);
		Main.getInstance().getStage().addChild(this);
	}
	

	private function onResize (pEvent:GameStageEvent=null): Void { // A VENIR ?

	}
	private function onClick (pData:InteractionData): Void{
		destroy();
	}

	// removes all childs then 
	public function destroy (): Void {
	 	for(i in 0...childs.length){
			removeChild(childs[i]);
	 	}
	 	childs = []; // destroys all the childs
		Main.getInstance().getStage().removeChild(this); // a voir si ce n'est pas celui qui destroy le HUD qui le remove aussi
		instance = null;
	}

}
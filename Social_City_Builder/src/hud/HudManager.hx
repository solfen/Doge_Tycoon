package hud;

import hud.HudBuild;
import hud.IconHud;
import pixi.display.DisplayObjectContainer;

// HudManger serves as a container for the HUD, spwans the HudIcons and manage the resize
class HudManager extends DisplayObjectContainer
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

		//childs creation
		currentChild = new HudBuild(50,50);
		childs.push(currentChild);
		addChild(currentChild);
	}
	
	// removes all childs then put its instance to null
	public function destroy (): Void {
	 	for(i in 0...childs.length){
			removeChild(childs[i]);
	 	}
	 	childs = []; // destroys all the childs
		instance = null;
	}

}
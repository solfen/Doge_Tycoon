package hud;

import hud.HudBuild;
import hud.HudInventory;
import hud.HudShop;
import hud.HudQuests;
import hud.HudOptions;
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

		//childs creation the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		newChild(new HudBuild(0.95,0.95));
		newChild(new HudInventory(0.9,0.95));
		newChild(new HudShop(0.85,0.95));
		newChild(new HudQuests(0.80,0.95));
		newChild(new HudOptions(0.95,0.05));

	}
	
	// removes all childs then put its instance to null
	public function destroy (): Void {
	 	for(i in 0...childs.length){
			removeChild(childs[i]);
	 	}
	 	childs = []; // destroys all the childs
		instance = null;
	}
	private function newChild(child:IconHud){
		childs.push(child);
		addChild(child);
	}

}
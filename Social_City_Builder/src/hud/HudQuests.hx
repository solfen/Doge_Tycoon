package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudQuests extends IconHud
{
	private static var instance: HudQuests;
	private var ftue3:Bool = false;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconQuestNormal.png','HudIconQuestActive.png');		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		var curName:String = PopinManager.getInstance().getCurrentPopinName();
		if(curName != "PopinInventory"){
			PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinQuests"){
			PopinManager.getInstance().openPopin("PopinQuests", 0.5, 0.55);
			if(!ftue3){
				var ftueParam:Map<String, Dynamic> = ['ftueIndex' => 2];
				PopinManager.getInstance().addPopinToQueue("PopinFTUE",0.5,0.5,ftueParam);
				ftue3 = true;
			}
		}
	}	
}
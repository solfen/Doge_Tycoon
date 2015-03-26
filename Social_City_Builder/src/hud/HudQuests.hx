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

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconQuestNormal.png','HudIconQuestActive.png');		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		if(PopinManager.getInstance().getCurrentPopinName() != "PopinInventory"){
			PopinManager.getInstance().closeCurentPopin();
		}
		PopinManager.getInstance().openPopin("PopinQuests", 0.5, 0.5);
	}	
}
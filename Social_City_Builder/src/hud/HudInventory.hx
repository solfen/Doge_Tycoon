package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudInventory extends IconHud
{
	private static var instance: HudInventory;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudIconInventoryNormal.png',"assets/UI/Hud/HudIconInventoryActive.png");		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		PopinManager.getInstance().openPopin("PopinInventory", 0.5, 0.5);
	}
}
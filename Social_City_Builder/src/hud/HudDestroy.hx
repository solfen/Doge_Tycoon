package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import hud.HudManager;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudDestroy extends IconHud
{
	private static var instance: HudDestroy;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconDestroyNormal.png',"HudIconDestroyActive.png");		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		GameInfo.isDestroyMode ? changeTexture("normal") : changeTexture("active");
		GameInfo.isDestroyMode ? HudManager.getInstance().setChildText("modInfo","") : HudManager.getInstance().setChildText("modInfo","[MODE : DESTRUCTION]");
		GameInfo.isDestroyMode = !GameInfo.isDestroyMode;
		GameInfo.isUpgradeMode = false;
		HudManager.getInstance().setChildTexture("HudUpgrade", 'normal');
		trace(GameInfo.isDestroyMode);
	}
}
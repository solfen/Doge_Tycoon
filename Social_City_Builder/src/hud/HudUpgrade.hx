package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;

// HudUpgrade is the Upgrade icon of the Hud, it opens the select the upgrade mode
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudUpgrade extends IconHud
{
	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconUpgradeNormal.png',"HudIconUpgradeActive.png");
	}
	
	override private function onClick (pData:InteractionData) : Void {
		trace(GameInfo.isUpgradeMode);
		GameInfo.isUpgradeMode ? changeTexture("normal") : changeTexture("active") ;
		GameInfo.isUpgradeMode = !GameInfo.isUpgradeMode;
		GameInfo.isDestroyMode = false;
		hud.HudManager.getInstance().setChildTexture("HudDestroy", 'normal');
	}
}
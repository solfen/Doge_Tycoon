package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudMarket extends IconHud
{
	private static var instance: HudMarket;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconMarketNormal.png',"HudIconMarketActive.png");
	}
	
	override private function onClick (pData:InteractionData) : Void {
		var curName:String = PopinManager.getInstance().getCurrentPopinName();
		if(curName != null){
			PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinMarket") {
			PopinManager.getInstance().openPopin("PopinMarket", 0.5, 0.55);
			PopinManager.getInstance().openPopin("PopinInventory", 0.9, 0.55);
			
		}
	}
}
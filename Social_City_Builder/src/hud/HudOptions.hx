package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudOptions extends IconHud
{
	private var isPlaying:Bool = true;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudIconOptionNormal.png',"HudIconOptionActive.png");		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		if(isPlaying){
			Main.getInstance().music.pause();
			isPlaying = false;
		}
		else {
			Main.getInstance().music.play();
			isPlaying = true;
		}
		var curName:String = PopinManager.getInstance().getCurrentPopinName();
		if(curName != "PopinInventory")
			PopinManager.getInstance().closeCurentPopin();
	}
}
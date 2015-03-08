package hud;

import hud.IconHud;
import utils.system.DeviceCapabilities;
import popin.PopinManager;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
// if the change texture repeats itself among all the HUD it will be put in IconHUD
class HudBuild extends IconHud
{
	private static var instance: HudBuild;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudIconBuildNormal.png',"assets/UI/Hud/HudIconBuildActive.png");		
		interactive = true;
		buttonMode 	= true;
		click 		= onClick;
		mouseover 	= onMouseOver;
		mouseout  	= onMouseOut;
	}
	
	private function onClick (pData:InteractionData) : Void {
		PopinManager.getInstance().openPopin("PopinBuild", 0.5, 0.5);
	}
	private function onMouseOver (pData:InteractionData): Void {
		changeTexture("active");
	}
	private function onMouseOut (pData:InteractionData): Void {
		changeTexture("normal");
	}
}
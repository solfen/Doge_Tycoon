package hud;

import hud.IconHud;
import utils.system.DeviceCapabilities;
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
		super(startX,startY,'assets/UI/Hud/HudIconQuestNormal.png','assets/UI/Hud/HudIconQuestActive.png');		
		interactive = true;
		buttonMode 	= true;
		click 		= onClick;
		mouseover 	= onMouseOver;
		mouseout  	= onMouseOut;
	}
	
	private function onClick (pData:InteractionData) : Void {
		PopinManager.getInstance().openPopin("PopinBuild", DeviceCapabilities.width/2, DeviceCapabilities.height/2);
	}	
	private function onMouseOver (pData:InteractionData): Void {
		changeTexture("active");
	}
	private function onMouseOut (pData:InteractionData): Void {
		changeTexture("normal");
	}
}
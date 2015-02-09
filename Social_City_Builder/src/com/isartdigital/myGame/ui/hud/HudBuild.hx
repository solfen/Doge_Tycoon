package com.isartdigital.myGame.ui.hud;
import com.isartdigital.myGame.ui.IconHud;
import com.isartdigital.myGame.ui.popin.PopinBuild;
import com.isartdigital.utils.game.GameStage;
import pixi.InteractionData;

// HudBuild is the BuildIcon of the Hud, it opens the build menu
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudBuild extends IconHud
{
	private static var instance: HudBuild;

	private function new(startX:Float,startY:Float, ?texture:String) 
	{
		super(startX,startY, texture);
	}

	// IconHud has already binded the click on the method Onclick so we just have to overide it to code the action
	override private function onClick (pData:InteractionData) : Void {
		//UIManager.getInstance().openPopin(PopinBuild.getInstance());
	}	
}
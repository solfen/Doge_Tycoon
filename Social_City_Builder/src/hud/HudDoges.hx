package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.text.Text;

// HudDoges is the workers bar of the Hud, it display the current number of workers
// Doges because the game should have been all about doges
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudDoges extends IconHud
{
	private var hardMoneyText:Text;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudPopFillBar.png');
		hardMoneyText = new Text(GameInfo.hardMoney+'', {font:"35px FuturaStdHeavy",fill:"white"});
		hardMoneyText.position.x = width*0.95 - hardMoneyText.width;
		hardMoneyText.position.y = height/2 - hardMoneyText.height/2; 	
		addChild(hardMoneyText);
	}	
}
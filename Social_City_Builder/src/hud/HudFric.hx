package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.text.Text;

// HudFric is the soft money bar of the Hud, it display the current number of soft money
// fric car fric = pognon référence 3615 Usul
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudFric extends IconHud
{
	private var fricText:Text;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudMoneySoft.png');
		fricText = new Text(GameInfo.fric+'', {font:"35px FuturaStdHeavy",fill:"white"});
		fricText.position.x = width*0.95 - fricText.width;
		fricText.position.y = height/2 - fricText.height/2; 	
		addChild(fricText);
	}	
}
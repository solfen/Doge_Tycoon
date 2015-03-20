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
	private var dogeNumberText:Text;
	private var lastDogeNumber:Float = GameInfo.dogeNumber;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudPopFillBar.png',null,null,true);
		dogeNumberText = new Text(lastDogeNumber+'', {font:"35px FuturaStdHeavy",fill:"white"});
		dogeNumberText.position.x = Std.int(width*0.95 - dogeNumberText.width);
		dogeNumberText.position.y = Std.int(height/2 - dogeNumberText.height/2); 	
		addChild(dogeNumberText);
	}
	override public function updateInfo(){
		if(lastDogeNumber != GameInfo.dogeNumber){
			lastDogeNumber = GameInfo.dogeNumber;
			dogeNumberText.setText(lastDogeNumber+'');
		}
	}	
}
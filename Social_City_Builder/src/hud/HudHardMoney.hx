package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.text.Text;

// HudHardMoney is the hard money bar of the Hud, it display the current number of soft money
// fric car fric = pognon référence 3615 Usul
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudHardMoney extends IconHud
{
	private var hardMoneyText:Text;
	private var lastHardMoney:Float = GameInfo.hardMoney;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudMoneyHard.png');
		hardMoneyText = new Text(lastHardMoney+'', {font:"35px FuturaStdHeavy",fill:"white"});
		hardMoneyText.position.x = Std.int(width*0.95 - hardMoneyText.width);
		hardMoneyText.position.y = Std.int(height/2 - hardMoneyText.height/2); 	
		addChild(hardMoneyText);
	}
	override public function updateInfo(){
		if(lastHardMoney != GameInfo.hardMoney){
			lastHardMoney = GameInfo.hardMoney;
			hardMoneyText.setText(lastHardMoney+'');
		}
	}	
}
package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.text.Text;
import pixi.display.Sprite;
import pixi.textures.Texture;

// HudDoges is the workers bar of the Hud, it display the current number of workers
// Doges because the game should have been all about doges
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudDoges extends IconHud
{
	private var dogeNumberText:Text;
	private var lastDogeNumber:Float;
	private var lastDogeMaxNumber:Float;
	private var dogeIcon:Sprite;
	private var barFill:Sprite;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudPopFillBar.png',null,true,false);

		barFill = new Sprite(Texture.fromFrame('HudPopFill.png'));
		barFill.position.set(Std.int(0.23*width),Std.int(0.3*height));
		barFill.width = Std.int(lastDogeNumber/lastDogeMaxNumber * width*.725);
		addChild(barFill);

		dogeIcon = new Sprite(Texture.fromFrame('HudIconPop.png'));
		dogeIcon.position.set(0,Std.int(0.05*height));
		addChild(dogeIcon);

		dogeNumberText = new Text('', {font:"22px FuturaStdHeavy",fill:"white"});
		addChild(dogeNumberText);
		updateInfo();
	}
	override public function updateInfo(){
		if(lastDogeNumber != GameInfo.ressources['doges'].userPossesion || lastDogeMaxNumber != GameInfo.dogeMaxNumber){
			lastDogeNumber = GameInfo.ressources['doges'].userPossesion;
			lastDogeMaxNumber = GameInfo.dogeMaxNumber;
			barFill.width = Std.int(Std.int(lastDogeNumber)/lastDogeMaxNumber * width*.72);
			dogeNumberText.setText(Std.int(lastDogeNumber)+'/'+Std.int(lastDogeMaxNumber));
			var xPos:Float = Math.max(dogeIcon.x+dogeIcon.width,barFill.width-dogeNumberText.width+barFill.x-width*0.02);
			dogeNumberText.position.set(Std.int(xPos),Std.int(height/1.8 - dogeNumberText.height/2));
		}
	}	
}
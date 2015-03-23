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
	private var lastFric:Float = GameInfo.ressources['fric'].userPossesion;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudMoneySoft.png',null,true,false);
		fricText = new Text(lastFric+'', {font:"35px FuturaStdHeavy",fill:"white"});
		fricText.position.x = Std.int(width*0.95 - fricText.width);
		fricText.position.y = Std.int(height/2 - fricText.height/2); 	
		addChild(fricText);
		updateInfo();
	}
	override public function updateInfo(){
		if(lastFric != GameInfo.ressources['fric'].userPossesion){
			lastFric = GameInfo.ressources['fric'].userPossesion;
			fricText.setText(lastFric+'');
		}
	}	
}
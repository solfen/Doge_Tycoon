package hud;

import hud.IconHud;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.text.Text;

// HudStock is the workers bar of the Hud, it display the current number of workers
// Doges because the game should have been all about doges
// IconHud is a pixi.Sprite tuned for the HUD use.
class HudStock extends IconHud
{
	private var stockPercentText:Text;
	private var lastStockPercent:Float = GameInfo.stockPercent;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'assets/UI/Hud/HudPopFillBar.png',null,null,true);
		stockPercentText = new Text(lastStockPercent+'%', {font:"35px FuturaStdHeavy",fill:"white"});
		stockPercentText.position.x = Std.int(width*0.95 - stockPercentText.width);
		stockPercentText.position.y = Std.int(height/2 - stockPercentText.height/2); 	
		addChild(stockPercentText);
	}
	override public function updateInfo(){
		if(lastStockPercent != GameInfo.stockPercent){
			lastStockPercent = GameInfo.stockPercent;
			stockPercentText.setText(lastStockPercent+'%');
		}
	}
}
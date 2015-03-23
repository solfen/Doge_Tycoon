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
class HudStock extends IconHud
{
	private var lastStockPercentText:Text;
	private var lastStockPercent:Float;
	private var inventoryIcon:Sprite;
	private var barFill:Sprite;

	private function new(startX:Float,startY:Float) 
	{
		//the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		super(startX,startY,'HudInventoryFillBar.png',null,true,false);

		barFill = new Sprite(Texture.fromImage('HudInventoryFill.png'));
		barFill.position.set(Std.int(0.23*width),Std.int(0.3*height));
		barFill.width = Std.int(lastStockPercent/100 * width*.725);
		addChild(barFill);

		inventoryIcon = new Sprite(Texture.fromImage('HudIconInventory.png'));
		inventoryIcon.position.set(0,Std.int(0.05*height));
		addChild(inventoryIcon);

		lastStockPercentText = new Text('', {font:"22px FuturaStdHeavy",fill:"white"});
		addChild(lastStockPercentText);
		updateInfo();
	}
	override public function updateInfo(){
		if(lastStockPercent != GameInfo.stockPercent){
			lastStockPercent = GameInfo.stockPercent;
			barFill.width = Std.int(lastStockPercent/100 * width*.72);
			lastStockPercentText.setText(lastStockPercent+'%');
			var xPos:Float = Math.max(inventoryIcon.x+inventoryIcon.width,barFill.width-lastStockPercentText.width+barFill.x-width*0.02);
			lastStockPercentText.position.set(Std.int(xPos),Std.int(height/1.8 - lastStockPercentText.height/2));
		}
	}	
}
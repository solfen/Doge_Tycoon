package com.isartdigital.myGame.ui.popin;
import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.utils.game.GameStage;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

/**
 * ...
 * @author PIF
 */
class IconPopinBuild extends Sprite
{

	public function new(startX:Float,startY:Float,name:String) 
	{
		super(Texture.fromImage("assets/"+name+".png"));
		x = startX;
		y = startY;
		width = 50;
		height= 50;
		interactive = true;
		buttonMode = true;
		click = onClick;
	}
	
	private function onClick (pData:InteractionData) : Void {
		trace("little imouto click");
	}	
}
package com.isartdigital.myGame.ui;

import com.isartdigital.utils.ui.Hud;
import com.isartdigital.utils.ui.UIComponent;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

/**
 * ...
 * @author PIF
 */
class MyHud extends Hud
{

	private var background:Sprite;	
	
	public function new() 
	{
		super();
		var lCompleteClassName : String = Type.getClassName(Type.getClass(this));
		var lClassName: String = lCompleteClassName.substr(lCompleteClassName.lastIndexOf(".") + 1);
		background = new Sprite(Texture.fromImage("assets/"+lClassName+".png"));
		background.anchor.set(0.5, 0.5);
		addChild(background);
		interactive = true;
		buttonMode = true;
		set_modal(false);
		click = onClick;
		mouseover  = onMouseOver;
	}
	
	private function onClick (pData:InteractionData): Void { // TODO ouvrir popin
		trace ("click hud");
	}	
	private function onMouseOver (pData:InteractionData): Void { //TODO time counter then show tooltip
		trace ("over hud");
	}
	
}
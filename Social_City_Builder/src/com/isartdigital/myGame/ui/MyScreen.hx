package com.isartdigital.myGame.ui;

import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIComponent;
import pixi.display.Sprite;
import pixi.InteractionData;
import pixi.textures.Texture;

/**
 * ...
 * @author Mathieu ANTHOINE
 */
class MyScreen extends Screen
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
		click = onClick;
	}
	
	private function onClick (pData:InteractionData): Void {
		trace ("click screen");
	}
	
}
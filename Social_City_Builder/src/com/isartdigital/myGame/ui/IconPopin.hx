package com.isartdigital.myGame.ui;

import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

// IconPopin is a pixi.Sprite tuned for the Popin use.
// Right now it's the same as IconHud but if in the future we have to change only the popins icons, it will be easier
class IconPopin extends Sprite
{
	private var name:String;
	public function new(pX:Float,pY:Float, pTexturePath:String,pName:String,isInteractive:Bool) 
	{
		super(Texture.fromImage("assets/"+pTexturePath+".png"));
		x = pX;
		y = pY;
		name = pName;
		interactive = isInteractive;
		buttonMode = isInteractive;
	}
}
package com.isartdigital.myGame.ui.screens;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.textures.Texture;

class LoaderScene extends DisplayObjectContainer 
{
	private static var instance: LoaderScene;

	public static function getInstance (): LoaderScene {
		if (instance == null) instance = new LoaderScene();
		return instance;
	}	
	
	public function new() 
	{
		super();
		x=0;
		y=0;
		addChild(new Sprite(Texture.fromImage("assets/LoaderScene.png")));
	}
	
}
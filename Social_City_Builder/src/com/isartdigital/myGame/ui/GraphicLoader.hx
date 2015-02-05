package com.isartdigital.myGame.ui;

import com.isartdigital.utils.ui.Screen;
import pixi.display.Sprite;
import pixi.textures.Texture;

/**
 * Preloader Graphique (fichier myGame.fla)
 * @author Mathieu ANTHOINE
 */
class GraphicLoader extends Screen 
{
	
	/**
	 * instance unique de la classe GraphicLoader
	 */
	private static var instance: GraphicLoader;

	public var loaderBar:Sprite;

	public function new() 
	{
		super();
		var lBg:Sprite = new Sprite(Texture.fromImage("assets/preload_bg.png"));
		lBg.anchor.set(0.5, 0.5);
		addChild(lBg);
		
		loaderBar = new Sprite (Texture.fromImage("assets/preload.png"));
		loaderBar.anchor.y = 0.5;
		loaderBar.x = -loaderBar.width / 2;
		addChild(loaderBar);
		loaderBar.scale.x = 0;
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GraphicLoader {
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}
	
	public function update (pProgress:Float): Void {
		loaderBar.scale.x = pProgress;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
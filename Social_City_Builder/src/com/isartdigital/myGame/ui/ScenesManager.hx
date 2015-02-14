package com.isartdigital.myGame.ui;
import pixi.display.DisplayObjectContainer;
import com.isartdigital.myGame.ui.screens.LoaderScene;

/**
 * Classe d'Ecran
 * Tous les écrans d'interface héritent de cette classe
 * @author Mathieu ANTHOINE
 */
class ScenesManager 
{
	private static var instance: ScenesManager;
	private var currentScene:DisplayObjectContainer;
	private var isThereAScene:Bool;
	
	public static function getInstance (): ScenesManager {
		if (instance == null) {
			instance = new ScenesManager();
		}
		return instance;
	}
	
	public function new () {

	}
	public function loadScene (sceneName:String){
		if(isThereAScene){
			Main.getInstance().getStage().removeChild(currentScene);
		}
		currentScene = Type.createInstance( Type.resolveClass("com.isartdigital.myGame.ui.screens."+sceneName), [] );
		Main.getInstance().getStage().addChild(currentScene);
		isThereAScene = true;
	}
	
}
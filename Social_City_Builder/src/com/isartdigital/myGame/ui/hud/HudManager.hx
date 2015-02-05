package com.isartdigital.myGame.ui.hud;

import com.isartdigital.myGame.ui.UIManager;
import com.isartdigital.myGame.ui.hud.HudBuild;
import com.isartdigital.utils.events.GameStageEvent;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPosition;
import pixi.display.Sprite;
import pixi.textures.Texture;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Mathieu ANTHOINE
 */
class HudManager extends Screen 
{
	
	/**
	 * instance unique de la classe Hud
	 */
	private static var instance: HudManager;
	private var _UIManager:UIManager;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HudManager {
		if (instance == null) instance = new HudManager();
		return instance;
	}	
	
	public function new() 
	{
		super();
		_UIManager = UIManager.getInstance();
		_modal = false;
		_UIManager.openHud(HudBuild.getInstance());
		HudBuild.getInstance().x = GameStage.getInstance().width;
		HudBuild.getInstance().y = GameStage.getInstance().height;
	}
	
	/**
	 * repositionne les éléments du Hud
	 * @param	pEvent
	 */
	override private function onResize (pEvent:GameStageEvent=null): Void {

	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
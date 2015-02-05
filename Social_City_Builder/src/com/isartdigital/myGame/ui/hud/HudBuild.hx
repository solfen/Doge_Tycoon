package com.isartdigital.myGame.ui.hud;
import com.isartdigital.myGame.ui.MyHud;
import com.isartdigital.myGame.ui.popin.PopinBuild;
import com.isartdigital.utils.game.GameStage;
import pixi.InteractionData;
/**
 * ...
 * @author PIF
 */
class HudBuild extends MyHud
{

/**
	 * instance unique de la classe Popin0
	 */
	private static var instance: HudBuild;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HudBuild {
		if (instance == null) instance = new HudBuild();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		UIManager.getInstance().openPopin(PopinBuild.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}
	
}
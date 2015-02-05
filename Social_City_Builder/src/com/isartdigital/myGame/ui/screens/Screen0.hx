package com.isartdigital.myGame.ui.screens ;
import pixi.InteractionData;

	
/**
 * ...
 * @author Mathieu ANTHOINE
 */
class Screen0 extends MyScreen 
{
	
	/**
	 * instance unique de la classe Screen0
	 */
	private static var instance: Screen0;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Screen0 {
		if (instance == null) instance = new Screen0();
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
		super.onClick(pData);
		UIManager.getInstance().openScreen(Screen1.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
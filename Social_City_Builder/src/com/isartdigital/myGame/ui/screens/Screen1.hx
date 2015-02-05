package com.isartdigital.myGame.ui.screens ;
import com.isartdigital.myGame.game.GameManager;
import pixi.InteractionData;

	
/**
 * ...
 * @author Mathieu ANTHOINE
 */
class Screen1 extends MyScreen 
{
	
	/**
	 * instance unique de la classe Screen1
	 */
	private static var instance: Screen1;

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();		
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Screen1 {
		if (instance == null) instance = new Screen1();
		return instance;
	}
	
	override private function onClick (pData:InteractionData) : Void {
		super.onClick(pData);
		GameManager.getInstance().start();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
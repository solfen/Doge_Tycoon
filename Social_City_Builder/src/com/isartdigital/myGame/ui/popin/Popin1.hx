package com.isartdigital.myGame.ui.popin;
import com.isartdigital.myGame.ui.MyPopin;
import pixi.InteractionData;
	
/**
 * ...
 * @author Mathieu ANTHOINE
 */
class Popin1 extends MyPopin 
{
	
	/**
	 * instance unique de la classe Popin1
	 */
	private static var instance: Popin1;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Popin1 {
		if (instance == null) instance = new Popin1();
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
		UIManager.getInstance().openPopin(PopinOkCancel.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
package com.isartdigital.myGame.ui.popin;

import pixi.InteractionData;

	
/**
 * ...
 * @author Mathieu ANTHOINE
 */
class PopinOkCancel extends MyPopin 
{
	
	/**
	 * instance unique de la classe PopinOkCancel
	 */
	private static var instance: PopinOkCancel;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PopinOkCancel {
		if (instance == null) instance = new PopinOkCancel();
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
		//super.onClick(pData);
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
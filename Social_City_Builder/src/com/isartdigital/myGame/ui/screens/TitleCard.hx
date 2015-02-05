package com.isartdigital.myGame.ui.screens ;

import com.isartdigital.myGame.ui.UIManager;
import pixi.InteractionData;

/**
 * Ecran principal
 * @author Mathieu ANTHOINE
 */
class TitleCard extends MyScreen
{
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}

	public function new() 
	{
		super();
	}
	
	override private function onClick (pData:InteractionData) : Void {
		super.onClick(pData);
		UIManager.getInstance().openScreen(Screen0.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
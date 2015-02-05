package com.isartdigital.myGame.ui.popin;

import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.utils.game.GameStage;
import pixi.InteractionData;

	
/**
 * ...
 * @author Mathieu ANTHOINE
 */
class Popin0 extends MyPopin 
{
	
	/**
	 * instance unique de la classe Popin0
	 */
	private static var instance: Popin0;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Popin0 {
		if (instance == null) instance = new Popin0();
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
		var lPopin:MyPopin = Math.random()<0.5 ? PopinOkCancel.getInstance() : Popin1.getInstance() ;
		
		UIManager.getInstance().openPopin(lPopin);
		lPopin.x = Math.random() * GameStage.getInstance().safeZone.width-GameStage.getInstance().safeZone.width/2;
		lPopin.y = Math.random() * GameStage.getInstance().safeZone.height-GameStage.getInstance().safeZone.height/2;
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}
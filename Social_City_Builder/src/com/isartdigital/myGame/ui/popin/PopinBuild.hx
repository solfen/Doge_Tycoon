package com.isartdigital.myGame.ui.popin;
import com.isartdigital.myGame.ui.popin.IconPopinBuild;
import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.utils.game.GameStage;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

/**
 * ...
 * @author PIF
 */
class PopinBuild extends MyPopin
{
	private var child:Sprite;

	private static var instance: PopinBuild;


	public static function getInstance (): PopinBuild {
		if (instance == null) instance = new PopinBuild();
		return instance;
	}
	
	private function new() 
	{
		super();
		x = 0;
		y = 0;
		width = 1;
		height = 1;

		child = new IconPopinBuild(0,0,"HudBuild");
		addChild(child);
		
	}
	
	override private function onClick (pData:InteractionData) : Void {
		trace("big onichan click");
		/*var lPopin:MyPopin = PopinOkCancel.getInstance();
		UIManager.getInstance().openPopin(lPopin);
		lPopin.x = Math.random() * GameStage.getInstance().safeZone.width-GameStage.getInstance().safeZone.width/2;
		lPopin.y = Math.random() * GameStage.getInstance().safeZone.height-GameStage.getInstance().safeZone.height/2;*/
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

	
}
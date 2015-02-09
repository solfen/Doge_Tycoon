package com.isartdigital.myGame.ui.popin;
import com.isartdigital.myGame.ui.popin.IconPopinBuild;
import com.isartdigital.myGame.ui.MyPopin;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.myGame.ui.UIManager;
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

		/*child = new IconPopinBuild(0,0,"HudBuild");
		addChild(child);
		child = new IconPopinBuild(1,1, "closeButton");
		child.click = closePopin;
		addChild(child);*/
	}
	
	override private function onClick (pData:InteractionData) : Void {
		// so there nothing onclick since it will be children who have actions
		super.onClick(pData);
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
	private function closePopin(pData:InteractionData) : Void{
		destroy();
	}

	
}
package com.isartdigital.myGame.ui;

import com.isartdigital.utils.ui.Hud;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.UIPosition;
import pixi.display.DisplayObject;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.geom.Point;
import com.isartdigital.myGame.ui.hud.HudManager;

/**
 * Manager (Singleton) en charge de gérer les écrans d'interface
 * @author Mathieu ANTHOINE
 */
class UIManager 
{
	
	/**
	 * instance unique de la classe UIManager
	 */
	private static var instance: UIManager;
	
	
	/**
	 * tableau des popins ouverts
	 */
	private var popins:Array<Popin>;

	public function new() 
	{
		popins = [];
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): UIManager {
		if (instance == null) instance = new UIManager();
		return instance;
	}
	
	/**
	 * Ajoute un écran dans le conteneur de Screens en s'assurant qu'il n'y en a pas d'autres
	 * @param	pScreen
	 */
	public function openScreen (pScreen: Screen): Void {
		closeScreens();
		GameStage.getInstance().getScreensContainer().addChild(pScreen);
		pScreen.open();
	}
	
	/**
	 * Supprimer les écrans dans le conteneur de Screens
	 * @param	pScreen
	 */
	public function closeScreens (): Void {
		var lContainer:DisplayObjectContainer = GameStage.getInstance().getScreensContainer();
		while (lContainer.children.length > 0) {
			var lCurrent:Screen = cast(lContainer.getChildAt(lContainer.children.length-1),Screen);
			lContainer.removeChild(lCurrent);
			lCurrent.close();
		}
	}
	
	/**
	 * Ajoute un popin dans le conteneur de Popin
	 * @param	pScreen
	 */
	public function openPopin (pPopin: Popin): Void {
		popins.push(pPopin);
		GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
	}
	
	/**
	 * Supprime le popinles écrans dans le conteneur de Screens
	 * @param	pScreen
	 * @return la référence vers le Popin fermée
	 */
	public function closeCurrentPopin (): Void {
		if (popins.length == 0) return;
		var lCurrent:Popin = popins.pop();
		GameStage.getInstance().getPopinsContainer().removeChild(lCurrent);
		lCurrent.close();
	}
	
	/**
	 * Ajoute un hud dans le conteneur d'hud
	 * @param	pScreen
	 */
	public function openHud (pHUD:Hud): Void {
		GameStage.getInstance().getHudContainer().addChild(pHUD);
		pHUD.open();
	}
	
	/**
	 * Supprime le hud écrans dans le conteneur de Screens
	 * @param	pScreen
	 * @return la référence vers le Popin fermée
	 */
	public function closeHud (): Void {
		GameStage.getInstance().getHudContainer().removeChild(HudManager.getInstance());
		HudManager.getInstance().close();
	}
	
	/**
	* 
	* @param	pTarget DisplayObject à positionner
	* @param	pPosition type de positionnement
	* @param	pOffsetX décalage en X (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	* @param	pOffsetY décalage en Y (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	*/
	public function setPosition (pTarget:DisplayObject, pPosition:UIPosition, pOffsetX:Float = 0, pOffsetY:Float = 0): Void {
		
		if (pTarget.parent == null) return;
		
		var lTopLeft:Point = new Point (0, 0);
		var lBottomRight:Point = new Point (DeviceCapabilities.width, DeviceCapabilities.height);
		
		lTopLeft = pTarget.parent.toLocal(lTopLeft);
		lBottomRight = pTarget.parent.toLocal(lBottomRight);
		
		if (pPosition == UIPosition.TOP || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.TOP_RIGHT) pTarget.y = lTopLeft.y + pOffsetY;
		if (pPosition == UIPosition.BOTTOM || pPosition == UIPosition.BOTTOM_LEFT || pPosition == UIPosition.BOTTOM_RIGHT) pTarget.y = lBottomRight.y - pOffsetY;
		if (pPosition == UIPosition.LEFT || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.BOTTOM_LEFT) pTarget.x = lTopLeft.x + pOffsetX;
		if (pPosition == UIPosition.RIGHT || pPosition == UIPosition.TOP_RIGHT || pPosition == UIPosition.BOTTOM_RIGHT) pTarget.x = lBottomRight.x - pOffsetX;
		
		if (pPosition == UIPosition.FIT_WIDTH || pPosition == UIPosition.FIT_SCREEN) {
			pTarget.x = lTopLeft.x;
			untyped pTarget.width = lBottomRight.x - lTopLeft.x;
		}
		if (pPosition == UIPosition.FIT_HEIGHT || pPosition == UIPosition.FIT_SCREEN) {
			pTarget.y = lTopLeft.y;
			untyped pTarget.height = lBottomRight.y - lTopLeft.y;
		}	

	}
	
	/**
	 * lance le jeu
	 */
	 public function startGame (): Void {
		closeScreens();
		GameStage.getInstance().getHudContainer().addChild(HudManager.getInstance());
		HudManager.getInstance().open();
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}
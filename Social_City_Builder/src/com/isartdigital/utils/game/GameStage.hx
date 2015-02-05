package com.isartdigital.utils.game;
import com.isartdigital.utils.events.EventDispatcher;
import com.isartdigital.utils.events.GameStageEvent;
import com.isartdigital.utils.events.IEventDispatcher;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.geom.Rectangle;
import com.isartdigital.utils.events.Event;

/**
 * Classe en charge de mettre en place la structure graphique du jeu (conteneurs divers)
 * et la gestion du redimensionnement de la zone de jeu en fonction du contexte
 * @author Mathieu ANTHOINE
 */
class GameStage extends DisplayObjectContainer implements IEventDispatcher
{
	
	/**
	 * instance unique de la classe GameStage
	 */
	private static var instance: GameStage;

	private var _alignMode: GameStageAlign = GameStageAlign.CENTER;	

	private var _scaleMode: GameStageScale = GameStageScale.SHOW_ALL;
	
	private var _safeZone:Rectangle= new Rectangle(0,0,SAFE_ZONE_WIDTH,SAFE_ZONE_HEIGHT);
	
	/**
	 * callback de render
	 */
	private var render:Dynamic;
	
	/**
	 * largeur minimum pour le contenu visible par défaut
	 */
	private static inline var SAFE_ZONE_WIDTH: Int = 2048;

	/**
	 * hauteur minimum pour le contenu visible par défaut
	 */
	private static inline var SAFE_ZONE_HEIGHT: Int = 1366;
		
	/**
	 * conteneur des pop-in
	 */
	private var popinsContainer:DisplayObjectContainer;
	
	/**
	 * conteneur du Hud
	 */
	private var hudContainer:DisplayObjectContainer;
	
	/**
	 * conteneur des écrans d'interface
	 */
	private var screensContainer:DisplayObjectContainer;
	
	/**
	 * conteneur du jeu
	 */
	private var gameContainer:DisplayObjectContainer;
	
	/**
	 * dispatcheur d'évenements
	 */
	private var eventDispatcher:EventDispatcher;
	
	public function new() 
	{
		super();
		
		eventDispatcher = new EventDispatcher();
		
		gameContainer = new DisplayObjectContainer();		
		addChild(gameContainer);
		
		screensContainer = new DisplayObjectContainer();
		addChild(screensContainer);
		
		hudContainer = new DisplayObjectContainer();
		addChild(hudContainer);
		
		popinsContainer = new DisplayObjectContainer();
		addChild(popinsContainer);

	}
	
	/**
	 * Initialisation de la zone de jeu
	 * @param   pRender Callback qui fait le rendu pour mettre à jour le système de coordonnées avant de reconstruire d'éventuels éléments
	 * @param	pSafeZoneWidth largeur de la safeZone
	 * @param	pSafeZoneHeight hauteur de la safeZone
	 * @param	centerGameContainer centrer ou pas le conteneur des élements InGame
	 * @param	centerScreensContainer centrer ou pas le conteneur des Ecrans
	 * @param	centerPopinContainer centrer ou pas le conteneur des Popins
	 */
	public function init (pRender:Dynamic,?pSafeZoneWidth:UInt = SAFE_ZONE_WIDTH, ?pSafeZoneHeight:UInt = SAFE_ZONE_WIDTH, ?centerGameContainer:Bool = false, ?centerScreensContainer:Bool = true, ?centerPopinContainer:Bool = true):Void {
		
		render = pRender;
		
		_safeZone = new Rectangle (0, 0, pSafeZoneWidth, pSafeZoneHeight);

		if (centerGameContainer) {
			gameContainer.x = safeZone.width / 2;
			gameContainer.y = safeZone.height / 2;
		}
		
		if (centerScreensContainer) {
			screensContainer.x = safeZone.width / 2;
			screensContainer.y = safeZone.height / 2;
		}
		
		if (centerPopinContainer) {
			popinsContainer.x = safeZone.width / 2;
			popinsContainer.y = safeZone.height / 2;
		}
		
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameStage {
		if (instance == null) instance = new GameStage();
		return instance;
	}
	
	/**
	 * Redimensionne la scène du jeu en fonction de la taille disponible pour l'affichage
		* @param pRenderCallBack Callback qui fait le rendu pour mettre à jour le système de coordonnées avant de reconstruire d'éventuels éléments

	 */
	public function resize (): Void {
		
		var lWidth:UInt = DeviceCapabilities.width;
		var lHeight:UInt = DeviceCapabilities.height;
		
		var lRatio:Float = Math.round(10000 * Math.min( lWidth / safeZone.width, lHeight / safeZone.height)) / 10000;
		
		if (scaleMode == GameStageScale.SHOW_ALL) scale.set(lRatio, lRatio);
		else scale.set (1, 1);
		
		if (alignMode == GameStageAlign.LEFT || alignMode == GameStageAlign.TOP_LEFT || alignMode == GameStageAlign.BOTTOM_LEFT) x = 0;
		else if (alignMode == GameStageAlign.RIGHT || alignMode == GameStageAlign.TOP_RIGHT || alignMode == GameStageAlign.BOTTOM_RIGHT) x = lWidth - safeZone.width * scale.x;
		else x = (lWidth - safeZone.width * scale.x) / 2;
		
		if (alignMode == GameStageAlign.TOP || alignMode == GameStageAlign.TOP_LEFT || alignMode == GameStageAlign.TOP_RIGHT) y = 0;
		else if (alignMode == GameStageAlign.BOTTOM || alignMode == GameStageAlign.BOTTOM_LEFT || alignMode == GameStageAlign.BOTTOM_RIGHT) y = lHeight - safeZone.height * scale.y;
		else y = (lHeight - safeZone.height * scale.y) / 2;
		
		if (render!=null) render();
		
		dispatchEvent(new GameStageEvent(GameStageEvent.RESIZE, lWidth, lHeight));

	}
	
	/*
	 * style d'alignement au sein de l'écran
	 */
	public var alignMode (get, set) : GameStageAlign;
	
	private function get_alignMode( ) { 
		return _alignMode;
	}
	
	private function set_alignMode(pAlign:GameStageAlign) {
		_alignMode = pAlign;
		resize();
		return _alignMode;
	}

	/*
	 * style de redimensionnement au sein de l'écran
	 */
	public var scaleMode (get, set) : GameStageScale;
	
	private function get_scaleMode( ) { 
		return _scaleMode;
	}
	
	private function set_scaleMode(pScale:GameStageScale) {
		_scaleMode = pScale;
		resize();
		return _scaleMode;
	}	
	
	/**
	 * Rectangle délimitant le contenu minimum visible
	 */
	public var safeZone (get, never):Rectangle;
	
	private function get_safeZone () {
		return _safeZone;
	}

	/**
	 * accès en lecture au conteneur de jeu
	 * @return gameContainer
	 */
	public function getGameContainer (): DisplayObjectContainer {
		return gameContainer;
	}
	
	/**
	 * accès en lecture au conteneur d'écrans
	 * @return screensContainer
	 */
	public function getScreensContainer (): DisplayObjectContainer {
		return screensContainer;
	}
	
	/**
	 * accès en lecture au conteneur de hud
	 * @return hudContainer
	 */
	public function getHudContainer (): DisplayObjectContainer {
		return hudContainer;
	}
	
	/**
	 * accès en lecture au conteneur de PopIn
	 * @return popinContainer
	 */
	public function getPopinsContainer (): DisplayObjectContainer {
		return popinsContainer;
	}
	
	// Facade pour masquer la propriété eventDispatcher composée par GameStage
	
	public function hasEventListener (pType:String, pListener:Dynamic):Int {
		return eventDispatcher.hasEventListener(pType, pListener);
	}
	
	public function addEventListener(pType: String, pListener:Dynamic): Void {
		eventDispatcher.addEventListener(pType, pListener);
	}
	
	public function removeEventListener(pType: String, pListener:Dynamic): Void {
		eventDispatcher.removeEventListener(pType, pListener);
	}
	
	public function dispatchEvent(pEvent: Event): Void {
		eventDispatcher.dispatchEvent(pEvent);
		// masque l'eventDispatcher interne pour l'exterieur
		pEvent.target = this;
	}
			
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		eventDispatcher.destroy();
		eventDispatcher = null;
		instance = null;
	}

}
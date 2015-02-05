package com.isartdigital;

import com.isartdigital.myGame.ui.GraphicLoader;
import com.isartdigital.myGame.ui.screens.TitleCard;
import com.isartdigital.myGame.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.Event;
import com.isartdigital.utils.events.EventDispatcher;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageAlign;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Timer;
import js.Browser;
import pixi.display.Stage;
import pixi.loaders.AssetLoader;
import pixi.loaders.JsonLoader;
import pixi.renderers.webgl.WebGLRenderer;
import pixi.utils.Detector;
	

/**
 * Classe d'initialisation et lancement du jeu
 * @author Mathieu ANTHOINE
 */

class Main extends EventDispatcher
{
	
	/**
	 * chemin vers le fichier de configuration
	 */
	private static inline var CONFIG_PATH:String = "config.json";	
	
	/**
	 * instance unique de la classe Main
	 */
	private static var instance: Main;
	
	public var renderer:WebGLRenderer;
	
	private var stage:Stage;
	
	/**
	 * initialisation générale
	 */
	private static function main ():Void {
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main {
		if (instance == null) instance = new Main();
		return instance;
	}
	
	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new () {
		
		super();
	
		stage = new Stage(0x3F7CB6);
		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height);
		
		Browser.document.body.appendChild(renderer.view);
		
		Browser.window.requestAnimationFrame(cast gameLoop);
		
		// INIT: le code d'initialisation commence ici
		
		var lConfig:JsonLoader = new JsonLoader(CONFIG_PATH);
		lConfig.addEventListener("loaded", preloadAssets);
		lConfig.load();
		
	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets(pEvent:Event):Void {
		pEvent.target.removeEventListener("loaded", preloadAssets);
		
		Config.init(cast(pEvent.target, JsonLoader).json);
		
		GameStage.getInstance().scaleMode = GameStageScale.NO_SCALE;
		GameStage.getInstance().init(render,400, 300, true);
		
		stage.addChild(GameStage.getInstance());
		
		Browser.window.addEventListener("resize", resize);
		resize();
		
		var lAssets:Array<String> = [];
		lAssets.push("assets/preload.png");
		lAssets.push("assets/preload_bg.png");

		var lLoader:AssetLoader = new AssetLoader(lAssets);
		lLoader.addEventListener("onComplete", loadAssets);
		lLoader.load();
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pEvent:Event): Void {
		pEvent.target.removeEventListener("onComplete", loadAssets);
		
		var lAssets:Array<String> = [];
		lAssets.push("assets/TitleCard.png");
		lAssets.push("assets/HudBuild.png");
		lAssets.push("assets/Screen0.png");
		lAssets.push("assets/Screen1.png");
		lAssets.push("assets/Popin0.png");
		lAssets.push("assets/Popin1.png");
		lAssets.push("assets/PopinOkCancel.png");
		lAssets.push("assets/alpha_bg.png");
		lAssets.push("assets/black_bg.png");
		lAssets.push("assets/game.png");
		lAssets.push("assets/Hud_TL.png");
		lAssets.push("assets/Hud_TR.png");
		lAssets.push("assets/Hud_B.png");
		lAssets.push("assets/ambulance.json");

		var lLoader:AssetLoader = new AssetLoader(lAssets);
		lLoader.addEventListener("onProgress", onLoadProgress);
		lLoader.addEventListener("onComplete", onLoadComplete);

		UIManager.getInstance().openScreen(GraphicLoader.getInstance());

		lLoader.load();
		
	}
	
	private function onLoadProgress (pEvent:Event): Void {
		var lLoader:AssetLoader = cast(pEvent.target, AssetLoader);
		GraphicLoader.getInstance().update((lLoader.assetURLs.length-lLoader.loadCount)/lLoader.assetURLs.length);
	}
	
	private function onLoadComplete (pEvent:Event): Void {
		pEvent.target.removeEventListener("onProgress", onLoadProgress);
		pEvent.target.removeEventListener("onComplete", onLoadComplete);
		
		UIManager.getInstance().openScreen(TitleCard.getInstance());
	}
	
	/**
	 * game loop
	 */
	private function gameLoop() {
		Browser.window.requestAnimationFrame(cast gameLoop);
		render();		
		dispatchEvent(new Event(Event.GAME_LOOP));
		
	}
	
	/**
	 * Ecouteur du redimensionnement
	 * @param	pEvent evenement de redimensionnement
	 */
	public function resize (pEvent:js.html.Event = null): Void {
		renderer.resize(DeviceCapabilities.width, DeviceCapabilities.height);
		GameStage.getInstance().resize();
	}
	
	/**
	 * fait le rendu de l'écran
	 */
	public function render (): Void {
		renderer.render(stage);
	}

		
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Browser.window.removeEventListener("resize", resize);
		instance = null;
		super.destroy();
	}
	
}
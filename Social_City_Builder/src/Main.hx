package;

import scenes.ScenesManager;
import utils.events.Event;
import utils.events.EventDispatcher;
import utils.system.DeviceCapabilities;
import haxe.Timer;
import js.Browser;
import pixi.display.Stage;
import pixi.loaders.AssetLoader;
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
	
	private static var instance: Main;
	public var renderer:WebGLRenderer;
	private var stage:Stage;
	

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

	//return the stage. The stage is the container where we add all our graphics and containers
	public function getStage() : Stage {
		return stage;
	}

	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new () {
		
		super();
	
		stage = new Stage(0x3f7cb6);
		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height); // vois ce que ça donne dans facebook
		Browser.document.body.appendChild(renderer.view);
		Browser.window.requestAnimationFrame(cast gameLoop);
		Browser.window.addEventListener("resize", resize);

		preloadAssets();
	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets():Void {
		var lLoader:AssetLoader = new AssetLoader(GameInfo.preloadAssets);
		lLoader.addEventListener("onComplete", loadAssets);
		lLoader.load();
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pEvent:Event): Void {
		pEvent.target.removeEventListener("onComplete", loadAssets);
		ScenesManager.getInstance().loadScene("LoaderScene");
		
		var lLoader:AssetLoader = new AssetLoader(GameInfo.preloadAssets);
		lLoader.addEventListener("onProgress", onLoadProgress);
		lLoader.addEventListener("onComplete", onLoadComplete);
		lLoader.load();
	}
	
	private function onLoadProgress (pEvent:Event): Void {
		var lLoader:AssetLoader = cast(pEvent.target, AssetLoader);
		//GraphicLoader.getInstance().update((lLoader.assetURLs.length-lLoader.loadCount)/lLoader.assetURLs.length);
	}
	
	private function onLoadComplete (pEvent:Event): Void {
		pEvent.target.removeEventListener("onProgress", onLoadProgress);
		pEvent.target.removeEventListener("onComplete", onLoadComplete);
		ScenesManager.getInstance().loadScene("GameScene");
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
		dispatchEvent(new Event(Event.RESIZE));
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
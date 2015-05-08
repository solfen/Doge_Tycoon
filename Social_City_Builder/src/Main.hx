package;

import haxe.Timer;
import js.Browser;
import utils.events.Event;
import utils.events.EventDispatcher;
import utils.system.DeviceCapabilities;
import pixi.display.Stage;
import pixi.loaders.AssetLoader;
import pixi.renderers.webgl.WebGLRenderer;
import pixi.utils.Detector;
import pixi.text.Text;
import externs.FB;
import externs.WebFontLoader;
import scenes.ScenesManager;

/**
 * Classe d'initialisation et lancement du jeu
 * @author Mathieu ANTHOINE
 */

class Main extends EventDispatcher
{
	
	/**
	 * chemin vers le fichier de configuration
	 */
	public var renderer: WebGLRenderer;
	public var delta_time: Float;
	
	private static inline var CONFIG_PATH: String = "config.json";	
	private static var instance: Main;
	private static var stats: Dynamic;
	
	private var stage: Stage;
	private var WebFontConfig: Dynamic;
	private var _old_stamp: Float;

	private static function main (): Void
	{
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main
	{
		if (instance == null) instance = new Main();
		return instance;
	}

	//return the stage. The stage is the container where we add all our graphics and containers
	public function getStage (): Stage
	{
		return stage;
	}

	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new ()
	{
		super();

		stage = new Stage(0x3f7cbf);

		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height); // voir ce que ça donne dans facebook
		
		delta_time = 0;
		_old_stamp = Timer.stamp();

		stats = new pixi.utils.Stats();
		stats.domElement.style.position = "absolute";
		stats.domElement.style.top = "0px";
		
		Browser.document.body.appendChild(renderer.view);
		Browser.document.body.appendChild(stats.domElement);
		Browser.window.addEventListener("resize", resize);
		
		WebFontConfig = {
			custom: {
				families: ['FuturaStdMedium', 'FuturaStdHeavy'],
				urls: ['fonts.css']
			},

			active: function() {
			   preloadAssets();
			}
		};
		WebFontLoader.load(WebFontConfig);
		
		gameLoop(0);
	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets():Void {
		var lLoader:AssetLoader = new AssetLoader(LoadInfo.preloadAssets);
		lLoader.addEventListener("onComplete", loadAssets);
		lLoader.load();
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pEvent:Event): Void {
		pEvent.target.removeEventListener("onComplete", loadAssets);
		ScenesManager.getInstance().loadScene("LoaderScene");
		var lLoader:AssetLoader = new AssetLoader(LoadInfo.loadAssets);
		lLoader.addEventListener("onProgress", onLoadProgress);
		lLoader.addEventListener("onComplete", onLoadComplete);
		//FB.getLoginStatus(onFacebookConnect);
		lLoader.load();
	}
	
	private function onLoadProgress (pEvent:Event): Void {
		var lLoader:AssetLoader = cast(pEvent.target, AssetLoader);
		GameInfo.loaderCompletion = (lLoader.assetURLs.length-lLoader.loadCount)/lLoader.assetURLs.length;
	}
	
	private function onLoadComplete (pEvent:Event): Void {
		pEvent.target.removeEventListener("onProgress", onLoadProgress);
		pEvent.target.removeEventListener("onComplete", onLoadComplete);
		ScenesManager.getInstance().loadScene("GameScene");
	}
	private function onFacebookConnect(pResponse:Dynamic){
		trace(pResponse.status);
		if(pResponse.status == 'connected'){
			trace("awww yeah ! you're in ! Motherfucka !!");
			/*FB.api(
			  'me/space_dogs_tycoon:find',
			  'post',
			  {
			    artefact: "http://samples.ogp.me/884406454948358",
			    //fb:'explicitly_shared',
			  },
			  function(response) {
			  	trace(response);
			  }
			);*/
			/*FB.ui({method: 'apprequests',
			  message: 'Hé viens jouer à ce super jeu. Jeu 100% sans panda roux alibnos !'
			}, function(response){
			    trace(response);
			});*/
			/*FB.api(
			  'me/objects/space_dogs_tycoon:artefact',
			  'post',
			  {
			    'og:url': 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/php/fbObjects/boot.html',
			    'og:title': 'Awesome boot',
			    'og:type': 'space_dogs_tycoon:artefact',
			    'og:image': 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/bin/assets/UI/Icons/Artefacts/IconArtefactsTerre2.png',
			    'og:description': 'My boot is so awesome that it can cure cancer',
			    'fb:app_id': 855211017867902
			  },
			  function(response) {
			    trace(response);
			  }
			);*/
			FB.ui({method: 'apprequests',
				message: 'Hey noob ! you are up to this',
				action_type:'send',
				object_id: "706093629496403",
			}, function(response){
			    trace(response);
			});
			/*FB.ui({
			  method: 'share_open_graph',
			  action_type: 'space_dogs_tycoon:find',
			  action_properties: haxe.Json.stringify({
			      'artefact':'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/php/fbObjects/boot.html',
			  })
			}, function(response){});*/
		}
		else if(pResponse.status == 'not_authorized'){
			trace("Oh no ! you're not identified");
			FB.login(function(response){
				FB.getLoginStatus(onFacebookConnect);
			}, {scope: 'publish_actions,email'});
		}
	}
	private function test(){
		trace("succes");
	}
	
	/**
	 * game loop
	 */
	private function gameLoop (timestamp)
	{
		delta_time = Timer.stamp() - _old_stamp;
		_old_stamp = Timer.stamp();

		stats.begin();
		Browser.window.requestAnimationFrame(cast gameLoop);
		render();		
		dispatchEvent(new Event(Event.GAME_LOOP));
		stats.end();
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
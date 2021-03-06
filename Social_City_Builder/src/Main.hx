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
import externs.WebFontLoader;
import scenes.ScenesManager;
import externs.Howl;
import externs.Howler;

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
	public var music: Howl;
	
	private static inline var CONFIG_PATH: String = "config.json";	
	private static var instance: Main;
	// private static var stats: Dynamic;
	
	private var stage: Stage;
	private var WebFontConfig: Dynamic;
	private var _old_stamp: Float;

	public static var isLocal:Bool = false;

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

		/*stats = new pixi.utils.Stats();
		stats.domElement.style.position = "absolute";
		stats.domElement.style.top = "0px";*/
		
		Browser.document.body.appendChild(renderer.view);
		// Browser.document.body.appendChild(stats.domElement);
		Browser.window.addEventListener("resize", resize);
		
		WebFontConfig = {
			custom: {
				families: ['FuturaStdMedium', 'FuturaStdHeavy'],
				urls: ['fonts.css']
			},

			active: preloadAssets
		};
		WebFontLoader.load(WebFontConfig);

		music = new Howl({
		  urls: ['assets/Sounds/Monkeys_Spinning_Monkeys.ogg'],
		  buffer:true,
		  autoplay: false,
		  loop: true,
		  volume: 0.5,
		});
		music.play();
		
		gameLoop(0);
	}

	private function onFacebookConnect(pResponse:Dynamic){
		if(pResponse.status == 'connected'){
			GameInfo.facebookID = pResponse.authResponse.userID;
			utils.server.MyFbHelper.getInstance().getFriendsList(finishFriendsList);
		}
		else if(pResponse.status == 'not_authorized'){
			trace("Oh no ! you're not identified");
			externs.FB.login(function(response){
				externs.FB.getLoginStatus(onFacebookConnect);
			}, {scope: 'publish_actions,email,user_friends'});
		}
	}
	private function finishFriendsList(data:Dynamic) {
		GameInfo.friendsList = [];
		var friends:Array<Dynamic> = data.data;
		var max:Int = Std.int(Math.min(8, friends.length));
		for(i in 0...max) {
			GameInfo.friendsList.push({id: friends[i].id, name: friends[i].first_name, img: friends[i].picture.data.url });
			LoadInfo.loadAssets.push(friends[i].picture.data.url);
		}
		loadAssets();
	}

	private function fbInit(pEvent:Event) {
		pEvent.target.removeEventListener("onComplete", loadAssets);
		ScenesManager.getInstance().loadScene("LoaderScene");
		utils.server.MyFbHelper.getInstance(onFacebookConnect);
	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets():Void {
		var lLoader:AssetLoader = new AssetLoader(LoadInfo.preloadAssets);

		if(isLocal){
			for(i in GameInfo.friendsList){
				LoadInfo.loadAssets.push(i.img);	
			}
			lLoader.addEventListener("onComplete", loadAssets);
		}
		else {
			lLoader.addEventListener("onComplete", fbInit);
		}

		lLoader.load();
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (?pEvent:Event): Void {
		if(pEvent != null) {
			pEvent.target.removeEventListener("onComplete", loadAssets);
		}
		ScenesManager.getInstance().loadScene("LoaderScene");
		var lLoader:AssetLoader = new AssetLoader(LoadInfo.loadAssets);
		lLoader.addEventListener("onProgress", onLoadProgress);
		lLoader.addEventListener("onComplete", onLoadComplete);
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
		utils.game.LoadConfig.load();
	}
	
	
	/**
	 * game loop
	 */
	private function gameLoop (timestamp)
	{
		delta_time = Timer.stamp() - _old_stamp;
		_old_stamp = Timer.stamp();

		// stats.begin();
		Browser.window.requestAnimationFrame(cast gameLoop);
		render();		
		dispatchEvent(new Event(Event.GAME_LOOP));

		// stats.end();
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
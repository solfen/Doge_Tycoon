package scenes;
import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.extras.TilingSprite;
import pixi.display.MovieClip;
import pixi.textures.Texture;
import utils.events.Event;
import pixi.text.Text;
import haxe.Timer;

class LoaderScene extends DisplayObjectContainer 
{
	private static var instance: LoaderScene;
	private var randomPhrases:Array<String> = [
		"Affinage des fouets",
		"Mise en suspend des congés",
		"Ajout de Rambo IV au cinéma",
		"Relecture des commérages de Gertrude",
		"Automatisation des automates",
		"Peinture des tomates",
		"Wow !",
		"Much Game !",
		"Such Genius",
		"Instauration de la semaine de 169 heures",
		"Toilettage du personnel",
		"Financement de dictatures",
		"Mise en place de la surveillance de masse",
	];
	private var phraseInterval:Int = 3000;
	private var maxLoadFillWidth:Float;
	private var currentLoadFillWidth:Float;
	private var background:Sprite;
	private var doge:MovieClip;
	private var planet:Sprite;
	private var planetLight:Sprite;
	private var title:Sprite;
	private var loadingBar:Sprite;
	private var loadingFillStart:Sprite;
	private var loadingFillEnd:Sprite;
	private var loadingFillMidlle:Sprite;
	private var planetGlow:MovieClip;
	private var textStyle:TextStyle = {font:"15px FuturaStdHeavy",fill:"white"};
	private var phraseText:Text; 

	public static function getInstance (): LoaderScene {
		if (instance == null) instance = new LoaderScene();
		return instance;
	}	
	
	public function new() {
		super();
		x=0;
		y=0;
		background = new TilingSprite(Texture.fromFrame("assets/UI/SplashScreen/IconsSplash.jpg"), DeviceCapabilities.width, DeviceCapabilities.height);
		var dogeTextures:Array<Texture> = [];
		for(i in 0...12){
			dogeTextures.push(Texture.fromFrame('doge-run_'+i));
		}
		doge = new MovieClip(dogeTextures);
		var glowTextures:Array<Texture> = [];
		for(i in 0...5){
			glowTextures.push(Texture.fromFrame('planetGlow_'+i));
		}
		planetGlow = new MovieClip(glowTextures);
		planet = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/Planet.png'));
		planetLight = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/PlanetLight.png'));
		title = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/Title.png'));
		loadingBar= new Sprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFillBar.png'));
		loadingFillStart = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFill01.png'));
		loadingFillEnd = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFill03.png'));
		loadingFillMidlle = new TilingSprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFill02.png'), 0, loadingFillStart.height);
		phraseText = new Text("", textStyle);
		changePhrase();

		title.anchor.set(0.5,0.5);
		planet.anchor.set(0.5,0.5);
		planetGlow.anchor.set(0.5,0.5);
		doge.anchor.set(0.5,0.5);
		planetLight.anchor.set(0.5,0.5);
		loadingBar.anchor.set(0.5,0.5);
		loadingFillMidlle.anchor.set(0,0.5);
		loadingFillStart.anchor.set(0,0.5);
		loadingFillEnd.anchor.set(0,0.5);
		phraseText.anchor.set(0.5,0.5);

		onResize();

		addChild(background);
		addChild(title);
		addChild(planet);
		addChild(planetLight);
		addChild(doge);
		addChild(planetGlow);
		addChild(loadingBar);
		addChild(loadingFillStart);
		addChild(loadingFillMidlle);
		addChild(loadingFillEnd);
		addChild(phraseText);
		doge.animationSpeed = 0.25;
		planetGlow.animationSpeed = 0.05;
		doge.play();
		planetGlow.play();
		Main.getInstance().addEventListener(Event.GAME_LOOP, animation);
		Main.getInstance().addEventListener(Event.RESIZE, onResize);

		var timer:Timer = new haxe.Timer(phraseInterval);
		timer.run = changePhrase;
	}
	private function animation():Void {
		planet.rotation -= 0.03;
		if(currentLoadFillWidth != GameInfo.loaderCompletion){
			loadBarFill();
		}
	}
	private function onResize():Void {
		background.width = DeviceCapabilities.width;
		background.height = DeviceCapabilities.height;
		title.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.3));
		planet.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*1.05));
		planetGlow.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.7));
		doge.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.65));
		planetLight.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.86));
		loadingBar.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.9));
		loadingFillStart.position.set(Std.int(loadingBar.x-loadingBar.width/2+3),loadingBar.y);
		loadingFillMidlle.position.set(loadingFillStart.x+loadingFillStart.width,loadingFillStart.y);
		loadingFillEnd.position.set(loadingFillMidlle.x+loadingFillMidlle.width,loadingFillStart.y);
		phraseText.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.95));
	}
	private function loadBarFill():Void {
		maxLoadFillWidth = loadingBar.width-(loadingFillStart.width+3)-loadingFillEnd.width;
		loadingFillMidlle.width = GameInfo.loaderCompletion * maxLoadFillWidth;
		loadingFillEnd.position.set(loadingFillMidlle.x+loadingFillMidlle.width,loadingFillStart.y);
	}
	private function changePhrase():Void {
		phraseText.setText(randomPhrases[Std.int(Math.random()*(randomPhrases.length-1))]);
	}
}
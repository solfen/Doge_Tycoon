package scenes;
import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.extras.TilingSprite;
import pixi.display.MovieClip;
import pixi.textures.Texture;
import utils.events.Event;

class LoaderScene extends DisplayObjectContainer 
{
	private static var instance: LoaderScene;
	private var planet:Sprite;

	public static function getInstance (): LoaderScene {
		if (instance == null) instance = new LoaderScene();
		return instance;
	}	
	
	public function new() {
		super();
		x=0;
		y=0;
		var background:Sprite = new TilingSprite(Texture.fromFrame("assets/UI/SplashScreen/IconsSplash.jpg"), DeviceCapabilities.width, DeviceCapabilities.height);
		var dogeTextures:Array<Texture> = [];
		for(i in 0...12){
			dogeTextures.push(Texture.fromFrame('doge-run_'+i));
		}
		var doge:MovieClip = new MovieClip(dogeTextures);
		var glowTextures:Array<Texture> = [];
		for(i in 0...5){
			glowTextures.push(Texture.fromFrame('planetGlow_'+i));
		}
		var planetGlow:MovieClip = new MovieClip(glowTextures);
		planet = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/Planet.png'));
		var planetLight:Sprite = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/PlanetLight.png'));
		var title:Sprite = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/Title.png'));
		var loadingBar:Sprite = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFillBar.png'));
		var loadingFillStart = new Sprite(Texture.fromFrame('assets/UI/SplashScreen/LoadingFill01.png'));
		title.anchor.set(0.5,0.5);
		planet.anchor.set(0.5,0.5);
		planetGlow.anchor.set(0.5,0.5);
		doge.anchor.set(0.5,0.5);
		planetLight.anchor.set(0.5,0.5);
		loadingBar.anchor.set(0.5,0.5);

		title.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.3));
		planet.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*1.05));
		planetGlow.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.7));
		doge.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.65));
		planetLight.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.86));
		loadingBar.position.set(Std.int(DeviceCapabilities.width/2),Std.int(DeviceCapabilities.height*0.9));

		addChild(background);
		addChild(title);
		addChild(planet);
		addChild(planetLight);
		addChild(doge);
		addChild(planetGlow);
		addChild(loadingBar);
		doge.animationSpeed = 0.25;
		planetGlow.animationSpeed = 0.05;
		doge.play();
		planetGlow.play();
		Main.getInstance().addEventListener(Event.GAME_LOOP, animation);
	}
	private function animation(){
		planet.rotation -= 0.03;
	}
}
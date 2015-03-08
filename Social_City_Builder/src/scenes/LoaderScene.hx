package scenes;
import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.textures.Texture;

class LoaderScene extends DisplayObjectContainer 
{
	private static var instance: LoaderScene;

	public static function getInstance (): LoaderScene {
		if (instance == null) instance = new LoaderScene();
		return instance;
	}	
	
	public function new() 
	{
		super();
		x=0;
		y=0;
		var img = new Sprite(Texture.fromImage("assets/UI/SplashScreen/IconsSplash.jpg"));
		img.anchor.set(0.5, 0.5);
		img.x = DeviceCapabilities.width/2;
		img.y = DeviceCapabilities.height/2;
		addChild(img);
	}
}
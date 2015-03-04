package scenes;
import pixi.display.DisplayObjectContainer;
import scenes.LoaderScene; // why do I have to import it so that Type.resolveClass knows it ? need ask mathieu
import scenes.GameScene;

//ScenesManger can load new scenes just with a scene name
class ScenesManager 
{
	private static var instance: ScenesManager;
	private var currentScene:DisplayObjectContainer;
	private var isThereAScene:Bool;
	
	public static function getInstance (): ScenesManager {
		if (instance == null) {
			instance = new ScenesManager();
		}
		return instance;
	}
	
	public function new () {

	}

	public function loadScene (sceneName:String){
		if(isThereAScene){
			Main.getStage().removeChild(currentScene);
		}
		currentScene = Type.createInstance( Type.resolveClass("scenes."+sceneName), [] );
		Main.getStage().addChild(currentScene);
		isThereAScene = true;
	}
	
}
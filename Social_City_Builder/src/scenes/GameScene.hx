package scenes;
import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import utils.events.Event;
import pixi.textures.Texture;
import sprites.Ambulance;
import hud.HudManager;
import popin.PopinManager;

class GameScene extends DisplayObjectContainer 
{
	private static var instance: GameScene;

	public static function getInstance (): GameScene {
		if (instance == null) instance = new GameScene();
		return instance;
	}	
	
	public function new() 
	{
		super();
		x=0;
		y=0;

		var background:Sprite = new Sprite(Texture.fromImage("assets/game.png"));
		background.anchor.set(0.5, 0.5);
		background.position.set(DeviceCapabilities.width/2,DeviceCapabilities.height/2);
		addChild(background);

		// ambulance later there will be a sprite manager that will be for the doge
		//there will also be a buildings manger and other things
		/*var lAmbulance:Ambulance = new Ambulance();
		lAmbulance.position.set(100, 100);
		addChild(lAmbulance);*/

		addChild(HudManager.getInstance());
		addChild(PopinManager.getInstance());

		Main.getInstance().addEventListener(Event.GAME_LOOP, doAction);
		Main.getInstance().addEventListener(Event.GAME_LOOP, resize);
	}

	public function doAction (): Void {

	}
	public function resize ():Void {
		/*scale.x = DeviceCapabilities.width / GameInfo.userWidth;
		scale.y = DeviceCapabilities.height / GameInfo.userHeight;*/
	}
}
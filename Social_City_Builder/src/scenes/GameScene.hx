package scenes;
import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import utils.events.Event;
import utils.game.InputInfos;
import pixi.InteractionData;
import pixi.textures.Texture;
import sprites.Ambulance;
import hud.HudManager;
import popin.PopinManager;
import IsoMap;
import sprites.Building;

class GameScene extends DisplayObjectContainer 
{
	private static var instance: GameScene;

	public static function getInstance (): GameScene
	{
		if (instance == null) instance = new GameScene();
		return instance;
	}
	
	public function new (): Void
	{
		super();
		x=0;
		y=0;

		new InputInfos(true, true);
		InputInfos.mouse_x = Std.int(DeviceCapabilities.width*0.5);
		InputInfos.mouse_y = Std.int(DeviceCapabilities.height*0.5);

		new IsoMap("assets/BG.jpg", 64, 64, 128, 64);
		addChild(IsoMap.singleton);
		/*var testTexture:Texture = Texture.fromFrame('CasinoLv2_01.png');
		addChild(new Sprite(testTexture));*/
		addChild(HudManager.getInstance());
		addChild(PopinManager.getInstance());

		Main.getInstance().addEventListener(Event.GAME_LOOP, doAction);
		Main.getInstance().addEventListener(Event.RESIZE, resize);
	}

	public function doAction (): Void
	{

	}

	public function resize ():Void {
		/*scale.x = scale.y = DeviceCapabilities.width < DeviceCapabilities.height ? DeviceCapabilities.width / GameInfo.userWidth:DeviceCapabilities.height / GameInfo.userHeight;*/
	}
}
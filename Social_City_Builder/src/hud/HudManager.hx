package hud;

import utils.system.DeviceCapabilities;
import pixi.display.DisplayObjectContainer;
import hud.IconHud;
import utils.events.Event;

// HudManger serves as a container for the HUD, spwans the HudIcons and manage their resize
class HudManager extends DisplayObjectContainer
{
	private static var instance: HudManager;
	private var childs:Map<String,IconHud> = new Map();
	private var containers:Map<String,Dynamic> = new Map();
	private var currentChild: IconHud;
	private var hudWidthInterval = 0.05;
	private var hudTopY = 0.025;
	private var hudBottomY = 0.9;
	private var lastX:Float = 0;
	
	public static function getInstance (): HudManager {
		if (instance == null) instance = new HudManager();
		return instance;
	}	
	
	public function new()  {
		super();

		//childs creation the position is in ratio of deviceCapabilities (0 0 = top left, 1 1 = botom right)
		// first param in new IconHud does not matters since it the x and its beeign changed by the resizeHud
		// later the positions param of IconHud might be deleted as only the resize will count
		addContainer(0.01,0,'HudTop',0.92,0.05,'center');
		addHud(new HudFric(0,hudTopY),"HudFric",'HudTop');
		addHud(new HudHardMoney(0,hudTopY),"HudHardMoney",'HudTop');
		addHud(new HudDoges(0,hudTopY),"HudDoges",'HudTop');
		addHud(new HudStock(0,hudTopY),"HudStock",'HudTop');

		addContainer(0.94,0,'HudLeft',0.05,0.05,'right');
		addHud(new HudOptions(0,hudTopY),"HudOptions",'HudLeft');
		
		addContainer(0.24,0,'HudBottom',0.75,0.01,'right');
		addHud(new HudDestroy(0,hudBottomY),"HudDestroy", 'HudBottom');
		addHud(new HudObservatory(0,hudBottomY),"HudObservatory", 'HudBottom');
		addHud(new HudInventory(0,hudBottomY),"HudInventory", 'HudBottom');
		addHud(new HudQuests(0,hudBottomY),"HudQuests", 'HudBottom');
		addHud(new HudMarket(0,hudBottomY),"HudMarket", 'HudBottom');
		addHud(new HudShop(0,hudBottomY),"HudShop", 'HudBottom');
		addHud(new HudBuild(0,hudBottomY),"HudBuild", 'HudBottom');

		resizeHud();
		Main.getInstance().addEventListener(Event.RESIZE, resizeHud);
	}
	private function resizeHud(){
		for(container in containers){
			container.obj.scale.x = container.obj.scale.y = 1.0;
			var childsWidth:Float = -container.interval;
			var childsArr:Array<IconHud> = container.obj.children;
			for(i in childsArr){
				i.position.x = Std.int((childsWidth+container.interval)*DeviceCapabilities.width);
				childsWidth += i.width/DeviceCapabilities.width + container.interval;
			}
			if(childsWidth > container.maxWidth){
				container.obj.scale.x = container.maxWidth/childsWidth;
				container.obj.scale.y = container.maxWidth/childsWidth;
				container.obj.position.x = Std.int(container.startX*DeviceCapabilities.width);
			}
			else{
				var tempX:Float;
				if(container.align == "left")
					tempX = container.startX;
				else if(container.align == "center")
					tempX = container.startX + (container.maxWidth-childsWidth)/2;
				else
					tempX = container.startX + container.maxWidth-childsWidth;

				container.obj.position.x = Std.int(tempX*DeviceCapabilities.width);
			}
		}
	}
	private function addContainer(x:Float,y:Float,name:String,maxWidth:Float,interval:Float,?align:String='left'){
		var container = new DisplayObjectContainer();
		container.position.set(Std.int(x*DeviceCapabilities.width),Std.int(y*DeviceCapabilities.height));
		containers[name] = {};
		containers[name].obj = container;
		containers[name].maxWidth = maxWidth;
		containers[name].interval = interval;
		containers[name].startX = x;
		containers[name].align = align;
		addChild(container);
	}
	private function addHud(child:IconHud,name:String,target:String){
		childs[name] = child;
		containers[target].obj.addChild(child);
	}

	// removes all childs then put its instance to null
	public function destroy (): Void {
	 	for(i in childs){
			removeChild(i); // destroy the child's connexion with the stage
	 	}
	 	childs = new Map(); // destroys all the instances of the childs
		instance = null;
	}

}
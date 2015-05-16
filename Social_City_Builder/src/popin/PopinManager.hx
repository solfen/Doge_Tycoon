package popin;

import popin.PopinBuild;
import popin.PopinMarket;
import popin.PopinQuests;
import popin.PopinWorkshop;
import popin.PopinInventory;
import popin.PopinShop;
import popin.PopinShop;
import popin.PopinChurch;
import pixi.InteractionData;
import pixi.display.DisplayObjectContainer;

// HudManger serves as a container for the Popins, spwans the Popins
class PopinManager extends DisplayObjectContainer
{
	//all the childs are stocked in an associative array where their name are the keys. That allows cool stuf (like in closePopin)
	private var childs:Map<String, MyPopin> = new Map();
	private var currentPopinName:String = null;
	private static var instance: PopinManager;

	public static function getInstance (): PopinManager {
		if (instance == null) instance = new PopinManager();
		return instance;
	}	
	
	public function new()  {
		super();
	}
	public function updatePopin(popinName:String){
		if(isPopinOpen(popinName)){
			childs[popinName].update();
		}
	}
	public function getCurrentPopinName():String{
		return currentPopinName;
	}
	public function isPopinOpen(pName:String):Bool{
		return childs.exists(pName);
	}
	//instantiate any popIn just with its name so that anywhere in the code we can open a popin with a string
	// by doing PopinManager.getInstance().openPopin("popinName")
	public function openPopin(popinName:String, ?pX:Float, ?pY:Float,?optParams:Map<String,Dynamic>){
		childs[popinName] = Type.createInstance( Type.resolveClass("popin."+popinName), [pX,pY,optParams]);
		addChild(childs[popinName]);
		currentPopinName = popinName != "PopinInventory" ? popinName:currentPopinName; // beacuse inventory can be opened along with other popins
	}

	public function closePopin(popinName:String){
		childs[popinName].destroy();
		removeChild(childs[popinName]);

		childs.remove(popinName);
		currentPopinName = popinName == "PopinInventory" ? currentPopinName:null;
	}
	public function closeCurentPopin():Void{
		if(currentPopinName != null){
			childs[currentPopinName].destroy();
			removeChild(childs[currentPopinName]);
			childs.remove(currentPopinName);
			currentPopinName = null;
		}
	}
	public function closeAllPopin(){
		for(key in childs.keys()){
			childs[key].destroy();
			removeChild(childs[key]);
	 	}
	 	currentPopinName = null;
	 	childs = new Map();
	}

	// removes all childs and put intance to null
	public function destroy (): Void {
		closeAllPopin();
		Main.getInstance().getStage().removeChild(this);
		instance = null;
	}

}
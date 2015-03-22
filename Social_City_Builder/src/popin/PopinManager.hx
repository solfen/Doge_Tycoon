package popin;

import popin.PopinBuild;
import popin.PopinMarket;
import popin.PopinQuests;
import popin.PopinWorkshop;
import popin.MyPopin;
import pixi.InteractionData;
import pixi.display.DisplayObjectContainer;

// HudManger serves as a container for the Popins, spwans the Popins
class PopinManager extends DisplayObjectContainer
{
	//all the childs are stocked in an associative array where their name are the keys. That allows cool stuf (like in closePopin)
	private var childs:Map<String, MyPopin> = new Map();
	private static var instance: PopinManager;

	public static function getInstance (): PopinManager {
		if (instance == null) instance = new PopinManager();
		return instance;
	}	
	
	public function new()  {
		super();
	}
	
	//instantiate any popIn just with its name so that anywhere in the code we can open a popin with a string
	// by doing PopinManager.getInstance().openPopin("popinName")
	public function openPopin(popinName:String, ?pX:Float, ?pY:Float){
		childs[popinName] = Type.createInstance( Type.resolveClass("popin."+popinName), [pX,pY] );
		addChild(childs[popinName]);
	}

	public function closePopin(popinName:String){
		removeChild(childs[popinName]);
		childs.remove(popinName);
	}
	
	public function closeAllPopin(){
		for(key in childs.keys()){
			removeChild(childs[key]);
	 	}
	 	childs = new Map();
	}

	// removes all childs and put intance to null
	public function destroy (): Void {
		closeAllPopin();
		Main.getStage().removeChild(this);
		instance = null;
	}

}
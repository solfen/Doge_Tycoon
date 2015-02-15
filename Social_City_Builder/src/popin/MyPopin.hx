package popin;

import popin.IconPopin;
import pixi.display.DisplayObjectContainer;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

//Base PopIn class, all popIn will inherit from this
// it's a DisplayObjectContainer, has a base x & y, clickEvent and a destroy method that destroy the popin (and its icons)
class MyPopin extends DisplayObjectContainer
{
	private static var instance: MyPopin;
	private var background:Sprite;
	private var modalZone:Sprite;
	private var childs:Map<String, Sprite> = new Map();
	private var currentChild:Sprite;
	private var texturePath:String;
	
	public static function getInstance (?startX:Float,?startY:Float, ?textureName:String): MyPopin {
		if (instance == null) {
			instance = new MyPopin(startX,startY, textureName);
		}
		return instance;
	}

	public function new(?startX:Float=0,?startY:Float=0, ?textureName:String, ?isModal:Bool=true) 
	{
		super();
		x=startX;
		y=startY;

		if(isModal){
			modalZone = new Sprite(Texture.fromImage("assets/alpha_bg.png"));
			modalZone.x=-startX;
			modalZone.y=-startY;
			modalZone.width = 2500;
			modalZone.height = 2500;
			modalZone.interactive = true; // see if elements behind popin have their event fired when interactive = false;
			modalZone.click = stopClickEventPropagation;
			childs["modal"] = modalZone;
			addChild(modalZone);
		}

		//if we dont have a textureName then we take it from the class name
		if(textureName == null){
			var lCompleteClassName : String = Type.getClassName(Type.getClass(this));
			var lClassName: String = lCompleteClassName.substr(lCompleteClassName.lastIndexOf(".") + 1);
			textureName = lClassName;
		}
		background = new Sprite(Texture.fromImage("assets/"+textureName+".png"));
		background.anchor.set(0.5, 0.5);
		childs["background"] = background;
		addChild(background);
	}

	// creates an IconPopin and puts it in the childs array
	private function addIcon(x:Float,y:Float, textureName:String, ?name:String, ?isInteractive:Bool=true){
		if(name == null){
			name = textureName;
		}
		currentChild = new IconPopin(x,y,textureName,name,isInteractive);
		if(isInteractive){
			currentChild.click = childClick;
		}
		childs[name] = currentChild;
		addChild(currentChild);
	}

	//empty function so that the interactive Icons are automaticly binded to this function
	//the popin will inherit from this class and then can overide this function to configure the child click action
	private function childClick(pEvent:InteractionData){

	}

	// empty function so that we can capture the clickEvent on the modal and not on anythingBelow
	private function stopClickEventPropagation(pEvent:InteractionData){

	}
	
	// !! ask mathieu if when we destroy a popin it destroy its childs too !!
	public function destroy (): Void {

	}
}
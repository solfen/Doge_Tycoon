package popin;

import popin.IconPopin;
import pixi.display.DisplayObjectContainer;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;
import utils.system.DeviceCapabilities;
import pixi.text.BitmapText;

//Base PopIn class, all popIn will inherit from this
// it's a DisplayObjectContainer, has a base x & y, clickEvent and a destroy method that destroy the popin (and its icons)
class MyPopin extends DisplayObjectContainer
{
	private var background:Sprite;
	private var modalZone:Sprite;
	private var childs:Map<String, Sprite> = new Map();
	private var currentChild:Sprite;
	
	public function new(startX:Float=0,startY:Float=0, texturePath:String, ?isModal:Bool=true) 
	{
		super();
		// *width so that it's in % of screen
		x=startX*DeviceCapabilities.width;
		y=startY*DeviceCapabilities.height;

		if(isModal){
			modalZone = new Sprite(Texture.fromImage("assets/alpha_bg.png"));
			modalZone.x= -startX*DeviceCapabilities.width;
			modalZone.y= -startY*DeviceCapabilities.height;
			modalZone.width = DeviceCapabilities.width;
			modalZone.height = DeviceCapabilities.height;
			modalZone.interactive = true; // if false, things behind are clickable
			modalZone.click = stopClickEventPropagation;
			childs["modal"] = modalZone;
			addChild(modalZone);
		}

		//if we dont have a texturePath then we take it from the class name

		background = new Sprite(Texture.fromImage(texturePath));
		background.anchor.set(0.5, 0.5);
		childs["background"] = background;
		addChild(background);
	}

	// creates an IconPopin and puts it in the childs array
	private function addIcon(x:Float,y:Float, texturePath:String, name:String, ?isInteractive:Bool=true){
		currentChild = new IconPopin(x*background.width-background.width/2,y*background.height-background.height/2,texturePath,name,isInteractive);
		if(isInteractive){
			currentChild.click = childClick;
		}
		childs[name] = currentChild;
		addChild(currentChild);
	}
	function addText(x:Float,y:Float,font:String,fontSize:String,txt:String,name:String,?pAlign:String="center"){
		//new BitmapText( text : String , style : pixi.text.BitmapTextStyle )
		var style:BitmapTextStyle = {font:fontSize+" "+font,align:pAlign};
		var tempText = new BitmapText(txt, style);
		tempText.position.x = x*DeviceCapabilities.width; //- bitmapFontText.width - 20;
		tempText.position.y = y*DeviceCapabilities.height; //20;
		addChild(tempText);
	}
	//empty function so that the interactive Icons are automaticly binded to this function
	//the popin will inherit from this class and then can overide this function to configure the childs click action
	private function childClick(pEvent:InteractionData){

	}

	// empty function so that we can capture the clickEvent on the modal and not on anythingBelow
	private function stopClickEventPropagation(pEvent:InteractionData){

	}
	
	// !! ask mathieu if when we destroy a popin it destroy its childs too !!
	public function destroy (): Void {

	}
}
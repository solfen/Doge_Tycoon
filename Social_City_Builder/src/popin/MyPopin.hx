package popin;

import popin.IconPopin;
import pixi.display.DisplayObjectContainer;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;
import utils.system.DeviceCapabilities;
import pixi.text.Text;
import pixi.primitives.Graphics;

//Base PopIn class, all popIn will inherit from this
// it's a DisplayObjectContainer, has a base x & y, clickEvent and a destroy method that destroy the popin (and its icons)
// TODO : remove functions + MAJ description
class MyPopin extends DisplayObjectContainer
{
	private var background:Sprite;
	private var modalZone:Sprite;
	private var childs:Map<String, Sprite> = new Map();
	private var containers:Map<String, DisplayObjectContainer> = new Map();
	private var currentChild:Sprite;
	private var scrollIndicator:Sprite;
	private var graphics:Graphics;
	private var scrollDragging:Bool = false;
	private var scrollDragSy:Float;
	
	public function new(startX:Float=0,startY:Float=0, texturePath:String, ?isModal:Bool=true) 
	{
		super();
		// *width so that it's in % of screen
		x=Std.int(startX*DeviceCapabilities.width);
		y=Std.int(startY*DeviceCapabilities.height);

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
	private function addIcon(x:Float,y:Float, texturePath:String, name:String, target:DisplayObjectContainer,?isInteractive:Bool=true,?texturePathActive:String):Void{
		//int cast because Float pos = blurry images
		currentChild = new IconPopin(Std.int(x*background.width-background.width/2),Std.int(y*background.height-background.height/2),texturePath,name,isInteractive,texturePathActive);
		if(isInteractive){
			currentChild.click = childClick;
		}
		childs[name] = currentChild;
		target.addChild(currentChild);
	}
	private function addText(x:Float,y:Float,font:String,fontSize:String,txt:String,name:String,target:DisplayObjectContainer,?pAlign:String="left"):Void{
		var style:TextStyle = {font:fontSize+" "+font,align:pAlign};
		var tempText:Text = new Text(txt, style);
		tempText.position.x = Std.int(x*background.width-background.width/2);
		tempText.position.y = Std.int(y*background.height-background.height/2); 
		childs[name] = tempText;
		target.addChild(tempText);
	}
	// put a mask on a container so if its childs are outside of the mask they wont be rendered
	private function addMask(x:Float,y:Float,width:Float,height:Float,target:DisplayObjectContainer){
		graphics = new Graphics();
		addChild(graphics); // if we dont add grphics, the position will be relative to the screen and not to the popin
		graphics.beginFill(0xFF3300); //random color, doesn't matter as it wont be visible
		graphics.drawRect(x, y, width, height);
		graphics.endFill();
		target.mask = graphics; // this line assign the mask at the container and all of his childrens (present past and future)
	}

	//place a vertical scrollBar, the scroll action is automaticly added to containers["verticalScroller"]
	private function addVerticalScrollBar(){
		addIcon(0.91,0.15,'assets/UI/PopIn/PopInScrollingBar.png',"scrollingBar",this,false);
		scrollIndicator = new IconPopin(Std.int(0.933*background.width-background.width/2),Std.int(0.23*background.height-background.height/2),'assets/UI/PopIn/PopInScrollingTruc.png',"scrollingIndicator",true);
		scrollIndicator.mousedown = function(data) {
			scrollDragging = true;
			scrollDragSy = data.getLocalPosition(scrollIndicator).y * scrollIndicator.scale.y;	
		};
		scrollIndicator.mouseup = scrollIndicator.mouseupoutside = function(data) {
			scrollDragging = false;
		};
		scrollIndicator.mousemove = function(data){
			var newY:Float = data.getLocalPosition(scrollIndicator.parent).y - scrollDragSy;
			if(scrollDragging && newY > 0.23*background.height-background.height/2 && newY < 0.635*background.height-background.height/2) {
				var interval:Float = (0.635*background.height-background.height/2) - (0.23*background.height-background.height/2 );
				var maxScroll:Float = containers["verticalScroller"].height-childs["contentBackground"].height + 100; // 100 is totaly changeable
				scrollIndicator.y = newY;
				containers["verticalScroller"].y =  - Std.int(((newY - (0.23*background.height-background.height/2)) * maxScroll  / interval)); // math stuff fait à l'arrache (plus ou moins)
			}
		}
		childs["scrollingIndicator"] = scrollIndicator;
		addChild(scrollIndicator);
	}
	private function removeVerticalScrollBar(){
		removeChild(childs["scrollingIndicator"]);
		removeChild(childs["scrollingBar"]);
		scrollIndicator = childs["scrollingIndicator"] = childs["scrollingBar"] = null;
	}
	// add a DisplayObjectContainer à la popin. attention : Les containers ne sont pas dans childs mais dans containers
	private function addContainer(name:String,target:DisplayObjectContainer,?x:Float=0,?y:Float=0){
		var temp:DisplayObjectContainer = new DisplayObjectContainer();
		temp.x = x;
		temp.y = y;
		containers[name] = temp;
		target.addChild(temp);
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
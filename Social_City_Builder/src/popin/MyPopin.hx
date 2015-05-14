package popin;

import popin.IconPopin;
import pixi.display.DisplayObjectContainer;
import pixi.InteractionData;
import utils.events.Event;
import pixi.textures.Texture;
import pixi.display.Sprite;
import utils.system.DeviceCapabilities;
import pixi.text.Text;
import pixi.primitives.Graphics;
import utils.game.InputInfos;

//Base PopIn class, all popIn will inherit from this
// it's a DisplayObjectContainer, has a base x & y, clickEvent and a destroy method that destroy the popin (and its icons)
// TODO : remove functions + MAJ description
class MyPopin extends DisplayObjectContainer
{
	private var startX:Float;
	private var startY:Float;
	private var background:Sprite;
	private var modalZone:Sprite;
	private var texts:Map<String, Text> = new Map();
	private var icons:Map<String, IconPopin> = new Map();
	private var containers:Map<String, DisplayObjectContainer> = new Map();
	private var currentChild:Sprite;
	private var scrollIndicator:IconPopin;
	private var graphics:Graphics;
	private var scrollDragging:Bool = false;
	private var scrollDragSy:Float;
	private var header:Sprite;
	private var headerTextures:Map<String,Texture>;
	private var mouse_wheel_dir:Int;
	private var startScrollY:Float;
	private var maxDragY:Float;
	
	public function new(pstartX:Float=0,pstartY:Float=0, texturePath:String, ?isModal:Bool=false) 
	{
		super();
		startX = pstartX;
		startY = pstartY;
		onResize();

		/*if(isModal){
			modalZone = new Sprite(Texture.fromFrame("assets/alpha_bg.png")); !!! TO REDO !!!
			modalZone.x= -startX*DeviceCapabilities.width;
			modalZone.y= -startY*DeviceCapabilities.height;
			modalZone.width = DeviceCapabilities.width;
			modalZone.height = DeviceCapabilities.height;
			modalZone.interactive = true; // if false, things behind are clickable
			modalZone.click = stopClickEventPropagation;
			childs["modal"] = modalZone;
			addChild(modalZone);
		}*/
		Main.getInstance().addEventListener(Event.RESIZE, onResize);

		background = new Sprite(Texture.fromFrame(texturePath));
		background.anchor.set(0.5, 0.5);
		addChild(background);		
	}

	// creates an IconPopin and puts it in the childs array
	private function addIcon(x:Float,y:Float, texturePath:String, name:String, target:DisplayObjectContainer,?isInteractive:Bool=false,?texturePathActive:String,?pIsSelectButton:Bool=false):Void{
		//int cast because Float pos = blurry images
		var icon:IconPopin = new IconPopin(Std.int(x*background.width-background.width/2),Std.int(y*background.height-background.height/2),texturePath,name,isInteractive,texturePathActive,pIsSelectButton);
		if(isInteractive){
			icon.mouseup = childClick;
			icon.mouseupoutside = childUpOutside;
		}
		icons[name] = icon;
		target.addChild(icon);
	}

	private function addHeader(x:Float,y:Float,startTexture:Texture){
		header = new Sprite(startTexture);
		header.position.set(Std.int(x*background.width-background.width/2),Std.int(y*background.height-background.height/2));
		addChild(header);
	}
	private function addText(x:Float,y:Float,font:String,fontSize:String,txt:String,name:String,target:DisplayObjectContainer,?color:String="black",?pAlign:String="left"):Void{
		var style:TextStyle = {font:fontSize+" "+font,align:pAlign,fill:color};
		var tempText:Text = new Text(txt, style);
		tempText.position.x = Std.int(x*background.width-background.width/2);
		tempText.position.y = Std.int(y*background.height-background.height/2); 
		texts[name] = tempText;
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
		addIcon(0.91,0.15,'PopInScrollingBar.png',"scrollingBar",this,false);
		scrollIndicator = new IconPopin(Std.int(0.933*background.width-background.width/2),Std.int(0.23*background.height-background.height/2),'PopInScrollingTruc.png',"scrollingIndicator",true);
		scrollIndicator.mousedown = function(data) {
			scrollDragging = true;
			scrollDragSy = data.getLocalPosition(scrollIndicator).y * scrollIndicator.scale.y;	
		};
		scrollIndicator.mouseup = scrollIndicator.mouseupoutside = function(data) {
			scrollDragging = false;
		};
		scrollIndicator.mousemove = function(data){
			var newY:Float = data.getLocalPosition(scrollIndicator.parent).y - scrollDragSy;
			maxDragY = containers["verticalScroller"].height-icons["contentBackground"].height + 100; // 100 is totaly changeable
			if(scrollDragging && newY > 0.23*background.height-background.height/2 && newY < 0.635*background.height-background.height/2) {
				var interval:Float = (0.635*background.height-background.height/2) - (0.23*background.height-background.height/2 );
				scrollIndicator.y = newY;
				containers["verticalScroller"].y =  - Std.int(((newY - (0.23*background.height-background.height/2)) * maxDragY  / interval)); // math stuff fait à l'arrache (plus ou moins)
			}
		}
		icons["scrollingIndicator"] = scrollIndicator;
		addChild(scrollIndicator);
		mouse_wheel_dir = InputInfos.mouse_wheel_dir;
		startScrollY = containers["verticalScroller"].y;
		Main.getInstance().addEventListener(Event.GAME_LOOP, scroll);
	}
	private function scroll(){
		if(InputInfos.mouse_wheel_dir == 0 
		|| InputInfos.mouse_x - x+background.width/2  > background.x + background.width  
		|| InputInfos.mouse_x - x+background.width/2  < background.x
		|| InputInfos.mouse_y - y+background.height/2 > background.y + background.height 
		|| InputInfos.mouse_y - y+background.height/2 < background.y )
			return;

		var maxScrollY:Float = containers["verticalScroller"].height - icons["articleBase"].height*3+25;
		var contentDeltaY:Float = -(mouse_wheel_dir + InputInfos.mouse_wheel_dir)/3 * icons["articleBase"].height * 0.5;
		if(contentDeltaY <= 0
		&& contentDeltaY > -maxScrollY) {
			mouse_wheel_dir += InputInfos.mouse_wheel_dir;
			containers["verticalScroller"].y = Std.int(startScrollY + contentDeltaY);
			scrollIndicator.y = Std.int((-(contentDeltaY/maxScrollY)*(0.635-0.23) + 0.23) * background.height-background.height/2);
		}
		InputInfos.mouse_wheel_dir = 0; // !! BAD FIND ANOTHER WAY
	}
	private function removeVerticalScrollBar(){
		removeChild(icons["scrollingIndicator"]);
		removeChild(icons["scrollingBar"]);
		scrollIndicator = null;
		icons["scrollingIndicator"] = null;
		icons["scrollingBar"] = null;
	}

	// add a DisplayObjectContainer à la popin. attention : Les containers ne sont pas dans childs mais dans containers
	private function addContainer(name:String,target:DisplayObjectContainer,?x:Float=0,?y:Float=0){
		var temp:DisplayObjectContainer = new DisplayObjectContainer();
		temp.x = x;
		temp.y = y;
		containers[name] = temp;
		target.addChild(temp);
	}

	private function onResize():Void{
		// * screen width so that it's in % of screen
		x=Std.int(startX*DeviceCapabilities.width);
		y=Std.int(startY*DeviceCapabilities.height);
	}

	//any popin will inherit from this class and then can overide this function to configure the childs click action
	private function childClick(pEvent:InteractionData){}
	private function childUpOutside(pEvent:InteractionData){}
	public function update(){}

	// empty function so that we can capture the clickEvent on the modal and not on anythingBelow
	private function stopClickEventPropagation(pEvent:InteractionData){}
	
	public function destroy (): Void {
		Main.getInstance().removeEventListener(Event.GAME_LOOP, scroll);
	}
}
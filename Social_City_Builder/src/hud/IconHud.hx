package hud;

import pixi.textures.Texture;
import pixi.display.Sprite;
import utils.system.DeviceCapabilities;
import pixi.InteractionData;

// IconHud is a pixi.Sprite tuned for the HUD use.
class IconHud extends Sprite {
	private var texturePath:String;
	private var normalTexture:Texture;
	private var activeTexture:Texture = null;
	private var hoverTexture:Texture = null;
	public var isUpdatable:Bool;

	public function new(startX:Float,startY:Float, texturePathNormal:String, ?texturePathActive:String, ?pIsUpdatable:Bool=false, ?isInteractive:Bool=true) {
		//textures creation. Has to have at least the normal state the others are optionals
		normalTexture = Texture.fromFrame(texturePathNormal);
		if(texturePathActive != null){
			activeTexture = Texture.fromImage(texturePathActive);
		}
		/*if(texturePathHover != null){
			hoverTexture = Texture.fromImage(texturePathHover);
		}*/

		// create the icon add params it trasform to int because float position = horrible canvas perf and blurry images
		super(normalTexture);
		position.set(Std.int(startX*DeviceCapabilities.width),Std.int(startY*DeviceCapabilities.height));

		if(isInteractive){
			interactive = true;
			buttonMode 	= true;
			mousedown 	= onMouseDown;
			mouseup  	= onMouseUp;
			click 		= onClick;
		}
		isUpdatable = pIsUpdatable;
	}

	//check the state and if we have the according texture
	private function changeTexture(state:String){
		if(state == "active" && activeTexture != null){
			setTexture(activeTexture);
		}
		/*else if(state == "hover" && hoverTexture != null){
			setTexture(hoverTexture);
		}*/
		else if(state == "normal"){
			setTexture(normalTexture);
		}
		else{
			trace("IconHud changeTexture() : Invalid texture change, check if correct state and/or correct textures. State: "+state);
		}
	}
	private function onMouseDown(pData:InteractionData){
		if(activeTexture != null){
			setTexture(activeTexture);
		}
	}
	private function onMouseUp(pData:InteractionData){
		setTexture(normalTexture);
	}
	private function onClick(pData:InteractionData){}
	public function updateInfo(){}
}
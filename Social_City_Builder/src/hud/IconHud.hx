package hud;

import pixi.textures.Texture;
import pixi.display.Sprite;
import utils.system.DeviceCapabilities;

// IconHud is a pixi.Sprite tuned for the HUD use.
class IconHud extends Sprite {
	private var texturePath:String;
	private var normalTexture:Texture;
	private var activeTexture:Texture = null;
	private var hoverTexture:Texture = null;

	public function new(startX:Float,startY:Float, texturePathNormal:String, ?texturePathActive:String, ?texturePathHover:String) {
		//textures creation. Has to have at least the normal state the others are optionals
		normalTexture = Texture.fromImage(texturePathNormal);
		if(texturePathActive != null){
			activeTexture = Texture.fromImage(texturePathActive);
		}
		if(texturePathHover != null){
			hoverTexture = Texture.fromImage(texturePathHover);
		}

		// create the icon add params it
		super(normalTexture);
		anchor.set(0.5, 0.5);
		x = startX*DeviceCapabilities.width;
		y = startY*DeviceCapabilities.height;
	}

	//check the state and if we have the according texture
	private function changeTexture(state:String){
		if(state == "active" && activeTexture != null){
			setTexture(activeTexture);
		}
		else if(state == "hover" && hoverTexture != null){
			setTexture(hoverTexture);
		}
		else if(state == "normal"){
			setTexture(normalTexture);
		}
		else{
			trace("IconHud changeTexture() : Invalid texture change, check if correct state and/or correct textures. State: "+state);
		}
	}
}
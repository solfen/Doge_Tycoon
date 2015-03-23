package popin;

import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

// IconPopin is a pixi.Sprite tuned for the Popin use.
class IconPopin extends Sprite
{
	private var _name:String;
	private var normalTexture:Texture;
	private var activeTexture:Texture = null;
	private var isSelectButton:Bool = false;
	private var isCurrentTextureNormal:Bool = true;

	public function new(pX:Float,pY:Float, texturePathNormal:String,pName:String,isInteractive:Bool,?texturePathActive:String,?pIsSelectButton:Bool=false) 
	{
		normalTexture = Texture.fromImage(texturePathNormal);
		isSelectButton=pIsSelectButton;
		if(texturePathActive != null){
			activeTexture = Texture.fromImage(texturePathActive);
		}
		super(normalTexture);	
		x = pX;
		y = pY;
		_name = pName;
		interactive = isInteractive;
		buttonMode = isInteractive;
		if(isInteractive && !isSelectButton){
			mouseover = onMouseOver;
			mouseout  = onMouseOut;
		}
		else if(isSelectButton){
			mousedown = onClick; //mousedown because click is binded on childClick in MyPopin
		}
		mouseupoutside = onIconUpOutside;
	}
	private function onMouseOver (pData:InteractionData): Void {
		if(activeTexture == null){
			return;
		}
		setTexture(activeTexture);
	}
	private function onMouseOut (pData:InteractionData): Void {
		setTexture(normalTexture);
	}
	private function onClick (pData:InteractionData): Void {
		if(activeTexture == null){
			return;
		}
		setTexture(activeTexture);
	}
	private function onIconUpOutside(pData:InteractionData){

	}
	public function setTextureToNormal(?pData:InteractionData):Void{
		setTexture(normalTexture);
	}
	public function setTextureToActive():Void{
		setTexture(activeTexture);
	}
}
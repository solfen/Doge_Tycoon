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

	public function new(pX:Float,pY:Float, texturePathNormal:String,pName:String,isInteractive:Bool,?texturePathActive:String) 
	{
		normalTexture = Texture.fromImage(texturePathNormal);
		if(texturePathActive != null){
			activeTexture = Texture.fromImage(texturePathActive);
		}
		super(normalTexture);	
		x = pX;
		y = pY;
		_name = pName;
		interactive = isInteractive;
		buttonMode = isInteractive;
		if(isInteractive){
			mouseover 	= onMouseOver;
			mouseout  	= onMouseOut;
		}
	}
	private function onMouseOver (pData:InteractionData): Void {
		if(activeTexture != null){
			setTexture(activeTexture);
		}
	}
	private function onMouseOut (pData:InteractionData): Void {
		setTexture(normalTexture);
	}
}
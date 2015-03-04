package popin;

import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

// IconPopin is a pixi.Sprite tuned for the Popin use.
class IconPopin extends Sprite
{
	private var _name:String;
	public function new(pX:Float,pY:Float, pTexturePath:String,pName:String,isInteractive:Bool) 
	{
		super(Texture.fromImage(pTexturePath));	
		x = pX;
		y = pY;
		_name = pName;
		interactive = isInteractive;
		buttonMode = isInteractive;
	}
}
package hud;

import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.Sprite;

// IconHud is a pixi.Sprite tuned for the HUD use.
class IconHud extends Sprite
{
	private var texturePath:String;

	public function new(startX:Float,startY:Float, ?texture:String) 
	{
		var lCompleteClassName : String = Type.getClassName(Type.getClass(this));
		texturePath = lCompleteClassName.substr(lCompleteClassName.lastIndexOf(".") + 1);
		texturePath = "assets/"+texturePath+".png";

		/*if we pass a texture in parameter, then we override the texture path*/
		if(texture != null){
			texturePath = "assets/"+texture+".png";
		}

		super(Texture.fromImage(texturePath));
		x = startX;
		y = startY;
		interactive = true;
		buttonMode = true;
		click = onClick;
		mouseover  = onMouseOver;
	}

	private function onClick (pData:InteractionData): Void {

	}	
	private function onMouseOver (pData:InteractionData): Void {

	}	
}
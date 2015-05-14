package utils.game;

import pixi.display.Sprite;
import pixi.textures.Texture;


// A sprite extension to used it as a Particle

class Particle extends Sprite
{
	public var direction:Float;
	public var speed:Float;

	public function new (texture:Texture){
		super(texture);
	}
}
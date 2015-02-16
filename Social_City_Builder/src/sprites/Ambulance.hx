package sprites;

import popin.PopinManager;
import utils.system.DeviceCapabilities;
import pixi.display.MovieClip;
import pixi.InteractionData;
import pixi.textures.Texture;

/**
 * ...
 * @author Mathieu ANTHOINE
 */
class Ambulance extends MovieClip
{

	private static var images:Array<String> = ["E","SE","S","SW","W","NW","N","NE"];
	
	private var popinChoice:Bool;
	
	public function new() 
	{
		super(getTexture());
		anchor.set(0.5, 0.5);
		animationSpeed = 0.2;
		play();
		
		interactive = true;
		buttonMode = true;
		click = onClick;
	}
	
	private function onClick (pData:InteractionData): Void {
		PopinManager.getInstance().openPopin("PopinBuild", DeviceCapabilities.width/2, DeviceCapabilities.height/2);
	}
	
	/**
	 * Tableau de textures de l'ambulance
	 * @return le tableau de textures
	 */
	private static function getTexture():Array<Texture> {
		var lTexture:Array<Texture> = new Array<Texture>();
		for (i in 0...images.length) lTexture.push(Texture.fromFrame("ambulance_"+images[i] + ".png"));
		return lTexture;
	}
	
}
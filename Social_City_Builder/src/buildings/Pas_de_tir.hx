package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
import pixi.InteractionData;
import pixi.display.MovieClip;
import pixi.textures.Texture;
import externs.dat.gui.GUI;

class Pas_de_tir extends Building
{
	private var shipLaunching:MovieClip;
	private var shipToRemove:Bool = false;
	private var shipErasingSpeed:Float = 0.01;
	private var shipLaunchingTextures:Array<Texture> = [];

	private var gui:GUI;
	private var guiListValues:Array<String> = ['shipOffestX','shipOffestY','shipAnimationSpeed'];
	private var shipOffestX:Float = 0.465;
	private var shipOffestY:Float = 0.15;
	private var shipAnimationSpeed:Float = 0.22;

	public function new (p_index: Int, pX: Int, pY: Int) : Void {
		super(Building.PAS_DE_TIR, p_index, pX, pY);
		outline_thick_max = 9;
	}
	override private function _on_click (p_data: InteractionData): Void {
		if (!is_builded || !is_clickable || !GameInfo.can_map_update) {
			return;
		}
		if (GameInfo.isUpgradeMode && GameInfo.ressources['fric'].userPossesion > 0)
		{
			GameInfo.ressources['fric'].userPossesion--;
			upgrade();
		}
	}
	override private function _update () : Void {
		super._update();
		if(GameInfo.shipToLaunch != null){
			for(i in 0...25){
				shipLaunchingTextures.push(Texture.fromFrame('Fusee'+GameInfo.shipToLaunch+'_'+i+'.png'));
			}
			shipLaunching = new MovieClip(shipLaunchingTextures);
			IsoMap.singleton.addChild(shipLaunching);
			shipLaunching.anchor.set(0.5,1);
			shipLaunching.position.set(position.x+width*shipOffestX,position.y-height*shipOffestY);
			shipLaunching.loop = false;
			shipLaunching.onComplete = shipLaunched;
			shipLaunching.animationSpeed = shipAnimationSpeed;
			shipLaunching.play();
			GameInfo.shipToLaunch = null;
			//debugGUI();
		}
		if(shipToRemove){
			shipLaunching.alpha -= shipErasingSpeed;
			if(shipLaunching.alpha <= 0){
				IsoMap.singleton.removeChild(shipLaunching);
				shipLaunching = null;
				shipLaunchingTextures = [];
				shipToRemove = false;
			}
		}
	}
	private function shipLaunched() : Void {
		shipToRemove = true;
	}
	private function debugGUI() : Void {
		gui = new GUI();
		for(i in guiListValues){
			gui.add(this, i,-1,1).step(0.0001).onChange(function(newValue) {
				shipLaunching.position.set(position.x+width*shipOffestX,position.y-height*shipOffestY);
				shipLaunching.animationSpeed = shipAnimationSpeed;
			});
		}
	}
}

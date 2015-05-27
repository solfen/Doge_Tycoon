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
	private var shipLaunching: MovieClip;
	private var shipToRemove: Bool;
	private var shipErasingSpeed: Float;
	private var shipLaunchingTextures: Array<Texture>;

	private var gui: GUI;
	private var guiListValues: Array<String>;
	private var shipOffestX: Float;
	private var shipOffestY: Float;
	private var shipAnimationSpeed: Float;


	public function new (p_index: Int, pX: Int, pY: Int) : Void
	{
		super(Building.PAS_DE_TIR, p_index, pX, pY);

		outline_thick_max = 9;
		//outline_thick_min = 1;

		shipToRemove = false;
		shipErasingSpeed = 0.01;
		shipLaunchingTextures = [];
		guiListValues = ['shipOffestX','shipOffestY','shipAnimationSpeed'];
		shipOffestX = 0.465;
		shipOffestY = 0.15;
		shipAnimationSpeed = 0.22;
	}

	override private function _update () : Void
	{
		super._update();

		if (GameInfo.shipToLaunch != null)
		{
			for (i in 0...25)
			{
				shipLaunchingTextures.push(Texture.fromFrame('Fusee'+GameInfo.shipToLaunch+'_'+i+'.png'));
			}

			shipLaunching = new MovieClip(shipLaunchingTextures);
			shipLaunching.anchor.set(0.5, 1);
			shipLaunching.position.set(position.x + width * shipOffestX, position.y - height * shipOffestY);
			shipLaunching.loop = false;
			shipLaunching.onComplete = shipLaunched;
			shipLaunching.animationSpeed = shipAnimationSpeed;
			shipLaunching.play();
			IsoMap.singleton.addChild(shipLaunching);

			GameInfo.shipToLaunch = null;

			//debugGUI();
		}

		if (shipToRemove)
		{
			shipLaunching.alpha -= shipErasingSpeed;

			if (shipLaunching.alpha <= 0)
			{
				IsoMap.singleton.removeChild(shipLaunching);
				shipLaunching = null;
				shipLaunchingTextures = [];

				shipToRemove = false;
			}
		}
	}

	private function shipLaunched () : Void
	{
		shipToRemove = true;
	}

	private function debugGUI () : Void
	{
		gui = new GUI();

		for (i in guiListValues)
		{
			gui.add(this, i, -1, 1).step(0.0001).onChange(function (newValue) 
			{
				shipLaunching.position.set(position.x + width * shipOffestX, position.y - height * shipOffestY);
				shipLaunching.animationSpeed = shipAnimationSpeed;
			});
		}
	}
}

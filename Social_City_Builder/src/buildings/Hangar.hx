package buildings;

import buildings.Building;
import popin.PopinManager;
//import utils.events.Event;
//import utils.game.InputInfos;
import pixi.InteractionData;


class Hangar extends Building
{
	
	private var workshopConfig: Map<String,Dynamic>;

	public function new (pBdd_id: String, p_type: Int, p_index: Int, pX: Int, pY: Int): Void // attention, le type (la couleur) doit être précisié
	{
		super(p_type, pBdd_id, p_index, pX, pY);

		outline_thick_max = 1;
		//outline_thick_min = 1;

		workshopConfig = [
			'config'=> {
				workshopType: p_type,
				level: 1,
				state: 'buy', // || 'launch' || 'build'
				spaceShip: "",
				spaceShipID: "",
				clickNb: 0,
				buildTimeStart: 0
			}
		];
	}


	override private function _on_click (): Int
	{
		if (super._on_click() == Building.CLICK_VALUE.NOTHING)
		{
			PopinManager.getInstance().openPopin("PopinWorkshop", 0.5, 0.5, workshopConfig);

			return Building.CLICK_VALUE.OTHER;
		}

		return Building.CLICK_VALUE.NOTHING;
	}

	override public function upgrade ()
	{
		super.upgrade();

		workshopConfig['config'].level += workshopConfig['config'].level == 3 ? 0 : 1;
	}
}

package buildings;

import buildings.Building;
import popin.PopinManager;
//import utils.events.Event;
//import utils.game.InputInfos;
import pixi.InteractionData;


class Hangar extends Building
{
	
	private var workshopConfig: Map<String,Dynamic>;

	public function new (p_type: Int, p_index: Int, pX: Int, pY: Int): Void // attention, le type (la couleur) doit être précisié
	{
		super(p_type, p_index, pX, pY);

		outline_thick_max = 1;
		outline_thick_min = 0.1;

		workshopConfig= [
			'config'=> {
				workshopType: p_type,
				level: 1,
				state: 'buy', // || 'launch' || 'build'
				spaceShip: "",
				buildTimeStart: 0
			}
		];
	}


	override private function _on_click (p_data: InteractionData): Void
	{
		if (!is_builded || !is_clickable || !GameInfo.can_map_update)
		{
			trace(alpha);
			return;
		}

		if (GameInfo.isUpgradeMode && GameInfo.ressources['fric'].userPossesion > 0)
		{
			GameInfo.ressources['fric'].userPossesion--;
			upgrade();
		}
		else if (GameInfo.isDestroyMode)
		{
			destroy();
			return;
		}
		else
		{
			PopinManager.getInstance().openPopin("PopinWorkshop", 0.5, 0.5, workshopConfig);	
		}
	}

	override public function upgrade ()
	{
		super.upgrade();
		workshopConfig['config'].level += workshopConfig['config'].level == 3 ? 0 : 1;
	}
}

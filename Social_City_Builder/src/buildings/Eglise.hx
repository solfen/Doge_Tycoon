package buildings;

import buildings.Building;
import popin.PopinManager;
//import utils.events.Event;
//import utils.game.InputInfos;
import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Eglise extends Building
{

	public function new (pBdd_id: String, p_index: Int, pX: Int, pY: Int, pIs_rebuild: Bool): Void
	{
		super(Building.EGLISE, pBdd_id, p_index, pX, pY, pIs_rebuild);

		outline_thick_max = 3;
		//outline_thick_min = 1;
	}

	override private function _on_click (): Int
	{
		if (super._on_click() == Building.CLICK_VALUE.NOTHING)
		{
			PopinManager.getInstance().openPopin("PopinChurch", 0.5, 0.5);

			return Building.CLICK_VALUE.OTHER;
		}
		
		return Building.CLICK_VALUE.NOTHING;
	}
}

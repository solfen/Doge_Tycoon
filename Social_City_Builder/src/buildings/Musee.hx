package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Musee extends Building
{

	public function new (pBdd_id: String, p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.MUSEE, pBdd_id, p_index, pX, pY);

		outline_thick_max = 1;
		//outline_thick_min = 1;
	}

	override private function _on_click (): Int
	{
		if (super._on_click() == Building.CLICK_VALUE.NOTHING)
		{
			popin.PopinManager.getInstance().openPopin("PopinMusee", 0.5, 0.5);

			return Building.CLICK_VALUE.OTHER;
		}
		
		return Building.CLICK_VALUE.NOTHING;
	}
}

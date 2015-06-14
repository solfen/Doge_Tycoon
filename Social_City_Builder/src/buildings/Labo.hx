package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Labo extends Building
{

	public function new (pBdd_id: String, p_index: Int, pX: Int, pY: Int, pIs_rebuild: Bool): Void
	{
		super(Building.LABO, pBdd_id, p_index, pX, pY, pIs_rebuild);
		
		outline_thick_max = 1;
		//outline_thick_min = 1;
	}
}

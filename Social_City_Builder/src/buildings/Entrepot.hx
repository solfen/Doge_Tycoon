package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Entrepot extends Building
{

	public function new (pBdd_id: String, p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.ENTREPOT, pBdd_id, p_index, pX, pY);
		
		outline_thick_max = 1.5;
		//outline_thick_min = 1;
	}
}

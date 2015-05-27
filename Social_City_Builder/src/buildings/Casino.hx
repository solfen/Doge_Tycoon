package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Casino extends Building
{

	public function new (p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.CASINO, p_index, pX, pY);
		
		outline_thick_max = 3;
		//outline_thick_min = 1;
	}
}

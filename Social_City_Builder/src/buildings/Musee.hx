package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Musee extends Building
{

	public function new (p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.MUSEE, p_index, pX, pY);
		
	}
}

package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Hangar extends Building
{

	public function new (p_type: Int, p_index: Int, pX: Int, pY: Int): Void // attention, le type (la couleur) doit être précisié
	{
		super(p_type, p_index, pX, pY);
		
	}
}

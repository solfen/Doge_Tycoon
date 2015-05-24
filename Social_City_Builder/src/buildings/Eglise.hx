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

	public function new (p_index: Int, pX: Int, pY: Int): Void {
		super(Building.EGLISE, p_index, pX, pY);
		outline_thick_max = 3;
	}
	override private function _on_click (p_data: InteractionData): Void {
		if (!is_builded || !is_clickable || !GameInfo.can_map_update)
		{
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
		else {
			PopinManager.getInstance().openPopin("PopinChurch", 0.5, 0.5);	
		}
	}
}

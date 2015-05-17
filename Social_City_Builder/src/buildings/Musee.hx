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

	public function new (p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.MUSEE, p_index, pX, pY);
		outline_thick_max = 1;
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
			popin.PopinManager.getInstance().openPopin("PopinMusee", 0.5, 0.5);	
		}
	}
}

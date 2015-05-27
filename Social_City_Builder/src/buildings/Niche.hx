package buildings;

import buildings.Building;
//import utils.events.Event;
//import utils.game.InputInfos;
//import pixi.InteractionData;

/**
 * ...
 * @author Lucien Boudy
 */
class Niche extends Building
{
	private var nbDogesInside: Int;

	public function new (p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.NICHE, p_index, pX, pY);
		
		outline_thick_max = 1;
		//outline_thick_min = 1;

		GameInfo.dogeMaxNumber += GameInfo.buildingsGameplay[get_id()].dogesMaxGain;
		nbDogesInside = GameInfo.buildingsGameplay[get_id()].dogesMaxGain;
	}

	override public function upgrade (): Void 
	{
		super.upgrade();

		if (lvl < Building.LVL_3)
		{
			GameInfo.dogeMaxNumber += GameInfo.buildingsGameplay[get_id()].dogesMaxGain;	
			nbDogesInside += GameInfo.buildingsGameplay[get_id()].dogesMaxGain;	
		}
	}

	override public function destroy (): Void 
	{
		super.destroy();
		GameInfo.buildingsGameplay[type | lvl].userPossesion--;
		GameInfo.dogeMaxNumber -= nbDogesInside;	
	}
}

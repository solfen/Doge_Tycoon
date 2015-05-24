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
	private var nbDogesInside:Int = 0;

	public function new (p_index: Int, pX: Int, pY: Int): Void
	{
		super(Building.NICHE, p_index, pX, pY);
		outline_thick_max = 3;
		GameInfo.dogeMaxNumber += GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].dogesMaxGain;
		nbDogesInside += GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].dogesMaxGain;

	}
	override public function upgrade(): Void 
	{
		super.upgrade();
		if (lvl < Building.LVL_3){
			GameInfo.dogeMaxNumber += GameInfo.buildingsGameplay[Building.NICHE | lvl].dogesMaxGain;	
			nbDogesInside += GameInfo.buildingsGameplay[Building.NICHE | lvl].dogesMaxGain;	
		}
	}
	override public function destroy (): Void 
	{
		super.destroy();
		GameInfo.buildingsGameplay[type | lvl].userPossesion--;
		GameInfo.dogeMaxNumber -= nbDogesInside;	
	}
}

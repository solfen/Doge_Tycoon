package buildings;

import buildings.Building;

/**
 * ...
 * @author Lucien Boudy
 */
class PreviewBuilding extends Building
{


	public function new (p_type: Int, pX: Int, pY: Int): Void
	{
		super(p_type, 0, 0, pX, pY);
		
		click = null;
		interactive = false;
		buttonMode = false;
		alpha = 0.5;
	}
}
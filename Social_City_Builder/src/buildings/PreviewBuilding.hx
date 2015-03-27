package buildings;

import buildings.Building;

/**
 * ...
 * @author Lucien Boudy
 */
class PreviewBuilding extends Building
{

	public static var CANT_BUILD_COLOR: Int = 0xFF4444;

	public function new (p_type: Int, pX: Int, pY: Int): Void
	{
		super(p_type, 0, 0, pX, pY);
		
		click = null;
		interactive = false;
		buttonMode = false;
		alpha = 0.7;
	}
}
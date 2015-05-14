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
		super(p_type, -1, pX, pY);
		
		click = null;
		mouseover = null;
		interactive = false;
		buttonMode = false;
		alpha = 0.7;
		filter = null;
		//filters = [];
	}

	private override function _update (): Void // overriding
	{

	}
}
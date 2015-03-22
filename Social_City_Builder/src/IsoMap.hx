package;

import utils.system.DeviceCapabilities;
import utils.events.Event;
import utils.game.IsoTools;
import utils.game.InputInfos;
import sprites.Building;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.extras.TilingSprite;
import pixi.textures.Texture;
import pixi.primitives.Graphics;

/**
 * ...
 * @author Lucien Boudy
 */
class IsoMap extends DisplayObjectContainer
{
	public static var singleton: IsoMap;
	public static var cols_nb: Int;
	public static var rows_nb: Int;
	public static var cell_width: Int;
	public static var cell_height: Int;

	public var obstacles_layer: Array<Bool>;
	public var buildings_layer: Array<Int>;

	private var _graphics: Graphics;
	private var _screen_margin: Float;
	private var _screen_move_speed: Float;
	private var _old_x: Float;
	private var _old_y: Float;
	private var _offset_x: Int;
	private var _offset_y: Int;
	private var _cells_pts: Array<Dynamic<Int>>;
	private var _map_width: Int;
	private var _map_height: Int;
	private var _is_clicking: Bool;

/* ---------------------------------------------------------------------------------------- */

	public function new (pBG_url: String, pCols_nb: Int, pRows_nb: Int, pCell_width: Int, pCell_height: Int): Void 
	{
		super();

		singleton = this;

		_screen_margin = 0.05;
		_screen_move_speed = 0.5;
		_is_clicking = false;

		cols_nb = pCols_nb;
		rows_nb = pRows_nb;
		cell_width = pCell_width;
		cell_height = pCell_height;

		_map_width = cols_nb * cell_width;
		_map_height = rows_nb * cell_height;
		_offset_x = 0;
		_offset_y = 0;
		_cells_pts = IsoTools.all_map_pts_xy(_offset_x, _offset_y, cell_width, cell_height, cols_nb*rows_nb, cols_nb);
		
		x = _old_x = Std.int(DeviceCapabilities.width*0.5 - _map_width*0.5);
		y = _old_y = Std.int(DeviceCapabilities.height*0.5 - _map_height*0.5);

		obstacles_layer = new Array<Bool>();
		buildings_layer = new Array<Int>();

		addChild(new TilingSprite(Texture.fromImage(pBG_url), _map_width, _map_height));

		_graphics = new Graphics();
		_graphics.lineStyle(1, 0x88ccff, 1);
		addChild(_graphics);
		
		var i: Int = cols_nb * rows_nb;
		while (i-->0)
		{
			obstacles_layer[i] = false;
			buildings_layer[i] = 0;

			_graphics.moveTo(_cells_pts[i].x0, _cells_pts[i].y0);
			_graphics.lineTo(_cells_pts[i].x1, _cells_pts[i].y1);
			_graphics.lineTo(_cells_pts[i].x2, _cells_pts[i].y2);
			_graphics.lineTo(_cells_pts[i].x3, _cells_pts[i].y3);
			_graphics.lineTo(_cells_pts[i].x0, _cells_pts[i].y0);

			if (i/cols_nb - Std.int(i/cols_nb) == 0) // a row
			{
				addChild(new DisplayObjectContainer());
			}
		}

		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);
	}

	private function _update (): Void
	{

		if (!GameInfo.can_map_update)
		{
			return;
		}

		GameInfo.building_2_build = Building.CASINO | Building.LVL_1; // tmp here

		if (_is_clicking && !InputInfos.is_mouse_down)
		{
			_is_clicking = false;
			_on_click();
		}
		else if (!_is_clicking && InputInfos.is_mouse_down)
		{
			_old_x = x;
			_old_y = y;
			_is_clicking = true;
		}

		if (InputInfos.is_mouse_down)
		{
			x = InputInfos.mouse_x - (InputInfos.last_mouse_down_x-_old_x);
			y = InputInfos.mouse_y - (InputInfos.last_mouse_down_y-_old_y);
		}

		if (InputInfos.mouse_x < DeviceCapabilities.width*_screen_margin && x < 0) // left
		{
			x += Std.int((DeviceCapabilities.width*_screen_margin-InputInfos.mouse_x)*_screen_move_speed);
		}
		else if (InputInfos.mouse_x > DeviceCapabilities.width*(1-_screen_margin) && x > DeviceCapabilities.width-_map_width) // right
		{
			x += Std.int((DeviceCapabilities.width*(1-_screen_margin)-InputInfos.mouse_x)*_screen_move_speed);
		}

		if (InputInfos.mouse_y < DeviceCapabilities.height*_screen_margin && y < 0) // up
		{
			y += Std.int((DeviceCapabilities.height*_screen_margin-InputInfos.mouse_y)*_screen_move_speed);
		}
		else if (InputInfos.mouse_y > DeviceCapabilities.height*(1-_screen_margin) && y > DeviceCapabilities.height-_map_height) // down
		{
			y += Std.int((DeviceCapabilities.height*(1-_screen_margin)-InputInfos.mouse_y)*_screen_move_speed);
		}

	}

	private function _on_click (): Void
	{
		if (GameInfo.building_2_build > 0)
		{
			build_building(GameInfo.building_2_build , Std.int(InputInfos.mouse_x), Std.int(InputInfos.mouse_y));
			GameInfo.building_2_build = 0;
		}
	}

	// todo:
	// init/get obstacles_layer & buildings_layer function from string (from server)
	// position preview d'un building en tiles par rapport à la position de la souris
	// update obstacles_layer & buildings_layer from inputs (add / remove)
	// update offset x & y while drag & drop

	public function set_content (content: String): Void
	{

	}

	public function build_building (pBuilding_id: Int, pX: Int, pY: Int): Building
	{
		// todo: verifier l'obstacles_layer

		var index: Int = IsoTools.cell_index_from_xy(pX, pY, Std.int(this.x)+_offset_x, Std.int(this.y)+_offset_y, cell_width, cell_height, cols_nb);
		var col: Float = IsoTools.cell_col(index, cols_nb);
		var row: Float = IsoTools.cell_row(index, cols_nb);
		var new_x: Int = IsoTools.cell_x(col, cell_width, _offset_x);
		var new_y: Int = IsoTools.cell_y(row, cell_height, _offset_y);

		buildings_layer[index] = pBuilding_id;

		// todo: set the obstacles layer

		var building: Building = new Building(pBuilding_id, col, row, new_x, new_y);
		
		//trace("index: "+index);
		//trace("col: "+col);
		//trace("row: "+row);

		try
		{	// todo: trouver mieux comme technique...
			untyped getChildAt(Std.int(row)+2).addChild(building); // +1 pour le bg et +1 pour le graphics
		}
		catch (error: Dynamic)
		{
			trace(error);
		}

		return building;
	}

	public function destroy_building (pX: Int, pY: Int) : Void
	{
		
	}

}
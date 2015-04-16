package;

import utils.system.DeviceCapabilities;
import utils.events.Event;
import utils.game.IsoTools;
import utils.game.InputInfos;
import buildings.Building;
import buildings.PreviewBuilding;
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
	public static var cells_nb: Int;
	public static var cell_width: Int;
	public static var cell_height: Int;

	public var obstacles_layer: Array<Bool>;
	public var buildings_layer: Array<Int>;

	private var _graphics: Graphics;
	private var _screen_margin: Float;
	private var _screen_move_speed: Float;
	private var _screen_move_max_to_build: Int;
	private var _old_x: Float;
	private var _old_y: Float;
	private var _offset_x: Int;
	private var _offset_y: Int;
	private var _cells_pts: Array<Dynamic<Int>>;
	private var _map_width: Int;
	private var _map_height: Int;
	private var _is_clicking: Bool;
	private var _previewing_building: PreviewBuilding;

/* ---------------------------------------------------------------------------------------- */

	public function new (pBG_url: String, pCols_nb: Int, pRows_nb: Int, pCell_width: Int, pCell_height: Int): Void 
	{
		super();

		singleton = this;

		_screen_margin = 0.03;
		_screen_move_speed = 0.5;
		_screen_move_max_to_build = 64;
		_is_clicking = false;

		cols_nb = pCols_nb;
		rows_nb = pRows_nb;
		cells_nb = cols_nb * rows_nb;
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
		_graphics.lineStyle(1, 0x88CCFF, 1);
		addChild(_graphics);

		var i: Int = cells_nb;
		var test = 0;
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
				addChild(new DisplayObjectContainer());
			}
		}
		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);
	}

	public function build_building (pBuilding_type: Int, pX: Int, pY: Int): Building
	{
		var build_data = _get_building_coord(pBuilding_type, pX, pY);

		if (build_data == null || !build_data.can_build)
		{
			return null;
		}

		var building: Building = new Building(pBuilding_type, build_data.col, build_data.row, build_data.x, build_data.y);
		
		building.build();

		// set the obstacles layer :

		var building_map_idx: Array<Int> = Building.get_map_idx(build_data.index, building.width_in_tiles_nb, building.height_in_tiles_nb);
		var i: Int = building_map_idx.length;

		while (i-->0)
		{
			obstacles_layer[building_map_idx[i]] = true;
			buildings_layer[building_map_idx[i]] = pBuilding_type;
		}

		try
		{
			// on met le building dans le layer qui correspond à sa row
			untyped getChildAt(Std.int(build_data.row*2-building.height_in_tiles_nb)+3).addChild(building); // +1 pour le bg et +1 pour le graphics
		}
		catch (error: Dynamic)
		{
			trace(error);
		}

		return building;
	}

	public function destroy_building (pX: Int, pY: Int) : Void
	{
		// todo: reset obstacles_layer & buildings_layer
	}

	private function _update (): Void
	{
		if (!GameInfo.can_map_update)
		{
			_is_clicking = false; // pour le reset du click, si on est dans l'interface par exemple
			if (_previewing_building != null) // reset du preview s'il y en avait un (indecision)
			{
				removeChild(_previewing_building);
				_previewing_building = null; 
			}
			return;
		}

		if (_is_clicking && !InputInfos.is_mouse_down) // click relaché après avoir été appuyé
		{
			_is_clicking = false;
			_on_click();
		}
		else if (!_is_clicking && InputInfos.is_mouse_down) // click appuyé
		{
			_old_x = x;
			_old_y = y;
			_is_clicking = true;
		}

		if (InputInfos.is_mouse_down)
		{
			// déplacement sur la map au click
			x = InputInfos.mouse_x - (InputInfos.last_mouse_down_x-_old_x);
			x = x>0 ? 0 : x<DeviceCapabilities.width-_map_width ? DeviceCapabilities.width-_map_width : x;

			y = InputInfos.mouse_y - (InputInfos.last_mouse_down_y-_old_y);
			y = y>0 ? 0 : y<DeviceCapabilities.height-_map_height ? DeviceCapabilities.height-_map_height : y;
		}

		// déplacements de la map sur les bords de l'écran :
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

		_graphics.visible = GameInfo.building_2_build > 0;

		if (GameInfo.building_2_build > 0) // building preview
		{
			var build_data: Dynamic = _get_building_coord(GameInfo.building_2_build, InputInfos.mouse_x, InputInfos.mouse_y);

			if (build_data != null)
			{
				if (_previewing_building == null)
				{
					_previewing_building = new PreviewBuilding(GameInfo.building_2_build, build_data.x, build_data.y);
					addChild(_previewing_building);
				}

				if (!build_data.can_build && _previewing_building.tint == 0xFFFFFF)
				{
					_previewing_building.tint = PreviewBuilding.CANT_BUILD_COLOR;
				}
				else if (build_data.can_build && _previewing_building.tint != 0xFFFFFF)
				{
					_previewing_building.tint = 0xFFFFFF;
				}

				_previewing_building.set_position(build_data.x, build_data.y);
			}
		}
	}

	private function _on_click (): Void
	{
		if (GameInfo.building_2_build > 0
			&& Std.int(_old_x/_screen_move_max_to_build)==Std.int(x/_screen_move_max_to_build)
			&& Std.int(_old_y/_screen_move_max_to_build)==Std.int(y/_screen_move_max_to_build))
		{
			var new_building: Building = build_building(GameInfo.building_2_build, InputInfos.mouse_x, InputInfos.mouse_y);
			
			if (new_building != null)
			{
				GameInfo.building_2_build = 0;
				removeChild(_previewing_building);
				_previewing_building = null;
			}
		}
	}

	private function _get_building_coord (pBuilding_type: Int, pX: Int, pY: Int): Dynamic
	{
		var offset_x: Int = Std.int(this.x)+_offset_x;
		var offset_y: Int = Std.int(this.y)+_offset_y;
		
		if (!IsoTools.is_inside_map(pX, pY, offset_x, offset_y, cell_width, cell_height, cells_nb, cols_nb))
		{
			return null;
		}

		var index: Int = IsoTools.cell_index_from_xy(pX, pY, offset_x, offset_y, cell_width, cell_height, cols_nb);
		var col: Float = IsoTools.cell_col(index, cols_nb);
		var row: Float = IsoTools.cell_row(index, cols_nb);
		var new_x: Int = IsoTools.cell_x(col, cell_width, _offset_x);
		var new_y: Int = IsoTools.cell_y(row, cell_height, _offset_y);
		var can_build: Bool = true;

		// vérification de l'obstacles_layer :

		var conf = GameInfo.BUILDINGS_CONFIG[pBuilding_type|Building.LVL_1];
		var building_map_idx: Array<Int> = Building.get_map_idx(index, conf.width, conf.height);
		var i: Int = building_map_idx.length;

		while (can_build && i-->0)
		{
			if (obstacles_layer[building_map_idx[i]]) {
				can_build = false;
			}
		}

		return {
			index: index,
			col: col,
			row: row,
			x: new_x,
			y: new_y,
			can_build: can_build
		};
	}

}

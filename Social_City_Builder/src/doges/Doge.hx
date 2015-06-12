package doges;

import haxe.Timer;
import utils.system.DeviceCapabilities;
import utils.game.IsoTools;
import utils.game.InputInfos;
import pixi.display.MovieClip;
import pixi.display.Sprite;
import pixi.textures.Texture;
import pixi.textures.BaseTexture;

/**
 * ...
 * @author Lucien Boudy
 */
class Doge extends MovieClip
{
	public var col: Float;
	public var type: Int;
	public var map_origin_index: Int;
	public var map_target_index: Int;
// 	public var is_clickable: Bool;
// 	private var _can_click: Bool;


// /* ---------------------------------------------------------------------------------------- */

 	public function new (p_type: Int, p_index: Int, pX: Int, pY: Int): Void
 	{
// 		_cheat_ratio = 0.01; // pour construire + vite, parce que c'est long sinon !
		
// 		type = p_type;
// 		lvl = Building.LVL_1;
// 		map_origin_index = p_index;
// 		col = IsoTools.cell_col(map_origin_index, IsoMap.singleton.cols_nb);
// 		row = IsoTools.cell_row(map_origin_index, IsoMap.singleton.cols_nb);
// 		is_builded = true;
// 		is_clickable = true;
// 		is_focus = false;
// 		_can_click = false;

// 		width_in_tiles_nb = get_config().width;
// 		height_in_tiles_nb = get_config().height;

// 		super(_get_texture());
// 		anchor.set(0, 1); // botom left
// 		set_position(pX, pY);
// 		interactive = true;
// 		loop = true;
// 		animationSpeed = 0.333;
// 		_fading_speed = 0.8;
// 		outline_thick_min = 0.1;
// 		outline_thick_max = 7;
// 		outline_thick = 0;

// 		filter = new OutlineFilter(Std.int(texture.baseTexture.width), Std.int(texture.baseTexture.height), outline_thick, 0x00ff00);
// 		filters = [filter];

// 		all_map_index = get_map_idx(map_origin_index, width_in_tiles_nb, height_in_tiles_nb);

// 		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);
// 	}

// 	public function get_id (): Int
// 	{
// 		return type | lvl;
// 	}

// 	public function get_config (): Dynamic
// 	{
// 		return GameInfo.BUILDINGS_CONFIG[get_id()];
// 	}

// 	public function set_position (x: Int, y: Int): Void
// 	{
// 		x = Std.int(x-IsoMap.singleton.cell_width*(width_in_tiles_nb-1)*0.5);
// 		//y = Std.int(y+IsoMap.cell_height*(height_in_tiles_nb-(height_in_tiles_nb>>1))); // pour centrer par rapport au curseur
// 		y = y+IsoMap.singleton.cell_height;
		
// 		position.set(x, y);
// 	}

// 	public function build (): Void
// 	{
// 		is_builded = false;
// 		tint = 0;
// 		_building_start_time = Timer.stamp();
// 		building_end_time = _building_start_time + get_config().building_time * _cheat_ratio;
// 	}

// 	public function upgrade (): Void
// 	{
// 		if (lvl < Building.LVL_3)
// 		{
// 			GameInfo.buildingsGameplay[get_id()].userPossesion--;

// 			lvl += 0x100;
// 			textures = _get_texture();
// 			gotoAndStop(0);
// 			build();
// 		}
// 	}

// 	public function destroy (): Void 
// 	{
// 		Main.getInstance().removeEventListener(Event.GAME_LOOP, _update);
// 		filter = null;
// 		parent.removeChild(this);
// 	}

// 	public function outline_fade_in (): Void
// 	{
// 		outline_thick = Math.max(outline_thick_min, Math.min(outline_thick_max, outline_thick + Main.getInstance().delta_time * _fading_speed * outline_thick_max));
// 		filter.set_thickness(outline_thick);
// 	}

// 	public function outline_fade_out (): Void
// 	{
// 		outline_thick = 0;
// 		filter.set_thickness(0);
// 		// outline_thick = Math.max(0, outline_thick - Main.getInstance().delta_time * _fading_speed * outline_thick_max);
// 		// filter.set_thickness(outline_thick);
// 	}

// 	private function _update (): Void
// 	{
// 		if (!is_builded)
// 		{
// 			var color: Int = Std.int( (Timer.stamp() - _building_start_time) / (building_end_time-_building_start_time ) * 0x99 );

// 			tint = (color<<16) | (color<<8) | color; // 0x000000 -> 0x999999

// 			if (Timer.stamp() >= building_end_time)
// 			{
// 				GameInfo.buildingsGameplay[get_id()].userPossesion++;
// 				is_builded = true;
// 				tint = 0xFFFFFF;
// 				play();
// 			}
// 		}

// 		if (is_clickable)
// 		{
// 			alpha = Math.min(1, alpha + Main.getInstance().delta_time * _fading_speed);
// 		}
// 		else
// 		{
// 			alpha = Math.max(0.4, alpha - Main.getInstance().delta_time * _fading_speed);
// 		}

// 		if (is_focus)
// 		{
// 			if (_can_click && !InputInfos.is_mouse_down && IsoMap.singleton.clicked)
// 			{
// 				_can_click = false;
// 				_on_click();
// 			}
// 			else if (!_can_click && InputInfos.is_mouse_down)
// 			{
// 				_can_click = true;
// 			}
// 		}
// 		else
// 		{
// 			_can_click = false;
// 		}
// 	}
	
// 	private function _on_click (): Int
// 	{
// 		if (!is_builded || !is_clickable || !GameInfo.can_map_update)
// 		{
// 			return CLICK_VALUE.CANT_CLICK;
// 		}

// 		if (GameInfo.isUpgradeMode && GameInfo.ressources['fric'].userPossesion > 0)
// 		{
// 			GameInfo.ressources['fric'].userPossesion--;
// 			upgrade();

// 			return CLICK_VALUE.UPGRADE;
// 		}
// 		else if (GameInfo.isDestroyMode)
// 		{
// 			GameInfo.buildingsGameplay[get_id()].userPossesion--;

// 			IsoMap.singleton.destroy_building(this);

// 			return CLICK_VALUE.DESTROY;
// 		}

// 		return CLICK_VALUE.NOTHING;
// 	}

// 	private function _get_texture (): Array<Texture>
// 	{
// 		var textures: Array<Texture> = new Array<Texture>();
// 		var i: Int = get_config().frames_nb;

// 		while (i-->0)
// 		{
// 			textures.push(Texture.fromFrame(get_config().img + "_" + i + GameInfo.BUILDINGS_IMG_EXTENSION));
// 		}
// 		return textures;
// 	}

}

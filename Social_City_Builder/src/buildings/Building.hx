package buildings;

import haxe.Timer;
import utils.system.DeviceCapabilities;
import utils.events.Event;
import utils.game.IsoTools;
import utils.game.InputInfos;
import pixi.display.MovieClip;
import pixi.InteractionData;
import pixi.display.Sprite;
import pixi.textures.Texture;
import pixi.textures.BaseTexture;
import pixi.geom.Rectangle;

/**
 * ...
 * @author Lucien Boudy
 */
class Building extends MovieClip
{
	public static var CASINO 		: Int 	=	0x001;
	public static var EGLISE 		: Int 	=	0x002;
	public static var HANGAR_BLEU 	: Int 	=	0x003;
	public static var HANGAR_CYAN 	: Int 	=	0x004;
	public static var HANGAR_JAUNE 	: Int 	=	0x005;
	public static var HANGAR_ROUGE 	: Int 	=	0x006;
	public static var HANGAR_VERT 	: Int 	=	0x007;
	public static var HANGAR_VIOLET : Int 	=	0x008;
	public static var LABO 			: Int 	=	0x009;
	public static var NICHE 		: Int 	=	0x00A;
	public static var PAS_DE_TIR 	: Int 	=	0x00B;
	public static var ENTREPOT 		: Int 	=	0x00C;
	public static var MUSEE 		: Int 	=	0x00D;

	public static var LVL_1 		: Int 	= 	0x100;
	public static var LVL_2 		: Int 	= 	0x200;
	public static var LVL_3 		: Int 	=	0x300;
	
	public var all_map_index: Array<Int>;
	public var config: Dynamic;
	public var col: Float;
	public var row: Float;
	public var building_end_time: Float; // utile pour determiner les gains
	public var type: Int;
	public var lvl: Int;
	public var map_origin_index: Int;
	public var width_in_tiles_nb: Int; // en nombre de tiles
	public var height_in_tiles_nb: Int;
	public var building_time: Int;
	public var is_builded: Bool;
	public var is_clickable: Bool;

	private var _cheat_ratio: Float;
	private var _building_start_time: Float;
	private var _fading_speed: Float;

/* ---------------------------------------------------------------------------------------- */

	public static function get_building_type (id: Int): Int
	{
		return id & 0x0FF;
	}

	public static function get_building_lvl (id: Int): Int
	{
		return id & 0xF00;
	}
	
	public static function get_map_idx (pOrigin: Int, pWidth: Int, pHeight: Int) : Array<Int>
	{
		var map_idx: Array<Int> = [];
		var i: Int = pWidth * pHeight;

		while (i-->0)
		{
			map_idx[i] = pOrigin - (i % pWidth) - Std.int(i / pWidth) * IsoMap.cols_nb;
		}

		return map_idx;
	}

	public function new (p_type: Int, p_index: Int, pX: Int, pY: Int): Void
	{
		_cheat_ratio = 0.3; // pour construire + vite, parce que c'est long sinon !
		
		type = p_type;
		lvl = Building.LVL_1;
		map_origin_index = p_index;
		col = IsoTools.cell_col(map_origin_index, IsoMap.cols_nb);
		row = IsoTools.cell_row(map_origin_index, IsoMap.cols_nb);
		is_builded = true;
		is_clickable = true;

		width_in_tiles_nb = get_config().width;
		height_in_tiles_nb = get_config().height;

		super(_get_texture());
		anchor.set(0, 1);
		set_position(pX, pY);
		interactive = true;
		buttonMode = true;
		loop = true;
		animationSpeed = 0.333;
		_fading_speed = 0.8;

		all_map_index = get_map_idx(map_origin_index, width_in_tiles_nb, height_in_tiles_nb);

		click = _on_click;
		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);
	}

	public function get_id (): Int
	{
		return type | lvl;
	}

	public function get_config (): Dynamic
	{
		return GameInfo.BUILDINGS_CONFIG[get_id()];
	}

	public function set_position (x: Int, y: Int): Void
	{
		x = Std.int(x-IsoMap.cell_width*(width_in_tiles_nb-1)*0.5);
		//y = Std.int(y+IsoMap.cell_height*(height_in_tiles_nb-(height_in_tiles_nb>>1))); // pour centrer
		y = y+IsoMap.cell_height;
		
		position.set(x, y);
	}

	public function build (): Void
	{
		is_builded = false;
		tint = 0;
		_building_start_time = Timer.stamp();
		building_end_time = _building_start_time + get_config().building_time * _cheat_ratio;
	}

	public function upgrade (): Void
	{
		if (lvl < Building.LVL_3)
		{
			lvl += 0x100;
			textures = _get_texture();
			gotoAndStop(0);
			build();
		}
	}

	private function _update (): Void
	{
		if (!is_builded)
		{
			var color: Int = Std.int((Timer.stamp()-_building_start_time)/(building_end_time-_building_start_time)*0x99);

			tint = (color<<16) | (color<<8) | color; // 0x000000 -> 0x999999

			if (Timer.stamp() >= building_end_time)
			{
				is_builded = true;
				tint = 0xFFFFFF;
				play();
			}
		}

		if (is_clickable)
		{
			//alpha = 1;
			alpha = Math.min(1, alpha + Main.getInstance().delta_time * _fading_speed);
		}
		else
		{
			//alpha = 0.4;
			alpha = Math.max(0.4, alpha - Main.getInstance().delta_time * _fading_speed);
			//trace(Main.getInstance().delta_time * _fading_speed);
		}
	}
	
	private function _on_click (p_data: InteractionData): Void
	{
		if (!is_builded || !is_clickable || !GameInfo.can_map_update)
		{
			return;
		}

		if (GameInfo.is_building_context_pop_open)
		{
			popin.PopinManager.getInstance().closeContextPopin();
			GameInfo.is_building_context_pop_open = false;
		}
		else
		{
			popin.PopinManager.getInstance().openContextPopin(width*0.5/DeviceCapabilities.width, -height*0.5/DeviceCapabilities.height, this);
			GameInfo.is_building_context_pop_open = true;
		}
	}

	private function _get_texture (): Array<Texture>
	{
		var textures: Array<Texture> = new Array<Texture>();
		var i: Int = get_config().frames_nb;

		while (i-->0)
		{
			textures.push(Texture.fromFrame(get_config().img + "_" + i + GameInfo.BUILDINGS_IMG_EXTENSION));
		}
		return textures;
	}

}

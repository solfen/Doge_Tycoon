package buildings;

import haxe.Timer;
import utils.system.DeviceCapabilities;
import utils.events.Event;
import utils.game.IsoTools;
import utils.game.OutlineFilter;
import utils.game.InputInfos;
import pixi.display.MovieClip;
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
	public static inline var CASINO 		: Int 	=	0x001;
	public static inline var EGLISE 		: Int 	=	0x002;
	public static inline var HANGAR_BLEU 	: Int 	=	0x003;
	public static inline var HANGAR_CYAN 	: Int 	=	0x004;
	public static inline var HANGAR_JAUNE 	: Int 	=	0x005;
	public static inline var HANGAR_ROUGE 	: Int 	=	0x006;
	public static inline var HANGAR_VERT 	: Int 	=	0x007;
	public static inline var HANGAR_VIOLET 	: Int 	=	0x008;
	public static inline var LABO 			: Int 	=	0x009;
	public static inline var NICHE 			: Int 	=	0x00A;
	public static inline var PAS_DE_TIR 	: Int 	=	0x00B;
	public static inline var ENTREPOT 		: Int 	=	0x00C;
	public static inline var MUSEE 			: Int 	=	0x00D;

	public static inline var LVL_1 			: Int 	= 	0x100;
	public static inline var LVL_2 			: Int 	= 	0x200;
	public static inline var LVL_3 			: Int 	=	0x300;
	
	public static var CLICK_VALUE : Dynamic<Int> = {
		CANT_CLICK 	: 0,
		UPGRADE 	: 1,
		DESTROY 	: 2,
		NOTHING 	: 3,
		OTHER 		: 4
	};

	public var filter: OutlineFilter;
	public var all_map_index: Array<Int>;
	public var config: Dynamic;
	public var col: Float;
	public var row: Float;
	public var bdd_id: String;
	public var building_end_time: Float; // utile pour determiner les gains
	public var outline_thick: Float;
	public var outline_thick_min: Float;
	public var outline_thick_max: Float;
	public var type: Int;
	public var lvl: Int;
	public var map_origin_index: Int;
	public var width_in_tiles_nb: Int; // en nombre de tiles
	public var height_in_tiles_nb: Int;
	public var building_time: Int;
	public var is_builded: Bool;
	public var is_checking_with_server: Bool;
	public var is_clickable: Bool;
	public var is_focus: Bool;

	private var _cheat_ratio: Float;
	private var _building_start_time: Float;
	private var _fading_speed: Float;
	private var _can_click: Bool;

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
			map_idx[i] = pOrigin - (i % pWidth) - Std.int(i / pWidth) * IsoMap.singleton.cols_nb;
		}

		return map_idx;
	}

	public function new (p_type: Int, pBdd_id: String, p_index: Int, pX: Int, pY: Int, pIs_rebuild): Void
	{
		_cheat_ratio = 0.01; // pour construire + vite, parce que c'est long sinon !
		
		type = p_type;
		lvl = Building.LVL_1;
		map_origin_index = p_index;
		col = IsoTools.cell_col(map_origin_index, IsoMap.singleton.cols_nb);
		row = IsoTools.cell_row(map_origin_index, IsoMap.singleton.cols_nb);
		bdd_id = pBdd_id;
		is_builded = true;
		is_checking_with_server = false;
		is_clickable = true;
		is_focus = false;
		_can_click = false;

		width_in_tiles_nb = get_config().width;
		height_in_tiles_nb = get_config().height;

		super(_get_texture());
		anchor.set(0, 1); // botom left
		set_position(pX, pY);
		interactive = true;
		loop = true;
		animationSpeed = 0.333;
		_fading_speed = 0.8;
		outline_thick_min = 0.1;
		outline_thick_max = 7;
		outline_thick = 0;

		filter = new OutlineFilter(Std.int(texture.baseTexture.width), Std.int(texture.baseTexture.height), outline_thick, 0x00ff00);
		filters = [filter];

		all_map_index = get_map_idx(map_origin_index, width_in_tiles_nb, height_in_tiles_nb);

		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);

		if (p_index != -1 && !pIs_rebuild) 
		{
			var params: Map<String,String> = 
			[
				"event_name" => 'build_building',
				"building_builded_id" => bdd_id,
				"building_id" => (type | lvl) + '',
				"col" => col + '',
				"row" => row + ''
			];
			utils.server.MyAjax.call("data.php", params, function(){} );
		}
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
		x = Std.int(x-IsoMap.singleton.cell_width*(width_in_tiles_nb-1)*0.5);
		//y = Std.int(y+IsoMap.cell_height*(height_in_tiles_nb-(height_in_tiles_nb>>1))); // pour centrer par rapport au curseur
		y = y+IsoMap.singleton.cell_height;
		
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
			var params: Map<String,String> = 
			[
				"event_name" => 'upgrade_building',
				"building_builded_id" => bdd_id,
				"building_id" => (type | (lvl + 0x100)) + '',
			];
			utils.server.MyAjax.call("data.php", params, _finish_upgrade );
		}
	}

	private function _finish_upgrade (data:String) : Void 
	{
		if(data == "1") 
		{
			GameInfo.buildingsGameplay[get_id()].userPossesion--;

			lvl += 0x100;
			textures = _get_texture();
			gotoAndStop(0);
			build();
		}
	}

	public function destroy (): Void 
	{
		Main.getInstance().removeEventListener(Event.GAME_LOOP, _update);
		filter = null;
		parent.removeChild(this);
	}

	public function outline_fade_in (): Void
	{
		if (is_builded)
		{
			outline_thick = Math.max(outline_thick_min, Math.min(outline_thick_max, outline_thick + Main.getInstance().delta_time * _fading_speed * outline_thick_max));
			filter.set_thickness(outline_thick);
		}
	}

	public function outline_fade_out (): Void
	{
		outline_thick = 0;
		filter.set_thickness(0);
		// outline_thick = Math.max(0, outline_thick - Main.getInstance().delta_time * _fading_speed * outline_thick_max);
		// filter.set_thickness(outline_thick);
	}

	private function _build_end (data: String): Void 
	{
		if(GameInfo.buildingsToLoad > GameInfo.buildingsLoaded) {
			GameInfo.buildingsLoaded++;
		}
		
		if (data.charAt(0) == '1')
		{
			GameInfo.buildingsGameplay[get_id()].userPossesion++;
			is_builded = true;
			tint = 0xFFFFFF;
			play();
			is_checking_with_server = false;
		}
		else if (data.charAt(0) == '{') 
		{
			building_end_time = Std.int(haxe.Json.parse(data).durationLeft) + Timer.stamp();
			is_checking_with_server = false;
		}
	}

	private function _update (): Void
	{
		if (!is_builded && !is_checking_with_server)
		{
			var color: Int = Std.int( (Timer.stamp() - _building_start_time) / (building_end_time - _building_start_time ) * 0x99);

			tint = (color<<16) | (color<<8) | color; // 0x000000 -> 0x999999

			if (Timer.stamp() >= building_end_time)
			{
				is_checking_with_server = true;

				var params: Map<String,String> = [
					"event_name" => 'check_building_end',
					"building_builded_id" => bdd_id,
				];
				utils.server.MyAjax.call("data.php", params, _build_end);
			}
		}

		if (is_clickable)
		{
			alpha = Math.min(1, alpha + Main.getInstance().delta_time * _fading_speed);
		}
		else
		{
			alpha = Math.max(0.4, alpha - Main.getInstance().delta_time * _fading_speed);
		}

		if (is_focus)
		{
			if (_can_click && !InputInfos.is_mouse_down && IsoMap.singleton.clicked)
			{
				_can_click = false;
				_on_click();
			}
			else if (!_can_click && InputInfos.is_mouse_down)
			{
				_can_click = true;
			}
		}
		else
		{
			_can_click = false;
		}
	}
	
	private function _on_click (): Int
	{
		if (!is_builded || !is_clickable || !GameInfo.can_map_update)
		{
			return CLICK_VALUE.CANT_CLICK;
		}

		if (GameInfo.isUpgradeMode && GameInfo.ressources['fric'].userPossesion > 0)
		{
			GameInfo.ressources['fric'].userPossesion--;
			upgrade();

			return CLICK_VALUE.UPGRADE;
		}
		else if (GameInfo.isDestroyMode)
		{
			var params: Map<String,String> = 
			[
				"event_name" => 'destroy_building',
				"building_builded_id" => bdd_id,
			];
			utils.server.MyAjax.call("data.php", params, function(){} );

			GameInfo.buildingsGameplay[get_id()].userPossesion--;

			IsoMap.singleton.destroy_building(this);

			return CLICK_VALUE.DESTROY;
		}

		return CLICK_VALUE.NOTHING;
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

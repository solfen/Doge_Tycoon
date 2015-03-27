package buildings;

import haxe.Timer;
import utils.system.DeviceCapabilities;
import utils.events.Event;
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
	public static var CASINO 		: Int 	=	0x01;
	public static var EGLISE 		: Int 	=	0x02;
	public static var HANGAR_BLEU 	: Int 	=	0x03;
	public static var HANGAR_CYAN 	: Int 	=	0x04;
	public static var HANGAR_JAUNE 	: Int 	=	0x05;
	public static var HANGAR_ROUGE 	: Int 	=	0x06;
	public static var HANGAR_VERT 	: Int 	=	0x07;
	public static var HANGAR_VIOLET : Int 	=	0x08;
	public static var LABO 			: Int 	=	0x09;
	public static var NICHE 		: Int 	=	0x0A;
	public static var PAS_DE_TIR 	: Int 	=	0x0B;
	public static var ENTREPOT 		: Int 	=	0x0C;
	public static var MUSEE 		: Int 	=	0x0D;

	public static var LVL_1 		: Int 	= 	0x100;
	public static var LVL_2 		: Int 	= 	0x200;
	public static var LVL_3 		: Int 	=	0x300;
	
	public var type: Int;
	public var lvl: Int;
	public var col: Float;
	public var row: Float;
	public var width_in_tiles_nb: Int; // en nombre de tiles
	public var height_in_tiles_nb: Int;
	public var building_time: Int;
	public var is_builded: Bool;
	public var config: Dynamic;

	private var _building_start_time: Float;
	private var _building_end_time: Float;

/* ---------------------------------------------------------------------------------------- */

	public static function get_building_type (id: Int): Int
	{
		return id&0xFF;
	}

	public static function get_building_lvl (id: Int): Int
	{
		return id&0xF00;
	}
	
	public function new (p_type: Int, p_col: Float, p_row: Float, pX: Int, pY: Int): Void
	{
		type = p_type;
		lvl = Building.LVL_1;
		col = p_col;
		row = p_row;
		is_builded = true;

		width_in_tiles_nb = get_config().width;
		height_in_tiles_nb = get_config().height;

		super(_get_texture());
		anchor.set(0, 1);
		set_position(pX, pY);
		interactive = true;
		buttonMode = true;
		loop = true;
		animationSpeed = 0.333;
		click = _on_click;
		Main.getInstance().addEventListener(Event.GAME_LOOP, _update);
	}

	public function get_id (): Int
	{
		return type|lvl;
	}

	public function get_config (): Dynamic
	{
		return GameInfo.BUILDINGS_CONFIG[get_id()];
	}

	public function set_position (x: Int, y: Int): Void
	{
		x = Std.int(x-IsoMap.cell_width*(width_in_tiles_nb-1)*0.5);
		//y = Std.int(y+IsoMap.cell_height*(height_in_tiles_nb-(height_in_tiles_nb>>1)));
		y = y+IsoMap.cell_height;
		
		position.set(x, y);
	}

	public function build (): Void
	{
		is_builded = false;
		tint = 0x000000;
		_building_start_time = Timer.stamp();
		_building_end_time = _building_start_time + get_config().building_time;
	}

	public function upgrade () {
		
		if (lvl < Building.LVL_3)
		{
			lvl = 0x100;
			textures = _get_texture();
			build();
		}
	}

	private function _update ()
	{
		if (!is_builded) {
			
			var color: Int = Std.int((Timer.stamp()-_building_start_time)/(_building_end_time-_building_start_time)*0x99);

			tint = (color<<16)|(color<<8)|color; // 0x000000 -> 0x999999

			if (Timer.stamp() >= _building_end_time) {
				is_builded = true;
				tint = 0xFFFFFF;
				play();
			}
		}
	}
	
	private function _on_click (p_data: InteractionData): Void
	{
		if (!is_builded || !GameInfo.can_map_update)
		{
			return;
		}

		trace('click on building '+get_id());
		// dispatch an event here?
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

package buildings;

import utils.system.DeviceCapabilities;
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

	public static function get_building_type (id: Int): Int
	{
		return id&0xFF;
	}

	public static function get_building_lvl (id: Int): Int
	{
		return id&0xF00;
	}
	
	public var type: Int;
	public var lvl: Int;
	public var col: Float;
	public var row: Float;
	public var width_in_tiles_nb: Int; // en nombre de tiles
	public var height_in_tiles_nb: Int;
	public var building_time: Int;
	public var is_builded: Bool;
	public var config: Dynamic;

	public function upgrade () {
		
		lvl += 0x100;
	}
	
	public function new (p_type: Int, p_col: Float, p_row: Float, pX: Int, pY: Int): Void
	{
		type = p_type;
		lvl = Building.LVL_1;
		col = p_col;
		row = p_row;
		is_builded = false;
		config = GameInfo.BUILDINGS_CONFIG[get_id()];

		width_in_tiles_nb = config.width;
		height_in_tiles_nb = config.height;

		super(_get_texture());
		anchor.set(0, 1);
		pX = Std.int(pX-IsoMap.cell_width*Std.int(width_in_tiles_nb*0.5));
		pY = Std.int(pY+IsoMap.cell_height*Std.int(height_in_tiles_nb*0.5+1));
		position.set(pX, pY);
		interactive = true;
		buttonMode = true;
		loop = true;
		animationSpeed = 0.333;
		play();
		click = _on_click;
	}

	public function get_id (): Int
	{
		return type|lvl;
	}

	public function get_bloking_tiles (): Array<Bool>
	{
		var bloking_tiles: Array<Bool> = [];
		var i: Int = width_in_tiles_nb * height_in_tiles_nb; // use a static here
		
		while (i-->0)
		{
			bloking_tiles[i] = false;
		}

		return bloking_tiles;
	}
	
	private function _on_click (p_data: InteractionData): Void
	{
		trace('click on building '+get_id());
		// dispatch an event here?
	}

	/**
	 * Tableau de textures de l'ambulance
	 * @return le tableau de textures
	 */
	private function _get_texture (): Array<Texture>
	{
		var textures: Array<Texture> = new Array<Texture>();
		
		/*if (config.frames_nb == 1)
		{
			textures.push(Texture.fromFrame(GameInfo.BUILDINGS_IMG_FOLDER_PATH + config.img + GameInfo.BUILDINGS_IMG_EXTENSION));
		}
		else
		{*/
			var i: Int = config.frames_nb;

			while (i-->0)
			//while (--i>0) // pour index 1
			{
				textures.push(Texture.fromFrame(config.img + "_" + i + GameInfo.BUILDINGS_IMG_EXTENSION));
			}
		//}
		return textures;
	}
	
}
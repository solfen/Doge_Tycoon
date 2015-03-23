package sprites;

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
	public static var HANGAR_1 		: Int 	=	0x03;
	public static var HANGAR_2 		: Int 	=	0x04;
	public static var HANGAR_3 		: Int 	=	0x05;
	public static var HANGAR_4 		: Int 	=	0x06;
	public static var HANGAR_5 		: Int 	=	0x07;
	public static var HANGAR_6 		: Int 	=	0x08;
	public static var LABO 			: Int 	=	0x09;
	public static var NICHE 		: Int 	=	0x0a;
	public static var PAS_DE_TIR 	: Int 	=	0x0b;

	public static var LVL_1 		: Int 	= 	0x100;
	public static var LVL_2 		: Int 	= 	0x200;
	public static var LVL_3 		: Int 	=	0x300;

	public static function get_building_type (id: Int): Int
	{
		return id&0xff;
	}

	public static function get_building_lvl (id: Int): Int
	{
		return id&0xf00;
	}
	
	public var type: Int;
	public var lvl: Int;
	public var col: Float;
	public var row: Float;
	public var width_in_tiles_nb: Int; // en nombre de tiles
	public var height_in_tiles_nb: Int;
	public var building_time: Int;
	public var config: Dynamic;

	public function upgrade () {
		
		lvl += 0x100;
	}
	
	
	public function new (p_type: Int, p_col: Float, p_row: Float, pX: Int, pY: Int): Void
	{
		type = p_type;
		lvl = 1;
		col = p_col;
		row = p_row;

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
	
	private function _on_click (p_data: InteractionData): Void
	{
		trace('click on building '+get_id());
		// dispatch event here?
	}

	/**
	 * Tableau de textures de l'ambulance
	 * @return le tableau de textures
	 */
	private function _get_texture (): Array<Texture>
	{
		var textures: Array<Texture> = new Array<Texture>();
		
		if (config.frames_nb == 1)
		{
			textures.push(Texture.fromFrame(GameInfo.BUILDINGS_IMG_FOLDER_PATH + config.img + GameInfo.BUILDINGS_IMG_EXTENSION));
		}
		else
		{
			var i: Int = config.frames_nb;

			while (i-->0) // modif la config pour indexer à 0 plutôt
			{
				textures.push(Texture.fromFrame(config.img + "_" + i + GameInfo.BUILDINGS_IMG_EXTENSION));
			}
		}
		return textures;
	}
	
}
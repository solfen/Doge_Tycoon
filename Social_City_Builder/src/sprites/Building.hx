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

	public static var IMG_FOLDER_PATH: String = "assets/Buildings/";
	public static var IMG_EXTENSION: String = ".png";

	public static var BUILDINGS_IMG: Array<String> = [
		"CasinoLv1",
		"CasinoLv2",
		"CasinoLv3",
		"EgliseLv1",
		"EgliseLv2",
		"EgliseLv3",
		"Hangar1Lv1",
		"Hangar1Lv2",
		"Hangar1Lv3",
		"Hangar2Lv1",
		"Hangar2Lv2",
		"Hangar2Lv3",
		"Hangar3Lv1",
		"Hangar3Lv2",
		"Hangar3Lv3",
		"Hangar4Lv1",
		"Hangar4Lv2",
		"Hangar4Lv3",
		"Hangar5Lv1",
		"Hangar5Lv2",
		"Hangar5Lv3",
		"Hangar6Lv1",
		"Hangar6Lv2",
		"Hangar6Lv3",
		"Labo1",
		"Labo2",
		"Labo3",
		"NicheLv1",
		"NicheLv2",
		"NicheLv3",
		"PasDeTir1",
		"PasDeTir2",
		"PasDeTir3"
	];
	public static var BUILDINGS_CONFIG: Array<Dynamic<Int>> = GET_BUILDINGS_CONFIG();

	public static inline function GET_BUILDINGS_CONFIG () : Array<Dynamic<Int>>
	{
		var config: Array<Dynamic<Int>> = [];

		config[ CASINO | LVL_1 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 0 }; // + (buildingTime -> à récup sur le serveur)
		config[ CASINO | LVL_2 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 1 };
		config[ CASINO | LVL_3 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 2 };
		config[ EGLISE | LVL_1 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 3 };
		config[ EGLISE | LVL_2 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 4 };
		config[ EGLISE | LVL_3 ] = 		{ width: 3, height: 3, vertical_dir: 0, img_i: 5 };
		config[ HANGAR_1 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 6 };
		config[ HANGAR_1 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 7 };
		config[ HANGAR_1 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 8 };
		config[ HANGAR_2 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 9 };
		config[ HANGAR_2 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 10 };
		config[ HANGAR_2 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 11 };
		config[ HANGAR_3 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 12 };
		config[ HANGAR_3 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 13 };
		config[ HANGAR_3 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 14 };
		config[ HANGAR_4 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 15 };
		config[ HANGAR_4 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 16 };
		config[ HANGAR_4 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 17 };
		config[ HANGAR_5 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 18 };
		config[ HANGAR_5 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 19 };
		config[ HANGAR_5 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 20 };
		config[ HANGAR_6 | LVL_1 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 21 };
		config[ HANGAR_6 | LVL_2 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 22 };
		config[ HANGAR_6 | LVL_3 ] = 	{ width: 3, height: 2, vertical_dir: -1, img_i: 23 };
		config[ LABO | LVL_1 ] = 		{ width: 2, height: 2, vertical_dir: 0, img_i: 24 };
		config[ LABO | LVL_2 ] = 		{ width: 2, height: 2, vertical_dir: 0, img_i: 25 };
		config[ LABO | LVL_3 ] = 		{ width: 3, height: 2, vertical_dir: 1, img_i: 26 };
		config[ NICHE | LVL_1 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 27 };
		config[ NICHE | LVL_2 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 28 };
		config[ NICHE | LVL_3 ] = 		{ width: 1, height: 1, vertical_dir: 0, img_i: 29 };
		config[ PAS_DE_TIR | LVL_1 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 30 };
		config[ PAS_DE_TIR | LVL_2 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 31 };
		config[ PAS_DE_TIR | LVL_3 ] = 	{ width: 5, height: 3, vertical_dir: 0, img_i: 32 };

		return config;
	}

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
	public var config: Dynamic<Int>;

	//private images // ou fonction par lvl ?

	public function upgrade () {
		
	}
	
	
	public function new (p_type: Int, p_col: Float, p_row: Float, pX: Int, pY: Int): Void
	{
		type = p_type;
		lvl = 1;
		col = p_col;
		row = p_row;

		config = GameInfo.BUILDINGS_CONFIG[get_id()];
		width_in_tiles_nb = Std.int(config.width);
		height_in_tiles_nb = Std.int(config.height);

		super(_get_texture());
		anchor.set(0, 1);
		pX = Std.int(pX-IsoMap.cell_width*Std.int(width_in_tiles_nb*0.5));
		pY = Std.int(pY+IsoMap.cell_height*Std.int(height_in_tiles_nb*0.5+1));
		position.set(pX, pY);
		interactive = true;
		buttonMode = true;
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
		
		if (Std.int(config.frames_nb) == 1)
		{

		}
		else
		{
			var i: Int = Std.int(config.frames_nb);
			
		}
		//for (i in 0...BUILDINGS_IMG[config.img_i])
		//{
			textures.push(Texture.fromFrame(IMG_FOLDER_PATH + BUILDINGS_IMG[config.img_i] + IMG_EXTENSION));
		//}
		return textures;
	}
	
}
package utils.game;

/**
 * ...
 * @author Lucien BOUDY
 */
class IsoTools
{
	public static function cell_col (cell_index: Int, cols_nb: Int) : Float
	{
		return (cell_index % cols_nb - Std.int(cell_index / cols_nb) + cols_nb - 1) * 0.5;
	}

	public static function cell_row (cell_index: Int, cols_nb: Int) : Float
	{
		return (cell_index % cols_nb + Std.int(cell_index / cols_nb)) * 0.5;
	}

	public static function cell_x (col: Float, cell_w: Int, offset_x: Int) : Int
	{
		return Std.int(col * cell_w + offset_x);
	}

	public static function cell_y (row: Float, cell_h: Int, offset_y: Int) : Int
	{
		return Std.int(row * cell_h + offset_y);
	}

	public static function cell_index_from_cr (col: Float, row: Float, cols_nb: Int) : Int
	{
		return Std.int(row + col - cols_nb * 0.5 + 0.5) + Std.int(row - col + cols_nb * 0.5 - 0.5) * cols_nb;
	}

	public static function cell_index_from_xy (x: Int, y: Int, offset_x: Int, offset_y: Int, cell_w: Int, cell_h: Int, cols_nb: Int) : Int
	{
		var nX: Float = (x - offset_x) / cell_w;
		var nY: Float = (y - offset_y) / cell_h;

		return Std.int(nY + nX - cols_nb * 0.5) + Std.int(nY - nX + cols_nb * 0.5) * cols_nb;
	}

	public static function is_inside_map (x: Int, y: Int, offset_x: Int, offset_y: Int, cell_w: Int, cell_h: Int, cells_nb: Int, cols_nb: Int): Bool
	{
		// left
		var p0_x: Int = Std.int(offset_x+cell_col(cells_nb-cols_nb,cols_nb)*cell_w);
		var p0_y: Int = Std.int(offset_y+cell_row(cells_nb-cols_nb,cols_nb)*cell_h + cell_h*0.5);
		// top
		var p1_x: Int = Std.int(offset_x+cell_col(0,cols_nb)*cell_w + cell_w*0.5);
		var p1_y: Int = Std.int(offset_y+cell_row(0,cols_nb)*cell_h);
		// right
		var p2_x: Int = Std.int(offset_x+cell_col(cols_nb-1,cols_nb)*cell_w + cell_w);
		var p2_y: Int = Std.int(offset_y+cell_row(cols_nb-1,cols_nb)*cell_h + cell_h*0.5);
		// bot
		var p3_x: Int = Std.int(offset_x+cell_col(cells_nb-1,cols_nb)*cell_w + cell_w*0.5);
		var p3_y: Int = Std.int(offset_y+cell_row(cells_nb-1,cols_nb)*cell_h+cell_h);

		return ((p1_x-p0_x)*(y-p0_y)-(p1_y-p0_y)*(x-p0_x))>0
			&& ((p2_x-p1_x)*(y-p1_y)-(p2_y-p1_y)*(x-p1_x))>0 
			&& ((p3_x-p2_x)*(y-p2_y)-(p3_y-p2_y)*(x-p2_x))>0 
			&& ((p0_x-p3_x)*(y-p3_y)-(p0_y-p3_y)*(x-p3_x))>0;
	}

	public static function all_map_pts_xy (offset_x: Int, offset_y: Int, cell_w: Int, cell_h: Int, cells_nb: Int, cols_nb: Int) : Array<Dynamic<Int>>
	{
		var pts: Array<Dynamic<Int>> = [];
		var i: Int = 0;
		
		while (i < cells_nb)
		{
			// left
			pts[i] = {
				x0: Std.int(offset_x+cell_col(i,cols_nb)*cell_w),
				y0: Std.int(offset_y+cell_row(i,cols_nb)*cell_h+cell_h*0.5)
			};
			// top
			pts[i].x1 = Std.int(pts[i].x0 + cell_w*0.5);
			pts[i].y1 = Std.int(pts[i].y0 - cell_h*0.5);
			// right
			pts[i].x2 = pts[i].x0 + cell_w;
			pts[i].y2 = pts[i].y0;
			// bot
			pts[i].x3 = pts[i].x1;
			pts[i].y3 = Std.int(pts[i].y0 + cell_h * 0.5);
			
			i++;
		}

		return pts;
	}
}

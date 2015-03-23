function Iso (stdlib, foreign, buffer) {
	"use asm";

	//var data = new stdlib.Float32Array(buffer); // [col,row] && [x,y] arrays

	function cell_col (cell_index, cols_nb) {

		return (cell_index%cols_nb-(cell_index/cols_nb|0)+cols_nb-1) / 2;
	}

	function cell_row (cell_index, cols_nb) {

		return (cell_index%cols_nb+(cell_index/cols_nb|0)) / 2;
	}

	function  cell_x (col, cell_w, offset_x) {

		return col*cell_w + offset_x;
	}

	function  cell_y (row, cell_h, offset_y) {

		return row*cell_h + offset_y;
	}

	function cell_index_from_cr (col, row, cols_nb) {

		return (row+col-cols_nb/2+0.5|0) + (row-col+cols_nb/2-0.5|0) * cols_nb;
	}

	function cell_index_from_xy (x, y, offset_x, offset_y, cell_w, cell_h, cols_nb) {

		x = (x-offset_x) / cell_w;
		y = (y-offset_y) / cell_h;

		return (y+x-cols_nb/2|0) + (y-x+cols_nb/2|0) * cols_nb;
	}

	function is_inside_map (x, y, offset_x, offset_y, cell_w, cell_h, cells_nb, cols_nb) {

		// left
		var p0_x = offset_x+cell_col(cells_nb-cols_nb,cols_nb)*cell_w;
		var p0_y = offset_y+cell_row(cells_nb-cols_nb,cols_nb)*cell_h + cell_h*0.5;
		// top
		var p1_x = offset_x+cell_col(0,cols_nb)*cell_w + cell_w*0.5;
		var p1_y = offset_y+cell_row(0,cols_nb)*cell_h;
		// right
		var p2_x = offset_x+cell_col(cols_nb-1,cols_nb)*cell_w + cell_w;
		var p2_y = offset_y+cell_row(cols_nb-1,cols_nb)*cell_h + cell_h*0.5;
		// bot
		var p3_x = offset_x+cell_col(cells_nb-1,cols_nb)*cell_w + cell_w*0.5;
		var p3_y = offset_y+cell_row(cells_nb-1,cols_nb)*cell_h+cell_h;

		return ((p1_x-p0_x)*(y-p0_y)-(p1_y-p0_y)*(x-p0_x))>0
			&& ((p2_x-p1_x)*(y-p1_y)-(p2_y-p1_y)*(x-p1_x))>0 
			&& ((p3_x-p2_x)*(y-p2_y)-(p3_y-p2_y)*(x-p2_x))>0 
			&& ((p0_x-p3_x)*(y-p3_y)-(p0_y-p3_y)*(x-p3_x))>0;
	}

	function all_map_pts_xy (offset_x, offset_y, cell_w, cell_h, cells_nb, cols_nb) { // i.e.: to debug

		var pts = [];

		for (var i=0; i<cells_nb; i++) {

			pts[i] = {
				x0: offset_x+cell_col(i,cols_nb)*cell_w,
				y0: offset_y+cell_row(i,cols_nb)*cell_h+cell_h*0.5
			};

			pts[i].x1 = pts[i].x0 + cell_w*0.5;
			pts[i].y1 = pts[i].y0 - cell_h*0.5;

			pts[i].x2 = pts[i].x0 + cell_w;
			pts[i].y2 = pts[i].y0;

			pts[i].x3 = pts[i].x1;
			pts[i].y3 = pts[i].y0 + cell_h*0.5;
		}

		return pts;
	}

	return {
		cell_col: cell_col,
		cell_row: cell_row,
		cell_x: cell_x,
		cell_y: cell_y,
		cell_index_from_cr: cell_index_from_cr,
		cell_index_from_xy: cell_index_from_xy,
		is_inside_map: is_inside_map,
		all_map_pts_xy: all_map_pts_xy
	};
}

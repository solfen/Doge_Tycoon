function Iso (stdlib, foreign, buffer) {
	"use asm";

	//var data = new stdlib.Float32Array(buffer); // [col,row] && [x,y] arrays

	function cell_col (cell_index, cols_nb) {

		return (cell_index%cols_nb-(cell_index/cols_nb|0)+cols_nb-1) / 2;
	}

	function cell_row (cell_index, cols_nb) {

		return (cell_index%cols_nb+(cell_index/cols_nb|0)) / 4;
	}

	function  cell_x (col, cell_w, offset_x) {

		return col*cell_w + offset_x;
	}

	function  cell_y (row, cell_h, offset_y) {

		return row*cell_h + offset_y;
	}

	function cell_index_from_cr (col, row, cols_nb) {

		return (col+row*2-cols_nb/2+0.5|0) + (row*2-col+(cols_nb-1)/2|0) * cols_nb;
	}

	function cell_index_from_xy (x, y, offset_x, offset_y, cell_w, cell_h, cols_nb) {

		x = (x-offset_x) / cell_w;
		y = (y-offset_y) / cell_h;

		return cell_index_from_cr(x, y, cols_nb)-1;
	}

	function all_map_pts_xy (offset_x, offset_y, cell_w, cell_h, cells_nb, cols_nb) { // to debug for example

		var pts = [];

		for (var i=0; i<cells_nb; i++) {

			pts[i] = {
				x0: offset_x+cell_col(i,cols_nb)*cell_w,
				y0: offset_y+cell_row(i,cols_nb)*cell_h+cell_h*0.5
			};

			pts[i].x1 = pts[i].x0 + cell_w*0.5;
			pts[i].y1 = pts[i].y0 - cell_h*0.25;

			pts[i].x2 = pts[i].x0 + cell_w;
			pts[i].y2 = pts[i].y0;

			pts[i].x3 = pts[i].x1;
			pts[i].y3 = pts[i].y0 + cell_h*0.25;
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
		all_map_pts_xy: all_map_pts_xy
	};
}

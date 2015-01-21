function Iso (stdlib, foreign, buffer) {
	"use asm";

	//var data = new stdlib.Float32Array(buffer); // [col,row] && [x,y] arrays

/*
		(i%cols_nb-(i/cols_nb|0))/2 + (cols_nb-1)/2 = nX = col
		(i%cols_nb+(i/cols_nb|0))/4 = nY = row
*/

	/*function init (cols_nb, rows_nb) {


	}

	function get_col (i) {

	}*/

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
/*
		// var I = x + y*cols_nb;

		var tmp_y = nY*2 - nX + (cols_nb-1)/2;
		var I = (nY*4-y) + y*cols_nb;
*/
/*
			var x = i%cols_nb;
			var y = i/cols_nb|0;

			var nX = (x-y)/2 + (cols_nb-1)/2;
			var nY = (x+y)/4;
			
			nX = (x-y)/2 + (cols_nb-1)/2
			nX - (cols_nb-1)/2 = (x-y)/2
			(x-y)/2 = nX - (cols_nb-1)/2
			x-y = nX*2 - cols_nb-1
			x = nX*2 - cols_nb - 1 + y


			0 = (x-y)/2 - (cols_nb-1)/2 - nX
			-(x-y)/2 = -(cols_nb-1)/2 - nX
			(x-y)/2 = (cols_nb-1)/2 + nX
			x-y = cols_nb-1 + nX*2
			x = cols_nb-1 + nX*2 + y
			-----------------------------
			(x-y)/2 + (cols_nb-1)/2 = col;
			(x+y)/4 = row;

			x-y = col*2 - cols_nb - 1;
			x+y = row*4;

			-y = col*2 - cols_nb - 1 - x;
			y = row*4-x;

			y = cols_nb + 1 + x - col*2;
			y = row*4-x;

			0 = cols_nb + 1 + x - col*2 - row*4 + x;
			0 = cols_nb + 1 + x*2 - col*2 - row*4;
			-x*2 = cols_nb + 1 - col*2 - row*4;
			x*2 = col*2 + row*4 - cols_nb - 1;
			x = col + row*2 - cols_nb/2 - 0.5;

			-----------------------------
			nY = (x+y)/4
			0 = (x+y)/4-nY
			-(x+y)/4 = -nY
			(x+y)/4 = nY
			x+y = nY*4
			x = nY*4-y

*/
		var y = row*2 - col + (cols_nb-1)/2 | 0;

		//console.log('nX:', row*4-y|0);
		//console.log('nX2:', cols_nb-1+col*2+y);
		//console.log('nX3:', (col*2)+y-cols_nb+1);
		//console.log('nX4:', col*2 - cols_nb - 1 + y|0);
//		console.log('nX5:', col + row*2 - cols_nb/2 - 0.5);
		//console.log('nY:', y);

		//return (row*4-y|0) + y*cols_nb;
		return (col + row*2 - cols_nb/2 + 0.5|0) + y*cols_nb;
	}

	function cell_index_from_xy (x, y, offset_x, offset_y, cell_w, cell_h, cols_nb) {

/*
		x = col*cell_w + offset_x
		y = row*cell_h + offset_y

		col = (x-offset_x) / cell_w
		row = (y-offset_y) / cell_h
*/

	/*
	(i%cols_nb-(i/cols_nb|0))/2 + (cols_nb-1)/2 = nX = col
	(i%cols_nb+(i/cols_nb|0))/4 = nY = row
	*/

	//var c = ((x-offset_x)/(cell_w/2) + (y-offset_y)/(cell_h/2)) / 2 - (cols_nb-1)/2 | 0;
	//var r = ((x-offset_x)/(cell_w/2) - (y-offset_y)/(cell_h/2)) / 4 | 0;

	//console.log('c:', c);
	//console.log('r:', r);
	//console.log('i:', c*cols_nb+r)



		x = (x-offset_x) / cell_w // - 0.25001;
		y = (y-offset_y) / cell_h // - 0.37501;

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

/*
- vecteurs ??
- distances ??
- "draw"
- debug

*/
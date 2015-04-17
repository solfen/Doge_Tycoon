(function () { "use strict";
var $hxClasses = {};
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var buildings = {};
buildings.Building = function(p_type,p_index,pX,pY) {
	this._cheat_ratio = 0.3;
	this.type = p_type;
	this.lvl = buildings.Building.LVL_1;
	this.map_origin_index = p_index;
	this.col = utils.game.IsoTools.cell_col(this.map_origin_index,IsoMap.cols_nb);
	this.row = utils.game.IsoTools.cell_row(this.map_origin_index,IsoMap.cols_nb);
	this.is_builded = true;
	this.is_clickable = true;
	this.width_in_tiles_nb = this.get_config().width;
	this.height_in_tiles_nb = this.get_config().height;
	PIXI.MovieClip.call(this,this._get_texture());
	this.anchor.set(0,1);
	this.set_position(pX,pY);
	this.interactive = true;
	this.buttonMode = true;
	this.loop = true;
	this.animationSpeed = 0.333;
	this.all_map_index = buildings.Building.get_map_idx(this.map_origin_index,this.width_in_tiles_nb,this.height_in_tiles_nb);
	this.click = $bind(this,this._on_click);
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this._update));
};
$hxClasses["buildings.Building"] = buildings.Building;
buildings.Building.__name__ = ["buildings","Building"];
buildings.Building.get_building_type = function(id) {
	return id & 255;
};
buildings.Building.get_building_lvl = function(id) {
	return id & 3840;
};
buildings.Building.get_map_idx = function(pOrigin,pWidth,pHeight) {
	var map_idx = [];
	var i = pWidth * pHeight;
	while(i-- > 0) map_idx[i] = pOrigin - i % pWidth - (i / pWidth | 0) * IsoMap.cols_nb;
	return map_idx;
};
buildings.Building.__super__ = PIXI.MovieClip;
buildings.Building.prototype = $extend(PIXI.MovieClip.prototype,{
	get_id: function() {
		return this.type | this.lvl;
	}
	,get_config: function() {
		var key = this.get_id();
		return GameInfo.BUILDINGS_CONFIG.get(key);
	}
	,set_position: function(x,y) {
		x = x - IsoMap.cell_width * (this.width_in_tiles_nb - 1) * 0.5 | 0;
		y = y + IsoMap.cell_height;
		this.position.set(x,y);
	}
	,build: function() {
		this.is_builded = false;
		this.tint = 0;
		this._building_start_time = haxe.Timer.stamp();
		this.building_end_time = this._building_start_time + this.get_config().building_time * this._cheat_ratio;
	}
	,upgrade: function() {
		if(this.lvl < buildings.Building.LVL_3) {
			this.lvl += 256;
			this.textures = this._get_texture();
			this.gotoAndStop(0);
			this.build();
		}
	}
	,_update: function() {
		if(!this.is_builded) {
			var color = Std["int"]((haxe.Timer.stamp() - this._building_start_time) / (this.building_end_time - this._building_start_time) * 153);
			this.tint = color << 16 | color << 8 | color;
			if(haxe.Timer.stamp() >= this.building_end_time) {
				this.is_builded = true;
				this.tint = 16777215;
				this.play();
			}
		}
		if(this.is_clickable) this.alpha = Math.min(1,this.alpha + Main.getInstance().delta_time * 20); else this.alpha = Math.max(0.5,this.alpha - Main.getInstance().delta_time * 20);
	}
	,_on_click: function(p_data) {
		if(!this.is_builded || !this.is_clickable || !GameInfo.can_map_update) return;
		if(GameInfo.is_building_context_pop_open) {
			popin.PopinManager.getInstance().closeContextPopin();
			GameInfo.is_building_context_pop_open = false;
		} else {
			popin.PopinManager.getInstance().openContextPopin(this.width * 0.5 / utils.system.DeviceCapabilities.get_width(),-this.height * 0.5 / utils.system.DeviceCapabilities.get_height(),this);
			GameInfo.is_building_context_pop_open = true;
		}
	}
	,_get_texture: function() {
		var textures = new Array();
		var i = this.get_config().frames_nb;
		while(i-- > 0) textures.push(PIXI.Texture.fromFrame(Std.string(this.get_config().img) + "_" + i + GameInfo.BUILDINGS_IMG_EXTENSION));
		return textures;
	}
	,__class__: buildings.Building
});
var GameInfo = function() { };
$hxClasses["GameInfo"] = GameInfo;
GameInfo.__name__ = ["GameInfo"];
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var IsoMap = function(pBG_frame,pCols_nb,pRows_nb,pCell_width,pCell_height) {
	PIXI.DisplayObjectContainer.call(this);
	IsoMap.singleton = this;
	this._screen_margin = 0.0333;
	this._screen_move_speed = 0.5;
	this._screen_move_max_to_build = 64;
	this._screen_move_delay = 0.7;
	this._is_clicking = false;
	IsoMap.cols_nb = pCols_nb;
	IsoMap.rows_nb = pRows_nb;
	IsoMap.cells_nb = IsoMap.cols_nb * IsoMap.rows_nb;
	IsoMap.cell_width = pCell_width;
	IsoMap.cell_height = pCell_height;
	this.focused_building = null;
	this._map_width = IsoMap.cols_nb * IsoMap.cell_width;
	this._map_height = IsoMap.rows_nb * IsoMap.cell_height;
	this._screen_move_x = 0;
	this._screen_move_y = 0;
	this._time_to_move_screen = haxe.Timer.stamp();
	this._cells_pts = utils.game.IsoTools.all_map_pts_xy(0,0,IsoMap.cell_width,IsoMap.cell_height,IsoMap.cols_nb * IsoMap.rows_nb,IsoMap.cols_nb);
	this.x = this._old_x = Std["int"](utils.system.DeviceCapabilities.get_width() * 0.5 - this._map_width * 0.5);
	this.y = this._old_y = Std["int"](utils.system.DeviceCapabilities.get_height() * 0.5 - this._map_height * 0.5);
	this.buildings_list = new Array();
	this.obstacles_layer = new Array();
	this.addChild(new PIXI.TilingSprite(PIXI.Texture.fromFrame(pBG_frame),this._map_width,this._map_height));
	this._graphics = new PIXI.Graphics();
	this._graphics.lineStyle(1,8965375,1);
	this.addChild(this._graphics);
	var i = IsoMap.cells_nb;
	while(i-- > 0) {
		this.obstacles_layer[i] = false;
		this._graphics.moveTo(this._cells_pts[i].x0,this._cells_pts[i].y0);
		this._graphics.lineTo(this._cells_pts[i].x1,this._cells_pts[i].y1);
		this._graphics.lineTo(this._cells_pts[i].x2,this._cells_pts[i].y2);
		this._graphics.lineTo(this._cells_pts[i].x3,this._cells_pts[i].y3);
		this._graphics.lineTo(this._cells_pts[i].x0,this._cells_pts[i].y0);
		if(i / IsoMap.cols_nb - (i / IsoMap.cols_nb | 0) == 0) {
			this.addChild(new PIXI.DisplayObjectContainer());
			this.addChild(new PIXI.DisplayObjectContainer());
		}
	}
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this._update));
};
$hxClasses["IsoMap"] = IsoMap;
IsoMap.__name__ = ["IsoMap"];
IsoMap.__super__ = PIXI.DisplayObjectContainer;
IsoMap.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	build_building: function(pBuilding_type,pX,pY) {
		var build_data = this._get_building_coord(pBuilding_type,this.current_overflown_cell);
		if(!build_data.can_build) return null;
		var building = new buildings.Building(pBuilding_type,this.current_overflown_cell,build_data.x,build_data.y);
		building.build();
		var building_map_idx = buildings.Building.get_map_idx(build_data.index,building.width_in_tiles_nb,building.height_in_tiles_nb);
		var i = building_map_idx.length;
		while(i-- > 0) this.obstacles_layer[building_map_idx[i]] = true;
		try {
			this.getChildAt((build_data.row * 2 - building.height_in_tiles_nb | 0) + 3).addChild(building);
		} catch( error ) {
			console.log(error);
		}
		return building;
	}
	,destroy_building: function(pX,pY) {
	}
	,_update: function() {
		if(!GameInfo.can_map_update) {
			this._is_clicking = false;
			if(this._previewing_building != null) {
				this.removeChild(this._previewing_building);
				this._previewing_building = null;
			}
			return;
		}
		if(utils.game.IsoTools.is_inside_map(utils.game.InputInfos.mouse_x,utils.game.InputInfos.mouse_y,this.x | 0,this.y | 0,IsoMap.cell_width,IsoMap.cell_height,IsoMap.cells_nb,IsoMap.cols_nb)) {
			this.current_overflown_cell = utils.game.IsoTools.cell_index_from_xy(utils.game.InputInfos.mouse_x,utils.game.InputInfos.mouse_y,this.x | 0,this.y | 0,IsoMap.cell_width,IsoMap.cell_height,IsoMap.cols_nb);
			var i = this.buildings_list.length;
			var map_x_on_screen = utils.game.InputInfos.mouse_x - this.x;
			var map_y_on_screen = utils.game.InputInfos.mouse_y - this.y;
			var next_focused = null;
			while(i-- > 0) if(map_x_on_screen >= this.buildings_list[i].x && map_x_on_screen <= this.buildings_list[i].x + this.buildings_list[i].width && map_y_on_screen >= this.buildings_list[i].y - this.buildings_list[i].height && map_y_on_screen <= this.buildings_list[i].y) {
				if(HxOverrides.indexOf(this.buildings_list[i].all_map_index,this.current_overflown_cell,0) == -1) this.buildings_list[i].is_clickable = this.focused_building == null || this.focused_building.row >= this.buildings_list[i].row; else {
					next_focused = this.buildings_list[i];
					this.buildings_list[i].is_clickable = true;
				}
			} else this.buildings_list[i].is_clickable = true;
			this.focused_building = next_focused;
		}
		if(this._is_clicking && !utils.game.InputInfos.is_mouse_down) {
			this._is_clicking = false;
			this._on_click();
		} else if(!this._is_clicking && utils.game.InputInfos.is_mouse_down) {
			this._old_x = this.x;
			this._old_y = this.y;
			this._is_clicking = true;
		}
		if(utils.game.InputInfos.is_mouse_down) {
			this.x = utils.game.InputInfos.mouse_x - (utils.game.InputInfos.last_mouse_down_x - this._old_x);
			if(this.x > 0) this.x = 0; else if(this.x < utils.system.DeviceCapabilities.get_width() - this._map_width) this.x = utils.system.DeviceCapabilities.get_width() - this._map_width; else this.x = this.x;
			this.y = utils.game.InputInfos.mouse_y - (utils.game.InputInfos.last_mouse_down_y - this._old_y);
			if(this.y > 0) this.y = 0; else if(this.y < utils.system.DeviceCapabilities.get_height() - this._map_height) this.y = utils.system.DeviceCapabilities.get_height() - this._map_height; else this.y = this.y;
		}
		this._graphics.visible = GameInfo.building_2_build > 0;
		if(GameInfo.building_2_build > 0) {
			var build_data = this._get_building_coord(GameInfo.building_2_build,this.current_overflown_cell);
			if(this._previewing_building == null) {
				this._previewing_building = new buildings.PreviewBuilding(GameInfo.building_2_build,build_data.x,build_data.y);
				this.addChild(this._previewing_building);
			}
			if(!build_data.can_build && this._previewing_building.tint == 16777215) this._previewing_building.tint = buildings.PreviewBuilding.CANT_BUILD_COLOR; else if(build_data.can_build && this._previewing_building.tint != 16777215) this._previewing_building.tint = 16777215;
			this._previewing_building.set_position(build_data.x,build_data.y);
		}
	}
	,_on_click: function() {
		if(GameInfo.building_2_build > 0 && (this._old_x / this._screen_move_max_to_build | 0) == (this.x / this._screen_move_max_to_build | 0) && (this._old_y / this._screen_move_max_to_build | 0) == (this.y / this._screen_move_max_to_build | 0)) {
			var new_building = this.build_building(GameInfo.building_2_build,utils.game.InputInfos.mouse_x,utils.game.InputInfos.mouse_y);
			if(new_building != null) {
				GameInfo.building_2_build = 0;
				this.buildings_list.push(new_building);
				this.removeChild(this._previewing_building);
				this._previewing_building = null;
			}
		}
	}
	,_get_building_coord: function(pBuilding_type,index) {
		var col = utils.game.IsoTools.cell_col(index,IsoMap.cols_nb);
		var row = utils.game.IsoTools.cell_row(index,IsoMap.cols_nb);
		var new_x = utils.game.IsoTools.cell_x(col,IsoMap.cell_width,0);
		var new_y = utils.game.IsoTools.cell_y(row,IsoMap.cell_height,0);
		var can_build = true;
		var conf = GameInfo.BUILDINGS_CONFIG.get(pBuilding_type | buildings.Building.LVL_1);
		var building_map_idx = buildings.Building.get_map_idx(index,conf.width,conf.height);
		var i = building_map_idx.length;
		while(can_build && i-- > 0) if(this.obstacles_layer[building_map_idx[i]]) can_build = false;
		return { index : index, col : col, row : row, x : new_x, y : new_y, can_build : can_build};
	}
	,__class__: IsoMap
});
var LoadInfo = function() { };
$hxClasses["LoadInfo"] = LoadInfo;
LoadInfo.__name__ = ["LoadInfo"];
var utils = {};
utils.events = {};
utils.events.IEventDispatcher = function() { };
$hxClasses["utils.events.IEventDispatcher"] = utils.events.IEventDispatcher;
utils.events.IEventDispatcher.__name__ = ["utils","events","IEventDispatcher"];
utils.events.IEventDispatcher.prototype = {
	__class__: utils.events.IEventDispatcher
};
utils.events.EventDispatcher = function() {
	this.listeners = [];
};
$hxClasses["utils.events.EventDispatcher"] = utils.events.EventDispatcher;
utils.events.EventDispatcher.__name__ = ["utils","events","EventDispatcher"];
utils.events.EventDispatcher.__interfaces__ = [utils.events.IEventDispatcher];
utils.events.EventDispatcher.prototype = {
	hasEventListener: function(pType,pListener) {
		var _g1 = 0;
		var _g = this.listeners.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.listeners[i].type == pType && this.listeners[i].listener == pListener) return i;
		}
		return -1;
	}
	,addEventListener: function(pType,pListener) {
		if(this._disposed) return;
		var lId = this.hasEventListener(pType,pListener);
		if(lId == -1) this.listeners.push({ type : pType, listener : pListener, target : this});
	}
	,removeEventListener: function(pType,pListener) {
		if(this._disposed) return;
		var lId = this.hasEventListener(pType,pListener);
		if(lId != -1) this.listeners.splice(lId,1);
	}
	,dispatchEvent: function(pEvent) {
		var lDispatch = [];
		var _g1 = 0;
		var _g = this.listeners.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.listeners[i].type == pEvent.type) lDispatch.push(this.listeners[i]);
		}
		pEvent.target = this;
		var _g11 = 0;
		var _g2 = lDispatch.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			lDispatch[i1].listener.apply(this,[pEvent]);
		}
	}
	,destroy: function() {
		this.listeners = null;
		this._disposed = true;
	}
	,__class__: utils.events.EventDispatcher
};
var Main = function() {
	var _g = this;
	utils.events.EventDispatcher.call(this);
	Main.stage = new PIXI.Stage(4160703);
	this.renderer = PIXI.autoDetectRenderer(utils.system.DeviceCapabilities.get_width(),utils.system.DeviceCapabilities.get_height());
	this.delta_time = 0;
	Main.stats = new Stats();
	Main.stats.domElement.style.position = "absolute";
	Main.stats.domElement.style.top = "0px";
	window.document.body.appendChild(this.renderer.view);
	window.document.body.appendChild(Main.stats.domElement);
	window.addEventListener("resize",$bind(this,this.resize));
	this.WebFontConfig = { custom : { families : ["FuturaStdMedium","FuturaStdHeavy"], urls : ["fonts.css"]}, active : function() {
		_g.preloadAssets();
	}};
	WebFont.load(this.WebFontConfig);
	this.gameLoop(0);
};
$hxClasses["Main"] = Main;
Main.__name__ = ["Main"];
Main.main = function() {
	Main.getInstance();
};
Main.getInstance = function() {
	if(Main.instance == null) Main.instance = new Main();
	return Main.instance;
};
Main.getStage = function() {
	return Main.stage;
};
Main.__super__ = utils.events.EventDispatcher;
Main.prototype = $extend(utils.events.EventDispatcher.prototype,{
	preloadAssets: function() {
		var lLoader = new PIXI.AssetLoader(LoadInfo.preloadAssets);
		lLoader.addEventListener("onComplete",$bind(this,this.loadAssets));
		lLoader.load();
	}
	,loadAssets: function(pEvent) {
		pEvent.target.removeEventListener("onComplete",$bind(this,this.loadAssets));
		scenes.ScenesManager.getInstance().loadScene("LoaderScene");
		var lLoader = new PIXI.AssetLoader(LoadInfo.loadAssets);
		lLoader.addEventListener("onProgress",$bind(this,this.onLoadProgress));
		lLoader.addEventListener("onComplete",$bind(this,this.onLoadComplete));
		lLoader.load();
	}
	,onLoadProgress: function(pEvent) {
		var lLoader;
		lLoader = js.Boot.__cast(pEvent.target , PIXI.AssetLoader);
		GameInfo.loaderCompletion = (lLoader.assetURLs.length - lLoader.loadCount) / lLoader.assetURLs.length;
	}
	,onLoadComplete: function(pEvent) {
		pEvent.target.removeEventListener("onProgress",$bind(this,this.onLoadProgress));
		pEvent.target.removeEventListener("onComplete",$bind(this,this.onLoadComplete));
		scenes.ScenesManager.getInstance().loadScene("GameScene");
	}
	,onFacebookConnect: function(pResponse) {
		console.log(pResponse.status);
		if(pResponse.status == "connected") {
			console.log("awww yeah ! you're in !");
			FB.ui({ method : "share", href : "https://developers.facebook.com/docs"},$bind(this,this.test));
		} else if(pResponse.status == "not_authorized") console.log("Oh no ! you're not identified");
	}
	,test: function() {
		console.log("succes");
	}
	,gameLoop: function(timestamp) {
		var start = haxe.Timer.stamp();
		Main.stats.begin();
		window.requestAnimationFrame($bind(this,this.gameLoop));
		this.render();
		this.dispatchEvent(new utils.events.Event("Event.GAME_LOOP"));
		Main.stats.end();
		this.delta_time = haxe.Timer.stamp() - start;
	}
	,resize: function(pEvent) {
		this.renderer.resize(utils.system.DeviceCapabilities.get_width(),utils.system.DeviceCapabilities.get_height());
		this.dispatchEvent(new utils.events.Event("Event.RESIZE"));
	}
	,render: function() {
		this.renderer.render(Main.stage);
	}
	,destroy: function() {
		window.removeEventListener("resize",$bind(this,this.resize));
		Main.instance = null;
		utils.events.EventDispatcher.prototype.destroy.call(this);
	}
	,__class__: Main
});
var IMap = function() { };
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
Math.__name__ = ["Math"];
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
};
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
};
buildings.PreviewBuilding = function(p_type,pX,pY) {
	buildings.Building.call(this,p_type,-1,pX,pY);
	this.click = null;
	this.mouseover = null;
	this.interactive = false;
	this.buttonMode = false;
	this.alpha = 0.7;
};
$hxClasses["buildings.PreviewBuilding"] = buildings.PreviewBuilding;
buildings.PreviewBuilding.__name__ = ["buildings","PreviewBuilding"];
buildings.PreviewBuilding.__super__ = buildings.Building;
buildings.PreviewBuilding.prototype = $extend(buildings.Building.prototype,{
	_update: function() {
	}
	,__class__: buildings.PreviewBuilding
});
var haxe = {};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
};
haxe.Timer.prototype = {
	run: function() {
	}
	,__class__: haxe.Timer
};
haxe.ds = {};
haxe.ds.IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe.ds.IntMap;
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,__class__: haxe.ds.IntMap
};
haxe.ds.StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe.ds.StringMap;
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,__class__: haxe.ds.StringMap
};
var hud = {};
hud.IconHud = function(startX,startY,texturePathNormal,texturePathActive,pIsUpdatable,isInteractive) {
	if(isInteractive == null) isInteractive = true;
	if(pIsUpdatable == null) pIsUpdatable = false;
	this.hoverTexture = null;
	this.activeTexture = null;
	this.normalTexture = PIXI.Texture.fromFrame(texturePathNormal);
	if(texturePathActive != null) this.activeTexture = PIXI.Texture.fromImage(texturePathActive);
	PIXI.Sprite.call(this,this.normalTexture);
	this.position.set(Std["int"](startX * utils.system.DeviceCapabilities.get_width()),Std["int"](startY * utils.system.DeviceCapabilities.get_height()));
	if(isInteractive) {
		this.interactive = true;
		this.buttonMode = true;
		this.mousedown = $bind(this,this.onMouseDown);
		this.mouseup = $bind(this,this.onMouseUp);
		this.mouseupoutside = $bind(this,this.onMouseUp);
		this.click = $bind(this,this.onClick);
	}
	this.isUpdatable = pIsUpdatable;
};
$hxClasses["hud.IconHud"] = hud.IconHud;
hud.IconHud.__name__ = ["hud","IconHud"];
hud.IconHud.__super__ = PIXI.Sprite;
hud.IconHud.prototype = $extend(PIXI.Sprite.prototype,{
	changeTexture: function(state) {
		if(state == "active" && this.activeTexture != null) this.setTexture(this.activeTexture); else if(state == "normal") this.setTexture(this.normalTexture); else console.log("IconHud changeTexture() : Invalid texture change, check if correct state and/or correct textures. State: " + state);
	}
	,onMouseDown: function(pData) {
		if(this.activeTexture != null) this.setTexture(this.activeTexture);
	}
	,onMouseUp: function(pData) {
		this.setTexture(this.normalTexture);
	}
	,onClick: function(pData) {
	}
	,updateInfo: function() {
	}
	,__class__: hud.IconHud
});
hud.HudBuild = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudIconBuildNormal.png","HudIconBuildActive.png");
};
$hxClasses["hud.HudBuild"] = hud.HudBuild;
hud.HudBuild.__name__ = ["hud","HudBuild"];
hud.HudBuild.__super__ = hud.IconHud;
hud.HudBuild.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		var curName = popin.PopinManager.getInstance().getCurrentPopinName();
		if(curName != null) {
			popin.PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinBuild") popin.PopinManager.getInstance().openPopin("PopinBuild",0.5,0.55);
	}
	,__class__: hud.HudBuild
});
hud.HudDoges = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudPopFillBar.png",null,true,false);
	this.barFill = new PIXI.Sprite(PIXI.Texture.fromImage("HudPopFill.png"));
	this.barFill.position.set(0.23 * this.width | 0,0.3 * this.height | 0);
	this.barFill.width = this.lastDogeNumber / this.lastDogeMaxNumber * this.width * .725 | 0;
	this.addChild(this.barFill);
	this.dogeIcon = new PIXI.Sprite(PIXI.Texture.fromImage("HudIconPop.png"));
	this.dogeIcon.position.set(0,0.05 * this.height | 0);
	this.addChild(this.dogeIcon);
	this.dogeNumberText = new PIXI.Text("",{ font : "22px FuturaStdHeavy", fill : "white"});
	this.addChild(this.dogeNumberText);
	this.updateInfo();
};
$hxClasses["hud.HudDoges"] = hud.HudDoges;
hud.HudDoges.__name__ = ["hud","HudDoges"];
hud.HudDoges.__super__ = hud.IconHud;
hud.HudDoges.prototype = $extend(hud.IconHud.prototype,{
	updateInfo: function() {
		if(this.lastDogeNumber != GameInfo.dogeNumber || this.lastDogeMaxNumber != GameInfo.dogeMaxNumber) {
			this.lastDogeNumber = GameInfo.dogeNumber;
			this.lastDogeMaxNumber = GameInfo.dogeMaxNumber;
			this.barFill.width = this.lastDogeNumber / this.lastDogeMaxNumber * this.width * .72 | 0;
			this.dogeNumberText.setText(this.lastDogeNumber + "/" + this.lastDogeMaxNumber);
			var xPos = Math.max(this.dogeIcon.x + this.dogeIcon.width,this.barFill.width - this.dogeNumberText.width + this.barFill.x - this.width * 0.02);
			this.dogeNumberText.position.set(xPos | 0,this.height / 1.8 - this.dogeNumberText.height / 2 | 0);
		}
	}
	,__class__: hud.HudDoges
});
hud.HudFric = function(startX,startY) {
	this.lastFric = GameInfo.ressources.get("fric").userPossesion;
	hud.IconHud.call(this,startX,startY,"HudMoneySoft.png",null,true,false);
	this.fricText = new PIXI.Text(this.lastFric + "",{ font : "35px FuturaStdHeavy", fill : "white"});
	this.fricText.position.x = this.width * 0.95 - this.fricText.width | 0;
	this.fricText.position.y = this.height / 2 - this.fricText.height / 2 | 0;
	this.addChild(this.fricText);
	this.updateInfo();
};
$hxClasses["hud.HudFric"] = hud.HudFric;
hud.HudFric.__name__ = ["hud","HudFric"];
hud.HudFric.__super__ = hud.IconHud;
hud.HudFric.prototype = $extend(hud.IconHud.prototype,{
	updateInfo: function() {
		if(this.lastFric != GameInfo.ressources.get("fric").userPossesion) {
			this.lastFric = GameInfo.ressources.get("fric").userPossesion;
			this.fricText.setText(this.lastFric + "");
			this.fricText.position.x = this.width * 0.95 - this.fricText.width | 0;
		}
	}
	,__class__: hud.HudFric
});
hud.HudHardMoney = function(startX,startY) {
	this.lastHardMoney = GameInfo.ressources.get("hardMoney").userPossesion;
	hud.IconHud.call(this,startX,startY,"HudMoneyHard.png",null,true,false);
	this.hardMoneyText = new PIXI.Text(this.lastHardMoney + "",{ font : "35px FuturaStdHeavy", fill : "white"});
	this.hardMoneyText.position.x = this.width * 0.95 - this.hardMoneyText.width | 0;
	this.hardMoneyText.position.y = this.height / 2 - this.hardMoneyText.height / 2 | 0;
	this.addChild(this.hardMoneyText);
};
$hxClasses["hud.HudHardMoney"] = hud.HudHardMoney;
hud.HudHardMoney.__name__ = ["hud","HudHardMoney"];
hud.HudHardMoney.__super__ = hud.IconHud;
hud.HudHardMoney.prototype = $extend(hud.IconHud.prototype,{
	updateInfo: function() {
		if(this.lastHardMoney != GameInfo.ressources.get("hardMoney").userPossesion) {
			this.lastHardMoney = GameInfo.ressources.get("hardMoney").userPossesion;
			this.hardMoneyText.setText(this.lastHardMoney + "");
			this.hardMoneyText.position.x = this.width * 0.95 - this.hardMoneyText.width | 0;
		}
	}
	,__class__: hud.HudHardMoney
});
hud.HudInventory = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudIconInventoryNormal.png","HudIconInventoryActive.png");
};
$hxClasses["hud.HudInventory"] = hud.HudInventory;
hud.HudInventory.__name__ = ["hud","HudInventory"];
hud.HudInventory.__super__ = hud.IconHud;
hud.HudInventory.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		if(popin.PopinManager.getInstance().isPopinOpen("PopinInventory")) {
			popin.PopinManager.getInstance().closePopin("PopinInventory");
			GameInfo.can_map_update = true;
		} else popin.PopinManager.getInstance().openPopin("PopinInventory",0.9,0.55);
	}
	,__class__: hud.HudInventory
});
hud.HudManager = function() {
	this.refreshChildsInterval = 1000;
	this.lastX = 0;
	this.hudBottomY = 0;
	this.hudTopY = 0.025;
	this.hudWidthInterval = 0.05;
	this.containers = new haxe.ds.StringMap();
	this.childs = new haxe.ds.StringMap();
	PIXI.DisplayObjectContainer.call(this);
	this.addContainer(0.01,0,"HudTop",0.92,0.05,"center");
	this.addHud(new hud.HudFric(0,this.hudTopY),"HudFric","HudTop");
	this.addHud(new hud.HudHardMoney(0,this.hudTopY),"HudHardMoney","HudTop");
	this.addHud(new hud.HudDoges(0,this.hudTopY),"HudDoges","HudTop");
	this.addHud(new hud.HudStock(0,this.hudTopY),"HudStock","HudTop");
	this.addContainer(0.01,0.9,"HudBottom",.98,0.01,"right");
	this.addHud(new hud.HudInventory(0,this.hudBottomY),"HudInventory","HudBottom");
	this.addHud(new hud.HudQuests(0,this.hudBottomY),"HudQuests","HudBottom");
	this.addHud(new hud.HudMarket(0,this.hudBottomY - 0.01),"HudMarket","HudBottom");
	this.addHud(new hud.HudShop(0,this.hudBottomY - 0.008),"HudShop","HudBottom");
	this.addHud(new hud.HudBuild(0,this.hudBottomY),"HudBuild","HudBottom");
	this.resizeHud();
	Main.getInstance().addEventListener("Event.RESIZE",$bind(this,this.resizeHud));
	this.refreshChildsInfoTimer = new haxe.Timer(this.refreshChildsInterval);
	this.refreshChildsInfoTimer.run = $bind(this,this.updateChildText);
};
$hxClasses["hud.HudManager"] = hud.HudManager;
hud.HudManager.__name__ = ["hud","HudManager"];
hud.HudManager.getInstance = function() {
	if(hud.HudManager.instance == null) hud.HudManager.instance = new hud.HudManager();
	return hud.HudManager.instance;
};
hud.HudManager.__super__ = PIXI.DisplayObjectContainer;
hud.HudManager.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	resizeHud: function() {
		var $it0 = this.containers.iterator();
		while( $it0.hasNext() ) {
			var container = $it0.next();
			container.obj.scale.x = container.obj.scale.y = 1.0;
			var childsWidth = -container.interval;
			var childsArr = container.obj.children;
			var _g = 0;
			while(_g < childsArr.length) {
				var i = childsArr[_g];
				++_g;
				i.position.x = Std["int"]((childsWidth + container.interval) * utils.system.DeviceCapabilities.get_width());
				childsWidth += i.width / utils.system.DeviceCapabilities.get_width() + container.interval;
			}
			if(childsWidth > container.maxWidth) {
				container.obj.scale.x = container.maxWidth / childsWidth;
				container.obj.scale.y = container.maxWidth / childsWidth;
				container.obj.position.x = Std["int"](container.startX * utils.system.DeviceCapabilities.get_width());
			} else {
				var tempX;
				if(container.align == "left") tempX = container.startX; else if(container.align == "center") tempX = container.startX + (container.maxWidth - childsWidth) / 2; else tempX = container.startX + container.maxWidth - childsWidth;
				container.obj.position.x = Std["int"](tempX * utils.system.DeviceCapabilities.get_width());
			}
			container.obj.position.y = Math.min(Std["int"](container.startY * utils.system.DeviceCapabilities.get_height()),utils.system.DeviceCapabilities.get_height() - container.obj.children[0].height);
		}
	}
	,updateChildText: function() {
		var $it0 = this.childs.iterator();
		while( $it0.hasNext() ) {
			var child = $it0.next();
			if(child.isUpdatable) child.updateInfo();
		}
	}
	,addContainer: function(x,y,name,maxWidth,interval,align) {
		if(align == null) align = "left";
		var container = new PIXI.DisplayObjectContainer();
		container.position.set(Std["int"](x * utils.system.DeviceCapabilities.get_width()),Std["int"](y * utils.system.DeviceCapabilities.get_height()));
		var v = { };
		this.containers.set(name,v);
		v;
		this.containers.get(name).obj = container;
		this.containers.get(name).maxWidth = maxWidth;
		this.containers.get(name).interval = interval;
		this.containers.get(name).startX = x;
		this.containers.get(name).startY = y;
		this.containers.get(name).align = align;
		this.addChild(container);
	}
	,addHud: function(child,name,target) {
		this.childs.set(name,child);
		child;
		this.containers.get(target).obj.addChild(child);
	}
	,destroy: function() {
		var $it0 = this.childs.iterator();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			this.removeChild(i);
		}
		this.childs = new haxe.ds.StringMap();
		hud.HudManager.instance = null;
	}
	,__class__: hud.HudManager
});
hud.HudMarket = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudIconMarketNormal.png","HudIconMarketActive.png");
};
$hxClasses["hud.HudMarket"] = hud.HudMarket;
hud.HudMarket.__name__ = ["hud","HudMarket"];
hud.HudMarket.__super__ = hud.IconHud;
hud.HudMarket.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		var curName = popin.PopinManager.getInstance().getCurrentPopinName();
		if(curName != null) {
			popin.PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinMarket") popin.PopinManager.getInstance().openPopin("PopinMarket",0.5,0.55);
	}
	,__class__: hud.HudMarket
});
hud.HudQuests = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudIconQuestNormal.png","HudIconQuestActive.png");
};
$hxClasses["hud.HudQuests"] = hud.HudQuests;
hud.HudQuests.__name__ = ["hud","HudQuests"];
hud.HudQuests.__super__ = hud.IconHud;
hud.HudQuests.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		var curName = popin.PopinManager.getInstance().getCurrentPopinName();
		if(curName != "PopinInventory") {
			popin.PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinQuests") popin.PopinManager.getInstance().openPopin("PopinQuests",0.5,0.55);
	}
	,__class__: hud.HudQuests
});
hud.HudShop = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudIconShopNormal.png","HudIconShopActive.png");
};
$hxClasses["hud.HudShop"] = hud.HudShop;
hud.HudShop.__name__ = ["hud","HudShop"];
hud.HudShop.__super__ = hud.IconHud;
hud.HudShop.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		var curName = popin.PopinManager.getInstance().getCurrentPopinName();
		if(curName != "PopinInventory") {
			popin.PopinManager.getInstance().closeCurentPopin();
			GameInfo.can_map_update = true;
		}
		if(curName != "PopinShop") popin.PopinManager.getInstance().openPopin("PopinShop",0.5,0.55);
	}
	,__class__: hud.HudShop
});
hud.HudStock = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"HudInventoryFillBar.png",null,true,false);
	this.barFill = new PIXI.Sprite(PIXI.Texture.fromImage("HudInventoryFill.png"));
	this.barFill.position.set(0.23 * this.width | 0,0.3 * this.height | 0);
	this.barFill.width = this.lastStockPercent / 100 * this.width * .725 | 0;
	this.addChild(this.barFill);
	this.inventoryIcon = new PIXI.Sprite(PIXI.Texture.fromImage("HudIconInventory.png"));
	this.inventoryIcon.position.set(0,0.05 * this.height | 0);
	this.addChild(this.inventoryIcon);
	this.lastStockPercentText = new PIXI.Text("",{ font : "22px FuturaStdHeavy", fill : "white"});
	this.addChild(this.lastStockPercentText);
	this.updateInfo();
};
$hxClasses["hud.HudStock"] = hud.HudStock;
hud.HudStock.__name__ = ["hud","HudStock"];
hud.HudStock.__super__ = hud.IconHud;
hud.HudStock.prototype = $extend(hud.IconHud.prototype,{
	updateInfo: function() {
		if(this.lastStockPercent != GameInfo.stockPercent) {
			this.lastStockPercent = GameInfo.stockPercent;
			this.barFill.width = this.lastStockPercent / 100 * this.width * .72 | 0;
			this.lastStockPercentText.setText(this.lastStockPercent + "%");
			var xPos = Math.max(this.inventoryIcon.x + this.inventoryIcon.width,this.barFill.width - this.lastStockPercentText.width + this.barFill.x - this.width * 0.02);
			this.lastStockPercentText.position.set(xPos | 0,this.height / 1.8 - this.lastStockPercentText.height / 2 | 0);
		}
	}
	,__class__: hud.HudStock
});
var js = {};
js.Boot = function() { };
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
var pixi = {};
pixi.renderers = {};
pixi.renderers.IRenderer = function() { };
$hxClasses["pixi.renderers.IRenderer"] = pixi.renderers.IRenderer;
pixi.renderers.IRenderer.__name__ = ["pixi","renderers","IRenderer"];
pixi.renderers.IRenderer.prototype = {
	__class__: pixi.renderers.IRenderer
};
var popin = {};
popin.IconPopin = function(pX,pY,texturePathNormal,pName,isInteractive,texturePathActive,pIsSelectButton) {
	if(pIsSelectButton == null) pIsSelectButton = false;
	this.isCurrentTextureNormal = true;
	this.isSelectButton = false;
	this.activeTexture = null;
	this.normalTexture = PIXI.Texture.fromImage(texturePathNormal);
	this.isSelectButton = pIsSelectButton;
	if(texturePathActive != null) this.activeTexture = PIXI.Texture.fromImage(texturePathActive);
	PIXI.Sprite.call(this,this.normalTexture);
	this.x = pX;
	this.y = pY;
	this._name = pName;
	this.interactive = isInteractive;
	this.buttonMode = isInteractive;
	if(isInteractive && !this.isSelectButton) {
		this.mouseover = $bind(this,this.onMouseOver);
		this.mouseout = $bind(this,this.onMouseOut);
	} else if(this.isSelectButton) this.mousedown = $bind(this,this.onClick);
	this.mouseupoutside = $bind(this,this.onIconUpOutside);
};
$hxClasses["popin.IconPopin"] = popin.IconPopin;
popin.IconPopin.__name__ = ["popin","IconPopin"];
popin.IconPopin.__super__ = PIXI.Sprite;
popin.IconPopin.prototype = $extend(PIXI.Sprite.prototype,{
	onMouseOver: function(pData) {
		if(this.activeTexture == null) return;
		this.setTexture(this.activeTexture);
	}
	,onMouseOut: function(pData) {
		this.setTexture(this.normalTexture);
	}
	,onClick: function(pData) {
		if(this.activeTexture == null) return;
		this.setTexture(this.activeTexture);
	}
	,onIconUpOutside: function(pData) {
	}
	,setTextureToNormal: function(pData) {
		this.setTexture(this.normalTexture);
	}
	,setTextureToActive: function() {
		this.setTexture(this.activeTexture);
	}
	,__class__: popin.IconPopin
});
popin.MyPopin = function(pstartX,pstartY,texturePath,isModal) {
	if(isModal == null) isModal = false;
	if(pstartY == null) pstartY = 0;
	if(pstartX == null) pstartX = 0;
	this.scrollDragging = false;
	this.containers = new haxe.ds.StringMap();
	this.icons = new haxe.ds.StringMap();
	this.childs = new haxe.ds.StringMap();
	PIXI.DisplayObjectContainer.call(this);
	this.startX = pstartX;
	this.startY = pstartY;
	this.onResize();
	Main.getInstance().addEventListener("Event.RESIZE",$bind(this,this.onResize));
	this.background = new PIXI.Sprite(PIXI.Texture.fromImage(texturePath));
	this.background.anchor.set(0.5,0.5);
	var v = this.background;
	this.childs.set("background",v);
	v;
	this.addChild(this.background);
};
$hxClasses["popin.MyPopin"] = popin.MyPopin;
popin.MyPopin.__name__ = ["popin","MyPopin"];
popin.MyPopin.__super__ = PIXI.DisplayObjectContainer;
popin.MyPopin.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	addIcon: function(x,y,texturePath,name,target,isInteractive,texturePathActive,pIsSelectButton) {
		if(pIsSelectButton == null) pIsSelectButton = false;
		if(isInteractive == null) isInteractive = false;
		var icon = new popin.IconPopin(x * this.background.width - this.background.width / 2 | 0,y * this.background.height - this.background.height / 2 | 0,texturePath,name,isInteractive,texturePathActive,pIsSelectButton);
		if(isInteractive) {
			icon.mouseup = $bind(this,this.childClick);
			icon.mouseupoutside = $bind(this,this.childUpOutside);
		}
		this.icons.set(name,icon);
		icon;
		target.addChild(icon);
	}
	,addHeader: function(x,y,startTexture) {
		this.header = new PIXI.Sprite(startTexture);
		this.header.position.set(x * this.background.width - this.background.width / 2 | 0,y * this.background.height - this.background.height / 2 | 0);
		this.addChild(this.header);
	}
	,addText: function(x,y,font,fontSize,txt,name,target,color,pAlign) {
		if(pAlign == null) pAlign = "left";
		if(color == null) color = "black";
		var style = { font : fontSize + " " + font, align : pAlign, fill : color};
		var tempText = new PIXI.Text(txt,style);
		tempText.position.x = x * this.background.width - this.background.width / 2 | 0;
		tempText.position.y = y * this.background.height - this.background.height / 2 | 0;
		this.childs.set(name,tempText);
		tempText;
		target.addChild(tempText);
	}
	,addMask: function(x,y,width,height,target) {
		this.graphics = new PIXI.Graphics();
		this.addChild(this.graphics);
		this.graphics.beginFill(16724736);
		this.graphics.drawRect(x,y,width,height);
		this.graphics.endFill();
		target.mask = this.graphics;
	}
	,addVerticalScrollBar: function() {
		var _g = this;
		this.addIcon(0.91,0.15,"assets/UI/PopIn/PopInScrollingBar.png","scrollingBar",this,false);
		this.scrollIndicator = new popin.IconPopin(0.933 * this.background.width - this.background.width / 2 | 0,0.23 * this.background.height - this.background.height / 2 | 0,"assets/UI/PopIn/PopInScrollingTruc.png","scrollingIndicator",true);
		this.scrollIndicator.mousedown = function(data) {
			_g.scrollDragging = true;
			_g.scrollDragSy = data.getLocalPosition(_g.scrollIndicator).y * _g.scrollIndicator.scale.y;
		};
		this.scrollIndicator.mouseup = this.scrollIndicator.mouseupoutside = function(data1) {
			_g.scrollDragging = false;
		};
		this.scrollIndicator.mousemove = function(data2) {
			var newY = data2.getLocalPosition(_g.scrollIndicator.parent).y - _g.scrollDragSy;
			_g.maxDragY = _g.containers.get("verticalScroller").height - _g.icons.get("contentBackground").height + 100;
			if(_g.scrollDragging && newY > 0.23 * _g.background.height - _g.background.height / 2 && newY < 0.635 * _g.background.height - _g.background.height / 2) {
				var interval = 0.635 * _g.background.height - _g.background.height / 2 - (0.23 * _g.background.height - _g.background.height / 2);
				_g.scrollIndicator.y = newY;
				_g.containers.get("verticalScroller").y = -((newY - (0.23 * _g.background.height - _g.background.height / 2)) * _g.maxDragY / interval | 0);
			}
		};
		var v = this.scrollIndicator;
		this.icons.set("scrollingIndicator",v);
		v;
		this.addChild(this.scrollIndicator);
		this.mouse_wheel_dir = utils.game.InputInfos.mouse_wheel_dir;
		this.startScrollY = this.containers.get("verticalScroller").y;
		Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.scroll));
	}
	,scroll: function() {
		if(utils.game.InputInfos.mouse_wheel_dir == 0 || utils.game.InputInfos.mouse_x - this.x + this.background.width / 2 > this.background.x + this.background.width || utils.game.InputInfos.mouse_x - this.x + this.background.width / 2 < this.background.x || utils.game.InputInfos.mouse_y - this.y + this.background.height / 2 > this.background.y + this.background.height || utils.game.InputInfos.mouse_y - this.y + this.background.height / 2 < this.background.y) return;
		var maxScrollY = this.containers.get("verticalScroller").height - this.icons.get("articleBase").height * 3 + 25;
		var contentDeltaY = -(this.mouse_wheel_dir + utils.game.InputInfos.mouse_wheel_dir) / 3 * this.icons.get("articleBase").height * 0.5;
		if(contentDeltaY <= 0 && contentDeltaY > -maxScrollY) {
			this.mouse_wheel_dir += utils.game.InputInfos.mouse_wheel_dir;
			this.containers.get("verticalScroller").y = this.startScrollY + contentDeltaY | 0;
			this.scrollIndicator.y = (-(contentDeltaY / maxScrollY) * 0.405 + 0.23) * this.background.height - this.background.height / 2 | 0;
		}
		utils.game.InputInfos.mouse_wheel_dir = 0;
	}
	,removeVerticalScrollBar: function() {
		this.removeChild(this.icons.get("scrollingIndicator"));
		this.removeChild(this.icons.get("scrollingBar"));
		this.scrollIndicator = null;
		this.icons.set("scrollingIndicator",null);
		null;
		this.icons.set("scrollingBar",null);
		null;
	}
	,addContainer: function(name,target,x,y) {
		if(y == null) y = 0;
		if(x == null) x = 0;
		var temp = new PIXI.DisplayObjectContainer();
		temp.x = x;
		temp.y = y;
		this.containers.set(name,temp);
		temp;
		target.addChild(temp);
	}
	,onResize: function() {
		console.log("WUT???");
		this.x = Std["int"](this.startX * utils.system.DeviceCapabilities.get_width());
		this.y = Std["int"](this.startY * utils.system.DeviceCapabilities.get_height());
	}
	,childClick: function(pEvent) {
	}
	,childUpOutside: function(pEvent) {
	}
	,update: function() {
	}
	,stopClickEventPropagation: function(pEvent) {
	}
	,destroy: function() {
		Main.getInstance().removeEventListener("Event.GAME_LOOP",$bind(this,this.scroll));
	}
	,__class__: popin.MyPopin
});
popin.PopinBuild = function(startX,startY) {
	this.currentTab = "utilitairesTab";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInBuilt/PopInBuiltBgArticle.png").height;
	GameInfo.can_map_update = false;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	var _g = new haxe.ds.StringMap();
	_g.set("niches",PIXI.Texture.fromImage("assets/UI/PopInBuilt/PopInHeaderNiches.png"));
	_g.set("spaceships",PIXI.Texture.fromImage("assets/UI/PopInBuilt/PopInHeaderFusees.png"));
	_g.set("utilitaire",PIXI.Texture.fromImage("assets/UI/PopInBuilt/PopInHeaderUtilitaires.png"));
	this.headerTextures = _g;
	this.articleHeight /= this.background.height;
	this.addHeader(0.65,0.05,this.headerTextures.get("utilitaire"));
	this.addIcon(-0.15,-0.15,"assets/UI/PopInBuilt/PopInTitleConstruction.png","popInTitle",this,false);
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollBackground.png","contentBackground",this,false);
	this.addIcon(-0.02,0.17,"assets/UI/PopInBuilt/PopInOngletNicheNormal.png","nicheTab",this,true,"assets/UI/PopInBuilt/PopInOngletNicheActive.png",true);
	this.addIcon(-0.02,0.29,"assets/UI/PopInBuilt/PopInOngletFuseeNormal.png","spaceshipTab",this,true,"assets/UI/PopInBuilt/PopInOngletFuseeActive.png",true);
	this.addIcon(-0.02,0.41,"assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png","utilitairesTab",this,true,"assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png",true);
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addContainer("verticalScroller",this,0,0);
	this.addMask(this.icons.get("contentBackground").x,this.icons.get("contentBackground").y + 3,this.icons.get("contentBackground").width,this.icons.get("contentBackground").height - 6,this.containers.get("verticalScroller"));
	this.addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
	this.icons.get(this.currentTab).setTextureToActive();
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollOverlay.png","scrollOverlay",this,false);
};
$hxClasses["popin.PopinBuild"] = popin.PopinBuild;
popin.PopinBuild.__name__ = ["popin","PopinBuild"];
popin.PopinBuild.__super__ = popin.MyPopin;
popin.PopinBuild.prototype = $extend(popin.MyPopin.prototype,{
	addBuildArticles: function(ItemsConfig) {
		var cpt = 0;
		if(this.hasVerticalScrollBar) {
			this.removeVerticalScrollBar();
			this.hasVerticalScrollBar = false;
		}
		var _g = 0;
		while(_g < ItemsConfig.length) {
			var i = ItemsConfig[_g];
			++_g;
			var y = cpt * (this.articleHeight + this.articleInterline);
			var ressources = i.ressources;
			this.addIcon(0.115,0.175 + y,"assets/UI/PopInBuilt/PopInBuiltBgArticle.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.687,0.309 + y,"assets/UI/PopInBuilt/PopInBuiltSoftNormal.png","buildSoft" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInBuilt/PopInBuiltSoftActive.png",true);
			this.addIcon(0.815,0.309 + y,"assets/UI/PopInBuilt/PopInBuiltHardNormal.png","buildHard" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInBuilt/PopInBuiltHardActive.png",true);
			this.addIcon(0.13,0.1875 + y,i.previewImg,"ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addIcon(0.748,0.3 + y,GameInfo.ressources.get("hardMoney").iconImg,"HardRessource",this.containers.get("verticalScroller"),false);
			this.addText(0.77,0.34 + y,"FuturaStdHeavy","15px",i.hardPrice,"HardRessourcePrice",this.containers.get("verticalScroller"),"white");
			this.addText(0.298,0.18 + y,"FuturaStdHeavy","25px",i.title,"titleText",this.containers.get("verticalScroller"));
			this.addText(0.298,0.23 + y,"FuturaStdMedium","12px",i.description,"Description",this.containers.get("verticalScroller"));
			var _g2 = 0;
			var _g1 = ressources.length;
			while(_g2 < _g1) {
				var j = _g2++;
				this.addIcon(0.298 + 0.065 * j,0.3 + y,GameInfo.ressources.get(ressources[j].name).iconImg,"SoftRessource" + j,this.containers.get("verticalScroller"),false);
				this.addText(0.305 + 0.065 * j,0.345 + y,"FuturaStdHeavy","13px",ressources[j].quantity,"SoftRessourcePrice" + j,this.containers.get("verticalScroller"),"white");
			}
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.icons.get("contentBackground").height && !this.hasVerticalScrollBar) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") {
			GameInfo.can_map_update = true;
			popin.PopinManager.getInstance().closePopin("PopinBuild");
		} else if(pEvent.target._name == "nicheTab" && this.currentTab != "nicheTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.niches);
			this.currentTab = "nicheTab";
			this.header.setTexture(this.headerTextures.get("niches"));
			this.icons.get("spaceshipTab").setTextureToNormal();
			this.icons.get("utilitairesTab").setTextureToNormal();
		} else if(pEvent.target._name == "spaceshipTab" && this.currentTab != "spaceshipTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.spacechips);
			this.currentTab = "spaceshipTab";
			this.header.setTexture(this.headerTextures.get("spaceships"));
			this.icons.get("nicheTab").setTextureToNormal();
			this.icons.get("utilitairesTab").setTextureToNormal();
		} else if(pEvent.target._name == "utilitairesTab" && this.currentTab != "utilitairesTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
			this.currentTab = "utilitairesTab";
			this.header.setTexture(this.headerTextures.get("utilitaire"));
			this.icons.get("nicheTab").setTextureToNormal();
			this.icons.get("spaceshipTab").setTextureToNormal();
		} else if(pEvent.target._name.indexOf("buildSoft") != -1) {
			((function($this) {
				var $r;
				var key = pEvent.target._name;
				$r = $this.icons.get(key);
				return $r;
			}(this))).setTextureToNormal();
			var index = Std.parseInt(pEvent.target._name.split("buildSoft")[1]);
			var ressources;
			var article = { };
			var canBuy = true;
			if(this.currentTab == "nicheTab") article = GameInfo.buildMenuArticles.niches[index]; else if(this.currentTab == "spaceshipTab") article = GameInfo.buildMenuArticles.spacechips[index]; else if(this.currentTab == "utilitairesTab") article = GameInfo.buildMenuArticles.utilitaires[index];
			ressources = article.ressources;
			var _g = 0;
			while(_g < ressources.length) {
				var i = ressources[_g];
				++_g;
				if(((function($this) {
					var $r;
					var key1 = i.name;
					$r = GameInfo.ressources.get(key1);
					return $r;
				}(this))).userPossesion < i.quantity) {
					canBuy = false;
					break;
				}
			}
			if(canBuy) {
				var _g1 = 0;
				while(_g1 < ressources.length) {
					var i1 = ressources[_g1];
					++_g1;
					((function($this) {
						var $r;
						var key2 = i1.name;
						$r = GameInfo.ressources.get(key2);
						return $r;
					}(this))).userPossesion -= i1.quantity;
				}
				GameInfo.building_2_build = article.buildingID;
				hud.HudManager.getInstance().updateChildText();
				GameInfo.can_map_update = true;
				popin.PopinManager.getInstance().closePopin("PopinBuild");
				popin.PopinManager.getInstance().updateInventory();
			}
		} else if(pEvent.target._name.indexOf("buildHard") != -1) {
			((function($this) {
				var $r;
				var key3 = pEvent.target._name;
				$r = $this.icons.get(key3);
				return $r;
			}(this))).setTextureToNormal();
			var index1 = Std.parseInt(pEvent.target._name.split("buildHard")[1]);
			var article1 = { };
			if(this.currentTab == "nicheTab") article1 = GameInfo.buildMenuArticles.niches[index1]; else if(this.currentTab == "spaceshipTab") article1 = GameInfo.buildMenuArticles.spacechips[index1]; else if(this.currentTab == "utilitairesTab") article1 = GameInfo.buildMenuArticles.utilitaires[index1];
			if(GameInfo.ressources.get("hardMoney").userPossesion >= article1.hardPrice) {
				GameInfo.ressources.get("hardMoney").userPossesion -= article1.hardPrice;
				hud.HudManager.getInstance().updateChildText();
				GameInfo.building_2_build = article1.buildingID;
				GameInfo.can_map_update = true;
				popin.PopinManager.getInstance().closePopin("PopinBuild");
				popin.PopinManager.getInstance().updateInventory();
			}
		}
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "nicheTab" && this.currentTab != "nicheTab") this.icons.get("nicheTab").setTextureToNormal(); else if(pEvent.target._name == "spaceshipTab" && this.currentTab != "spaceshipTab") this.icons.get("spaceshipTab").setTextureToNormal(); else if(pEvent.target._name == "utilitairesTab" && this.currentTab != "utilitairesTab") this.icons.get("utilitairesTab").setTextureToNormal(); else if(pEvent.target._name.indexOf("buildHard") != -1 || pEvent.target._name.indexOf("buildSoft") != -1) ((function($this) {
			var $r;
			var key = pEvent.target._name;
			$r = $this.icons.get(key);
			return $r;
		}(this))).setTextureToNormal(); else if(pEvent.target._name == "closeButton") this.icons.get("closeButton").setTextureToNormal();
	}
	,__class__: popin.PopinBuild
});
popin.PopinInventory = function(startX,startY) {
	this.textColor = "black";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.01;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInInventory/PopInInventoryArticleBg.png").height;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopInInventory/PopInInventoryBackground.png");
	this.articleHeight /= this.background.height;
	this.addIcon(0,0,"assets/UI/PopInInventory/PopInInventoryBackground.png","contentBackground",this,false);
	this.addIcon(-0.15,-0.1,"assets/UI/PopInInventory/PopInInventoryTitle.png","title",this,false);
	this.addIcon(0.875,-0.025,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addContainer("verticalScroller",this,0,0);
	this.addRessourcestArticles(GameInfo.ressources);
};
$hxClasses["popin.PopinInventory"] = popin.PopinInventory;
popin.PopinInventory.__name__ = ["popin","PopinInventory"];
popin.PopinInventory.__super__ = popin.MyPopin;
popin.PopinInventory.prototype = $extend(popin.MyPopin.prototype,{
	addRessourcestArticles: function(ItemsConfig) {
		var cpt = 0;
		if(this.hasVerticalScrollBar) {
			this.removeVerticalScrollBar();
			this.hasVerticalScrollBar = false;
		}
		var $it0 = ItemsConfig.keys();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			var article = GameInfo.ressources.get(i);
			var y = cpt * (this.articleHeight + this.articleInterline);
			this.addIcon(0.1,0.065 + y,"assets/UI/PopInInventory/PopInInventoryArticleBg.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.135,0.069 + y,article.iconImg,"ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addText(0.40,0.069 + y,"FuturaStdHeavy","15px",article.name,"nameText",this.containers.get("verticalScroller"),this.textColor);
			this.addText(0.4,0.12 + y,"FuturaStdHeavy","15px",article.userPossesion,"titleText",this.containers.get("verticalScroller"),this.textColor);
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.icons.get("contentBackground").height && !this.hasVerticalScrollBar) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") popin.PopinManager.getInstance().closePopin("PopinInventory");
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "closeButton") this.icons.get("closeButton").setTextureToNormal();
	}
	,update: function() {
		this.containers.get("verticalScroller").children = [];
		this.addRessourcestArticles(GameInfo.ressources);
	}
	,__class__: popin.PopinInventory
});
popin.PopinManager = function() {
	this.currentPopinName = null;
	this.childs = new haxe.ds.StringMap();
	PIXI.DisplayObjectContainer.call(this);
};
$hxClasses["popin.PopinManager"] = popin.PopinManager;
popin.PopinManager.__name__ = ["popin","PopinManager"];
popin.PopinManager.getInstance = function() {
	if(popin.PopinManager.instance == null) popin.PopinManager.instance = new popin.PopinManager();
	return popin.PopinManager.instance;
};
popin.PopinManager.__super__ = PIXI.DisplayObjectContainer;
popin.PopinManager.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	updateInventory: function() {
		if(this.isPopinOpen("PopinInventory")) this.childs.get("PopinInventory").update();
	}
	,getCurrentPopinName: function() {
		return this.currentPopinName;
	}
	,isPopinOpen: function(pName) {
		return this.childs.exists(pName);
	}
	,openPopin: function(popinName,pX,pY,buildingAttached) {
		var v = Type.createInstance(Type.resolveClass("popin." + popinName),[pX,pY,buildingAttached]);
		this.childs.set(popinName,v);
		v;
		this.addChild(this.childs.get(popinName));
		if(popinName != "PopinInventory") this.currentPopinName = popinName; else this.currentPopinName = this.currentPopinName;
	}
	,openContextPopin: function(pX,pY,buildingAttached) {
		var v = Type.createInstance(Type.resolveClass("popin." + "PopinUpgrade"),[pX,pY,buildingAttached]);
		this.childs.set("PopinUpgrade",v);
		v;
		buildingAttached.addChild(this.childs.get("PopinUpgrade"));
	}
	,closePopin: function(popinName,buildingAttached) {
		this.childs.get(popinName).destroy();
		if(buildingAttached == null) this.removeChild(this.childs.get(popinName)); else buildingAttached.removeChild(this.childs.get(popinName));
		this.childs.remove(popinName);
		if(popinName == "PopinInventory") this.currentPopinName = this.currentPopinName; else this.currentPopinName = null;
	}
	,closeContextPopin: function() {
		if(this.childs.get("PopinUpgrade") != null) {
			this.childs.get("PopinUpgrade").destroy();
			this.childs.remove("PopinUpgrade");
		}
	}
	,closeCurentPopin: function() {
		if(this.currentPopinName != null) {
			this.childs.get(this.currentPopinName).destroy();
			this.removeChild(this.childs.get(this.currentPopinName));
			this.childs.remove(this.currentPopinName);
			this.currentPopinName = null;
		}
	}
	,closeAllPopin: function() {
		var $it0 = this.childs.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			this.childs.get(key).destroy();
			this.removeChild(this.childs.get(key));
		}
		this.currentPopinName = null;
		this.childs = new haxe.ds.StringMap();
	}
	,destroy: function() {
		this.closeAllPopin();
		Main.getStage().removeChild(this);
		popin.PopinManager.instance = null;
	}
	,__class__: popin.PopinManager
});
popin.PopinMarket = function(startX,startY) {
	this.currentTab = "buyTab";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInMarket/PopInMarketBgArticle.png").height;
	GameInfo.can_map_update = false;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	var _g = new haxe.ds.StringMap();
	_g.set("buy",PIXI.Texture.fromImage("assets/UI/PopInMarket/PopInHeaderBuy.png"));
	_g.set("sell",PIXI.Texture.fromImage("assets/UI/PopInMarket/PopInHeaderSell.png"));
	this.headerTextures = _g;
	this.articleHeight /= this.background.height;
	this.addHeader(0.65,0.05,this.headerTextures.get("buy"));
	this.addIcon(-0.15,-0.15,"assets/UI/PopInMarket/PopInTitleMarket.png","popInTitle",this,false);
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollBackground.png","contentBackground",this,false);
	this.addIcon(-0.02,0.17,"assets/UI/PopInMarket/PopInOngletBuyNormal.png","buyTab",this,true,"assets/UI/PopInMarket/PopInOngletBuyActive.png",true);
	this.addIcon(-0.02,0.29,"assets/UI/PopInMarket/PopInOngletSellNormal.png","sellTab",this,true,"assets/UI/PopInMarket/PopInOngletSellActive.png",true);
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addContainer("verticalScroller",this,0,0);
	this.addMask(this.icons.get("contentBackground").x,this.icons.get("contentBackground").y + 3,this.icons.get("contentBackground").width,this.icons.get("contentBackground").height - 6,this.containers.get("verticalScroller"));
	this.addMarketArticles(GameInfo.ressources);
	this.icons.get("buyTab").setTextureToActive();
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollOverlay.png","scrollOverlay",this,false);
};
$hxClasses["popin.PopinMarket"] = popin.PopinMarket;
popin.PopinMarket.__name__ = ["popin","PopinMarket"];
popin.PopinMarket.__super__ = popin.MyPopin;
popin.PopinMarket.prototype = $extend(popin.MyPopin.prototype,{
	addMarketArticles: function(ItemsConfig) {
		var cpt = 0;
		if(this.hasVerticalScrollBar) {
			this.removeVerticalScrollBar();
			this.hasVerticalScrollBar = false;
		}
		var $it0 = ItemsConfig.keys();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			if(i.indexOf("poudre") == -1) continue;
			var article = GameInfo.ressources.get(i);
			var y = cpt * (this.articleHeight + this.articleInterline);
			this.addIcon(0.115,0.17 + y,"assets/UI/PopInMarket/PopInMarketBgArticle.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.13,0.1875 + y,article.previewImg,"ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addText(0.298,0.18 + y,"FuturaStdHeavy","25px",article.name,"titleText",this.containers.get("verticalScroller"));
			this.addIcon(0.42,0.253 + y,"assets/UI/PopInMarket/PopInMarketNbArticleNormal.png","1unit" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInMarket/PopInMarketNbArticleActive.png",true);
			this.addText(0.45,0.263 + y,"FuturaStdHeavy","25px","x1","1unitText",this.containers.get("verticalScroller"));
			this.addIcon(0.52,0.253 + y,"assets/UI/PopInMarket/PopInMarketNbArticleNormal.png","10unit" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInMarket/PopInMarketNbArticleActive.png",true);
			this.addText(0.535,0.263 + y,"FuturaStdHeavy","25px","x10","10unitText",this.containers.get("verticalScroller"));
			this.addIcon(0.62,0.253 + y,"assets/UI/PopInMarket/PopInMarketNbArticleNormal.png","100unit" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInMarket/PopInMarketNbArticleActive.png",true);
			this.addText(0.625,0.263 + y,"FuturaStdHeavy","25px","x100","100unitText",this.containers.get("verticalScroller"));
			this.addIcon(0.757,0.24 + y,"assets/UI/PopInMarket/PopInMarketValidNormal.png","validBtn" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInMarket/PopInMarketValidActive.png",true);
			this.addIcon(0.31,0.253 + y,GameInfo.ressources.get("fric").iconImg,"SoftRessource",this.containers.get("verticalScroller"),false);
			var cost;
			article.lastQuantityBuy = 0;
			article.lastQuantitySell = 0;
			if(this.currentTab == "buyTab") cost = article.buyCost; else cost = article.sellCost;
			this.addText(0.317,0.3 + y,"FuturaStdHeavy","13px",cost + "","SoftRessourcePrice",this.containers.get("verticalScroller"),"white");
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.icons.get("contentBackground").height && !this.hasVerticalScrollBar) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		var name = pEvent.target._name;
		if(name == "closeButton") {
			GameInfo.can_map_update = true;
			popin.PopinManager.getInstance().closePopin("PopinMarket");
		} else if(name == "buyTab" && this.currentTab != "buyTab") {
			this.currentTab = "buyTab";
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addMarketArticles(GameInfo.ressources);
			this.header.setTexture(this.headerTextures.get("buy"));
			this.icons.get("sellTab").setTextureToNormal();
		} else if(name == "sellTab" && this.currentTab != "sellTab") {
			this.currentTab = "sellTab";
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addMarketArticles(GameInfo.ressources);
			this.header.setTexture(this.headerTextures.get("sell"));
			this.icons.get("buyTab").setTextureToNormal();
		} else if(name.indexOf("1unit") != -1) {
			var index = Std.parseInt(name.split("1unit")[1]);
			this.icons.get("10unit" + index).setTextureToNormal();
			this.icons.get("100unit" + index).setTextureToNormal();
			if(this.currentTab == "buyTab") GameInfo.ressources.get("poudre" + index).lastQuantityBuy = 1; else GameInfo.ressources.get("poudre" + index).lastQuantitySell = 1;
		} else if(name.indexOf("10unit") != -1) {
			var index1 = Std.parseInt(name.split("10unit")[1]);
			this.icons.get("1unit" + index1).setTextureToNormal();
			this.icons.get("100unit" + index1).setTextureToNormal();
			if(this.currentTab == "buyTab") GameInfo.ressources.get("poudre" + index1).lastQuantityBuy = 10; else GameInfo.ressources.get("poudre" + index1).lastQuantitySell = 10;
		} else if(name.indexOf("100unit") != -1) {
			var index2 = Std.parseInt(name.split("100unit")[1]);
			this.icons.get("1unit" + index2).setTextureToNormal();
			this.icons.get("10unit" + index2).setTextureToNormal();
			if(this.currentTab == "buyTab") GameInfo.ressources.get("poudre" + index2).lastQuantityBuy = 100; else GameInfo.ressources.get("poudre" + index2).lastQuantitySell = 100;
		} else if(name.indexOf("validBtn") != -1) {
			var index3 = Std.parseInt(name.split("validBtn")[1]);
			this.icons.get("validBtn" + index3).setTextureToNormal();
			if(this.currentTab == "buyTab") {
				var cost = GameInfo.ressources.get("poudre" + index3).buyCost * GameInfo.ressources.get("poudre" + index3).lastQuantityBuy;
				if(cost <= GameInfo.ressources.get("fric").userPossesion) {
					GameInfo.ressources.get("fric").userPossesion -= cost;
					GameInfo.ressources.get("poudre" + index3).userPossesion += GameInfo.ressources.get("poudre" + index3).lastQuantityBuy;
					console.log(GameInfo.ressources.get("poudre" + index3).userPossesion);
					hud.HudManager.getInstance().updateChildText();
					popin.PopinManager.getInstance().updateInventory();
				}
			} else if(this.currentTab == "sellTab") {
				var cost1 = GameInfo.ressources.get("poudre" + index3).sellCost * GameInfo.ressources.get("poudre" + index3).lastQuantitySell;
				if(GameInfo.ressources.get("poudre" + index3).userPossesion >= GameInfo.ressources.get("poudre" + index3).lastQuantitySell) {
					GameInfo.ressources.get("fric").userPossesion += cost1;
					GameInfo.ressources.get("poudre" + index3).userPossesion -= GameInfo.ressources.get("poudre" + index3).lastQuantitySell;
					hud.HudManager.getInstance().updateChildText();
					popin.PopinManager.getInstance().updateInventory();
				}
			}
		}
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "buyTab" && this.currentTab != "buyTab") this.icons.get("buyTab").setTextureToNormal(); else if(pEvent.target._name == "sellTab" && this.currentTab != "sellTab") this.icons.get("sellTab").setTextureToNormal(); else if(pEvent.target._name.indexOf("validBtn") != -1) {
			var index = Std.parseInt(pEvent.target._name.split("validBtn")[1]);
			this.icons.get("validBtn" + index).setTextureToNormal();
		} else if(pEvent.target._name == "closeButton") this.icons.get("closeButton").setTextureToNormal(); else if(pEvent.target._name.indexOf("1unit") != -1) {
			var index1 = Std.parseInt(pEvent.target._name.split("1unit")[1]);
			this.icons.get("1unit" + index1).setTextureToNormal();
		} else if(pEvent.target._name.indexOf("10unit") != -1) {
			var index2 = Std.parseInt(pEvent.target._name.split("10unit")[1]);
			this.icons.get("10unit" + index2).setTextureToNormal();
		} else if(pEvent.target._name.indexOf("100unit") != -1) {
			var index3 = Std.parseInt(pEvent.target._name.split("100unit")[1]);
			this.icons.get("100unit" + index3).setTextureToNormal();
		}
	}
	,__class__: popin.PopinMarket
});
popin.PopinQuests = function(startX,startY) {
	this.currentTab = "currentQuestsTab";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInQuest/PopInQuestBgArticle.png").height;
	GameInfo.can_map_update = false;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	this.articleHeight /= this.background.height;
	this.addIcon(-0.15,-0.15,"assets/UI/PopInQuest/PopInTitleQuest.png","popInTitle",this,false);
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollBackground.png","contentBackground",this,false);
	this.addIcon(-0.02,0.17,"assets/UI/PopInQuest/PopInQuestOngletEnCoursNormal.png","currentQuestsTab",this,true,"assets/UI/PopInQuest/PopInQuestOngletEnCoursActive.png",true);
	this.addIcon(-0.02,0.29,"assets/UI/PopInQuest/PopInQuestOngletFinishNormal.png","finishedQuestsTab",this,true,"assets/UI/PopInQuest/PopInQuestOngletFinishActive.png",true);
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addContainer("verticalScroller",this,0,0);
	this.addMask(this.icons.get("contentBackground").x,this.icons.get("contentBackground").y + 3,this.icons.get("contentBackground").width,this.icons.get("contentBackground").height - 6,this.containers.get("verticalScroller"));
	this.addBuildArticles(GameInfo.questsArticles.current);
	this.icons.get("currentQuestsTab").setTextureToActive();
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollOverlay.png","scrollOverlay",this,false);
};
$hxClasses["popin.PopinQuests"] = popin.PopinQuests;
popin.PopinQuests.__name__ = ["popin","PopinQuests"];
popin.PopinQuests.__super__ = popin.MyPopin;
popin.PopinQuests.prototype = $extend(popin.MyPopin.prototype,{
	addBuildArticles: function(ItemsConfig) {
		var cpt = 0;
		if(this.hasVerticalScrollBar) {
			this.removeVerticalScrollBar();
			this.hasVerticalScrollBar = false;
		}
		var _g = 0;
		while(_g < ItemsConfig.length) {
			var i = ItemsConfig[_g];
			++_g;
			var y = cpt * (this.articleHeight + this.articleInterline);
			var rewards = i.rewards;
			this.addIcon(0.115,0.175 + y,"assets/UI/PopInQuest/PopInQuestBgArticle.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.13,0.1875 + y,"assets/UI/Icons/Dogs/" + Std.string(i.previewImg) + ".png","ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addText(0.298,0.175 + y,"FuturaStdHeavy","25px",i.title,"titleText",this.containers.get("verticalScroller"));
			this.addText(0.298,0.225 + y,"FuturaStdMedium","12px",i.description,"Description",this.containers.get("verticalScroller"));
			this.addText(0.71,0.215 + y,"FuturaStdHeavy","18px","Récompenses","rewarsText",this.containers.get("verticalScroller"));
			var _g2 = 0;
			var _g1 = rewards.length;
			while(_g2 < _g1) {
				var j = _g2++;
				this.addIcon(0.72 + 0.07 * j,0.287 + y,GameInfo.ressources.get(rewards[j].name).iconImg,"reaward" + j,this.containers.get("verticalScroller"),false);
				this.addText(0.728 + 0.07 * j,0.335 + y,"FuturaStdHeavy","13px",rewards[j].quantity,"rawardQuantity" + j,this.containers.get("verticalScroller"),"white");
			}
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.icons.get("contentBackground").height && !this.hasVerticalScrollBar) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") {
			GameInfo.can_map_update = true;
			popin.PopinManager.getInstance().closePopin("PopinQuests");
		} else if(pEvent.target._name == "currentQuestsTab" && this.currentTab != "currentQuestsTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.questsArticles.current);
			this.currentTab = "currentQuestsTab";
			this.icons.get("finishedQuestsTab").setTextureToNormal();
		} else if(pEvent.target._name == "finishedQuestsTab" && this.currentTab != "finishedQuestsTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.questsArticles.finished);
			this.currentTab = "finishedQuestsTab";
			this.icons.get("currentQuestsTab").setTextureToNormal();
		}
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "currentQuestsTab" && this.currentTab != "currentQuestsTab") this.icons.get("currentQuestsTab").setTextureToNormal(); else if(pEvent.target._name == "finishedQuestsTab" && this.currentTab != "finishedQuestsTab") this.icons.get("finishedQuestsTab").setTextureToNormal();
	}
	,__class__: popin.PopinQuests
});
popin.PopinShop = function(startX,startY) {
	this.currentTab = "softTab";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInShop/PopInShopBgArticle.png").height;
	GameInfo.can_map_update = false;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	var _g = new haxe.ds.StringMap();
	_g.set("softTab",PIXI.Texture.fromImage("assets/UI/PopInShop/PopInHeaderDogflooz.png"));
	_g.set("hardTab",PIXI.Texture.fromImage("assets/UI/PopInShop/PopInHeaderOsDOr.png"));
	this.headerTextures = _g;
	this.articleHeight /= this.background.height;
	this.addHeader(0.65,0.05,this.headerTextures.get("softTab"));
	this.addIcon(-0.15,-0.15,"assets/UI/PopInShop/PopInTitleShop.png","popInTitle",this,false);
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollBackground.png","contentBackground",this,false);
	this.addIcon(0.65,0.875,"assets/UI/PopInShop/PopInShopButtonConfirmNormal.png","confirmBtn",this,true,"assets/UI/PopInShop/PopInShopButtonConfirmActive.png",true);
	this.addIcon(-0.02,0.17,"assets/UI/PopInShop/PopInOngletSoftNormal.png","softTab",this,true,"assets/UI/PopInShop/PopInOngletSoftActive.png",true);
	this.addIcon(-0.02,0.29,"assets/UI/PopInShop/PopInOngletHardNormal.png","hardTab",this,true,"assets/UI/PopInShop/PopInOngletHardActive.png",true);
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addContainer("verticalScroller",this,0,0);
	this.addMask(this.icons.get("contentBackground").x,this.icons.get("contentBackground").y + 3,this.icons.get("contentBackground").width,this.icons.get("contentBackground").height - 6,this.containers.get("verticalScroller"));
	this.addMarketArticles(GameInfo.shopArticles.get("soft"));
	this.icons.get("softTab").setTextureToActive();
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollOverlay.png","scrollOverlay",this,false);
};
$hxClasses["popin.PopinShop"] = popin.PopinShop;
popin.PopinShop.__name__ = ["popin","PopinShop"];
popin.PopinShop.__super__ = popin.MyPopin;
popin.PopinShop.prototype = $extend(popin.MyPopin.prototype,{
	addMarketArticles: function(ItemsConfig) {
		var cpt = 0;
		if(this.hasVerticalScrollBar) {
			this.removeVerticalScrollBar();
			this.hasVerticalScrollBar = false;
		}
		var $it0 = ItemsConfig.iterator();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			var y = cpt * (this.articleHeight + this.articleInterline);
			this.addIcon(0.115,0.17 + y,"assets/UI/PopInShop/PopInShopBgArticle.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.13,0.1875 + y,i.previewImg,"ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addText(0.298,0.18 + y,"FuturaStdHeavy","25px",i.name,"titleText",this.containers.get("verticalScroller"));
			this.addText(0.31,0.24 + y,"FuturaStdMedium","13px",i.text,"titleText",this.containers.get("verticalScroller"));
			this.addIcon(0.757,0.24 + y,"assets/UI/PopInShop/PopInMarketValidNormal.png","validBtn" + cpt,this.containers.get("verticalScroller"),true,"assets/UI/PopInShop/PopInMarketValidActive.png",true);
			this.addText(0.66,0.26 + y,"FuturaStdHeavy","25px",i.price + "€","price",this.containers.get("verticalScroller"));
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.icons.get("contentBackground").height && !this.hasVerticalScrollBar) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		var name = pEvent.target._name;
		if(name == "closeButton") {
			GameInfo.can_map_update = true;
			popin.PopinManager.getInstance().closePopin("PopinShop");
		} else if(name == "softTab" && this.currentTab != "softTab") {
			this.currentTab = "softTab";
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addMarketArticles(GameInfo.shopArticles.get("soft"));
			this.header.setTexture(this.headerTextures.get("softTab"));
			this.icons.get("hardTab").setTextureToNormal();
		} else if(name == "hardTab" && this.currentTab != "hardTab") {
			this.currentTab = "hardTab";
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addMarketArticles(GameInfo.shopArticles.get("hard"));
			this.header.setTexture(this.headerTextures.get("hardTab"));
			this.icons.get("softTab").setTextureToNormal();
		} else if(name.indexOf("validBtn") != -1) {
			var index = Std.parseInt(name.split("validBtn")[1]);
			if(this.currentTab == "softTab") {
			} else if(this.currentTab == "hardTab") {
			}
		} else if(name == "confirmBtn") this.icons.get(name).setTextureToNormal();
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "softTab" && this.currentTab != "softTab") this.icons.get("softTab").setTextureToNormal(); else if(pEvent.target._name == "hardTab" && this.currentTab != "hardTab") this.icons.get("hardTab").setTextureToNormal(); else if(pEvent.target._name.indexOf("validBtn") != -1) {
			var index = Std.parseInt(pEvent.target._name.split("validBtn")[1]);
			this.icons.get("validBtn" + index).setTextureToNormal();
		} else if(pEvent.target._name == "closeButton") this.icons.get("closeButton").setTextureToNormal();
	}
	,__class__: popin.PopinShop
});
popin.PopinUpgrade = function(startX,startY,buildingAttached) {
	if(buildingAttached == null) {
		console.log("ERROR : NO BUILDING REF PASSED");
		return;
	}
	popin.MyPopin.call(this,startX,startY,"assets/UI/HudBuildingContextBar.png");
	this.buildingRef = buildingAttached;
	this.addIcon(0.75,0.05,"HudIconBuildNormal.png","upgradeBtn",this,true,"HudIconBuildActive.png",true);
	this.icons.get("upgradeBtn").scale.set(0.5,0.5);
};
$hxClasses["popin.PopinUpgrade"] = popin.PopinUpgrade;
popin.PopinUpgrade.__name__ = ["popin","PopinUpgrade"];
popin.PopinUpgrade.__super__ = popin.MyPopin;
popin.PopinUpgrade.prototype = $extend(popin.MyPopin.prototype,{
	childClick: function(pEvent) {
		if(pEvent.target._name == "upgradeBtn") {
			if(GameInfo.ressources.get("fric").userPossesion > 0) {
				GameInfo.ressources.get("fric").userPossesion--;
				this.buildingRef.upgrade();
				GameInfo.is_building_context_pop_open = false;
				popin.PopinManager.getInstance().closeContextPopin();
			}
		}
	}
	,childUpOutside: function(pEvent) {
		if(pEvent.target._name == "upgradeBtn") this.icons.get("upgradeBtn").setTextureToNormal();
	}
	,destroy: function() {
		Main.getInstance().removeEventListener("Event.GAME_LOOP",$bind(this,this.scroll));
		this.buildingRef.removeChild(this);
	}
	,__class__: popin.PopinUpgrade
});
popin.PopinWorkshop = function(startX,startY,ref) {
	if(ref == null) ref = "hangarNamok";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInQuest/PopInQuestBgArticle.png").height;
	GameInfo.can_map_update = false;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	this.buildingRef = ref;
	var _g = new haxe.ds.StringMap();
	_g.set("atelier",PIXI.Texture.fromImage("assets/UI/PopInWorkshop/PopInWorkshopHeader.png"));
	this.headerTextures = _g;
	this.articleHeight /= this.background.height;
	this.addHeader(0.65,0.05,this.headerTextures.get("atelier"));
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png",true);
	this.addIcon(-0.15,-0.15,"assets/UI/PopInWorkshop/PopInTitleWorkshop.png","popInTitle",this,false);
	this.addIcon(-0.4,0.27,"assets/Dogs/DogHangarWorkshop.png","dog",this,false);
};
$hxClasses["popin.PopinWorkshop"] = popin.PopinWorkshop;
popin.PopinWorkshop.__name__ = ["popin","PopinWorkshop"];
popin.PopinWorkshop.__super__ = popin.MyPopin;
popin.PopinWorkshop.prototype = $extend(popin.MyPopin.prototype,{
	addBuyState: function() {
		this.addIcon(0.1,0.15,GameInfo.buildings.get(this.buildingRef).previewImg,"destinationPreview",this,false);
		this.addIcon(0.1,0.39,"assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png","destinationTextBg",this,false);
		this.addText(0.105,0.41,"FuturaStdHeavy","14px",GameInfo.buildings.get(this.buildingRef).destination,"description",this,"white");
		var _g1 = 0;
		var _g = GameInfo.buildings.get(this.buildingRef).level;
		while(_g1 < _g) {
			var i = _g1++;
			var y = i * (this.articleHeight + this.articleInterline);
			var article = GameInfo.buildings.get(this.buildingRef).spaceships[i];
			var ressources = article.ressources;
			this.addIcon(0.115,0.175 + y,"assets/UI/PopInWorkshop/PopInWorkshopArticleBG.png","articleBase",this,false);
			this.addIcon(0.13,0.1875 + y,"assets/UI/Icons/Dogs/" + Std.string(article.previewImg) + ".png","ArticlePreview",this,false);
			this.addText(0.298,0.175 + y,"FuturaStdHeavy","25px",article.title,"titleText",this);
			var _g3 = 0;
			var _g2 = ressources.length;
			while(_g3 < _g2) {
				var j = _g3++;
				this.addIcon(0.72 + 0.07 * j,0.287 + y,GameInfo.ressources.get(ressources[j].name).iconImg,"ressource" + j,this,false);
				this.addText(0.728 + 0.07 * j,0.335 + y,"FuturaStdHeavy","13px",ressources[j].quantity,"ressourceQunatity" + j,this,"white");
			}
		}
	}
	,childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") {
			GameInfo.can_map_update = true;
			popin.PopinManager.getInstance().closePopin("PopinWorkshop");
		}
	}
	,__class__: popin.PopinWorkshop
});
var scenes = {};
scenes.GameScene = function() {
	PIXI.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	new utils.game.InputInfos(true,true,true);
	utils.game.InputInfos.mouse_x = Std["int"](utils.system.DeviceCapabilities.get_width() * 0.5);
	utils.game.InputInfos.mouse_y = Std["int"](utils.system.DeviceCapabilities.get_height() * 0.5);
	new IsoMap("assets/BG.jpg",64,64,128,64);
	this.addChild(IsoMap.singleton);
	this.addChild(hud.HudManager.getInstance());
	this.addChild(popin.PopinManager.getInstance());
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.doAction));
	Main.getInstance().addEventListener("Event.RESIZE",$bind(this,this.resize));
};
$hxClasses["scenes.GameScene"] = scenes.GameScene;
scenes.GameScene.__name__ = ["scenes","GameScene"];
scenes.GameScene.getInstance = function() {
	if(scenes.GameScene.instance == null) scenes.GameScene.instance = new scenes.GameScene();
	return scenes.GameScene.instance;
};
scenes.GameScene.__super__ = PIXI.DisplayObjectContainer;
scenes.GameScene.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	doAction: function() {
	}
	,resize: function() {
	}
	,__class__: scenes.GameScene
});
scenes.LoaderScene = function() {
	this.textStyle = { font : "15px FuturaStdHeavy", fill : "white"};
	this.phraseInterval = 3000;
	this.randomPhrases = ["Affinage des fouets","Mise en suspend des congés","Ajout de Rambo IV au cinéma","Relecture des commérages de Gertrude","Automatisation des automates","Peinture des tomates","Wow !","Much Game !","Such Genius","Instauration de la semaine de 169 heures","Toilettage du personnel","Financement de dictatures","Mise en place de la surveillance de masse"];
	PIXI.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	this.background = new PIXI.TilingSprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/IconsSplash.jpg"),utils.system.DeviceCapabilities.get_width(),utils.system.DeviceCapabilities.get_height());
	var dogeTextures = [];
	var _g = 0;
	while(_g < 12) {
		var i = _g++;
		dogeTextures.push(PIXI.Texture.fromFrame("doge-run_" + i));
	}
	this.doge = new PIXI.MovieClip(dogeTextures);
	var glowTextures = [];
	var _g1 = 0;
	while(_g1 < 5) {
		var i1 = _g1++;
		glowTextures.push(PIXI.Texture.fromFrame("planetGlow_" + i1));
	}
	this.planetGlow = new PIXI.MovieClip(glowTextures);
	this.planet = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/Planet.png"));
	this.planetLight = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/PlanetLight.png"));
	this.title = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/Title.png"));
	this.loadingBar = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/LoadingFillBar.png"));
	this.loadingFillStart = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/LoadingFill01.png"));
	this.loadingFillEnd = new PIXI.Sprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/LoadingFill03.png"));
	this.loadingFillMidlle = new PIXI.TilingSprite(PIXI.Texture.fromFrame("assets/UI/SplashScreen/LoadingFill02.png"),350,this.loadingFillStart.height);
	this.phraseText = new PIXI.Text("",this.textStyle);
	this.changePhrase();
	this.title.anchor.set(0.5,0.5);
	this.planet.anchor.set(0.5,0.5);
	this.planetGlow.anchor.set(0.5,0.5);
	this.doge.anchor.set(0.5,0.5);
	this.planetLight.anchor.set(0.5,0.5);
	this.loadingBar.anchor.set(0.5,0.5);
	this.loadingFillMidlle.anchor.set(0,0.5);
	this.loadingFillStart.anchor.set(0,0.5);
	this.loadingFillEnd.anchor.set(0,0.5);
	this.phraseText.anchor.set(0.5,0.5);
	this.onResize();
	this.addChild(this.background);
	this.addChild(this.title);
	this.addChild(this.planet);
	this.addChild(this.planetLight);
	this.addChild(this.doge);
	this.addChild(this.planetGlow);
	this.addChild(this.loadingBar);
	this.addChild(this.loadingFillStart);
	this.addChild(this.loadingFillMidlle);
	this.addChild(this.loadingFillEnd);
	this.addChild(this.phraseText);
	this.doge.animationSpeed = 0.25;
	this.planetGlow.animationSpeed = 0.05;
	this.doge.play();
	this.planetGlow.play();
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.animation));
	Main.getInstance().addEventListener("Event.RESIZE",$bind(this,this.onResize));
	var timer = new haxe.Timer(this.phraseInterval);
	timer.run = $bind(this,this.changePhrase);
};
$hxClasses["scenes.LoaderScene"] = scenes.LoaderScene;
scenes.LoaderScene.__name__ = ["scenes","LoaderScene"];
scenes.LoaderScene.getInstance = function() {
	if(scenes.LoaderScene.instance == null) scenes.LoaderScene.instance = new scenes.LoaderScene();
	return scenes.LoaderScene.instance;
};
scenes.LoaderScene.__super__ = PIXI.DisplayObjectContainer;
scenes.LoaderScene.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	animation: function() {
		this.planet.rotation -= 0.03;
		if(this.currentLoadFillWidth != GameInfo.loaderCompletion) this.loadBarFill();
	}
	,onResize: function() {
		this.background.width = utils.system.DeviceCapabilities.get_width();
		this.background.height = utils.system.DeviceCapabilities.get_height();
		this.title.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.3));
		this.planet.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 1.05));
		this.planetGlow.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.7));
		this.doge.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.65));
		this.planetLight.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.86));
		this.loadingBar.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.9));
		this.loadingFillStart.position.set(this.loadingBar.x - this.loadingBar.width / 2 + 3 | 0,this.loadingBar.y);
		this.loadingFillMidlle.position.set(this.loadingFillStart.x + this.loadingFillStart.width,this.loadingFillStart.y);
		this.loadingFillEnd.position.set(this.loadingFillMidlle.x + this.loadingFillMidlle.width,this.loadingFillStart.y);
		this.phraseText.position.set(Std["int"](utils.system.DeviceCapabilities.get_width() / 2),Std["int"](utils.system.DeviceCapabilities.get_height() * 0.95));
	}
	,loadBarFill: function() {
		this.maxLoadFillWidth = this.loadingBar.width - (this.loadingFillStart.width + 3) - this.loadingFillEnd.width;
		this.loadingFillMidlle.width = GameInfo.loaderCompletion * this.maxLoadFillWidth;
		this.loadingFillEnd.position.set(this.loadingFillMidlle.x + this.loadingFillMidlle.width,this.loadingFillStart.y);
	}
	,changePhrase: function() {
		this.phraseText.setText(this.randomPhrases[Std["int"](Math.random() * (this.randomPhrases.length - 1))]);
	}
	,__class__: scenes.LoaderScene
});
scenes.ScenesManager = function() {
};
$hxClasses["scenes.ScenesManager"] = scenes.ScenesManager;
scenes.ScenesManager.__name__ = ["scenes","ScenesManager"];
scenes.ScenesManager.getInstance = function() {
	if(scenes.ScenesManager.instance == null) scenes.ScenesManager.instance = new scenes.ScenesManager();
	return scenes.ScenesManager.instance;
};
scenes.ScenesManager.prototype = {
	loadScene: function(sceneName) {
		if(this.isThereAScene) Main.getStage().removeChild(this.currentScene);
		this.currentScene = Type.createInstance(Type.resolveClass("scenes." + sceneName),[]);
		Main.getStage().addChild(this.currentScene);
		this.isThereAScene = true;
	}
	,__class__: scenes.ScenesManager
};
utils.events.Event = function(pType) {
	this.type = pType;
};
$hxClasses["utils.events.Event"] = utils.events.Event;
utils.events.Event.__name__ = ["utils","events","Event"];
utils.events.Event.prototype = {
	formatToString: function(pArgs) {
		var lCompleteClassName = Type.getClassName(Type.getClass(this));
		var lPackage = lCompleteClassName.lastIndexOf(".");
		var lClassName;
		if(lPackage == -1) lClassName = lCompleteClassName; else lClassName = HxOverrides.substr(lCompleteClassName,lPackage + 1,null);
		var lTxt = "[" + lClassName;
		var _g1 = 0;
		var _g = pArgs.length;
		while(_g1 < _g) {
			var i = _g1++;
			lTxt += " " + pArgs[i] + "=" + Std.string(Reflect.field(this,pArgs[i]));
		}
		return lTxt + "]";
	}
	,toString: function() {
		return this.formatToString(["type"]);
	}
	,__class__: utils.events.Event
};
utils.game = {};
utils.game.InputInfos = function(listen_click,listen_mousemove,listen_wheel) {
	utils.game.InputInfos.singleton = this;
	utils.game.InputInfos.mouse_x = 0;
	utils.game.InputInfos.mouse_y = 0;
	utils.game.InputInfos.last_mouse_down_x = 0;
	utils.game.InputInfos.last_mouse_down_y = 0;
	utils.game.InputInfos.last_mouse_up_x = 0;
	utils.game.InputInfos.last_mouse_up_y = 0;
	utils.game.InputInfos.mouse_wheel_dir = 0;
	utils.game.InputInfos.is_mouse_down = false;
	if(listen_click) {
		window.onmousedown = $bind(this,this._on_mousedown);
		window.onmouseup = $bind(this,this._on_mouseup);
	}
	if(listen_mousemove) window.onmousemove = $bind(this,this._on_mousemove);
	if(listen_wheel) window.addEventListener("wheel",$bind(this,this._on_wheel),false);
};
$hxClasses["utils.game.InputInfos"] = utils.game.InputInfos;
utils.game.InputInfos.__name__ = ["utils","game","InputInfos"];
utils.game.InputInfos.prototype = {
	_on_mousedown: function(pData) {
		utils.game.InputInfos.is_mouse_down = true;
		utils.game.InputInfos.last_mouse_down_x = pData.clientX;
		utils.game.InputInfos.last_mouse_down_y = pData.clientY;
	}
	,_on_mouseup: function(pData) {
		utils.game.InputInfos.is_mouse_down = false;
		utils.game.InputInfos.last_mouse_up_x = pData.clientX;
		utils.game.InputInfos.last_mouse_up_y = pData.clientY;
	}
	,_on_mousemove: function(pData) {
		utils.game.InputInfos.mouse_x = pData.clientX;
		utils.game.InputInfos.mouse_y = pData.clientY;
	}
	,_on_wheel: function(pData) {
		pData.preventDefault();
		if(pData.deltaY < 0) utils.game.InputInfos.mouse_wheel_dir = -1; else utils.game.InputInfos.mouse_wheel_dir = 1;
	}
	,__class__: utils.game.InputInfos
};
utils.game.IsoTools = function() { };
$hxClasses["utils.game.IsoTools"] = utils.game.IsoTools;
utils.game.IsoTools.__name__ = ["utils","game","IsoTools"];
utils.game.IsoTools.cell_col = function(cell_index,cols_nb) {
	return (cell_index % cols_nb - (cell_index / cols_nb | 0) + cols_nb - 1) * 0.5;
};
utils.game.IsoTools.cell_row = function(cell_index,cols_nb) {
	return (cell_index % cols_nb + (cell_index / cols_nb | 0)) * 0.5;
};
utils.game.IsoTools.cell_x = function(col,cell_w,offset_x) {
	return col * cell_w + offset_x | 0;
};
utils.game.IsoTools.cell_y = function(row,cell_h,offset_y) {
	return row * cell_h + offset_y | 0;
};
utils.game.IsoTools.cell_index_from_cr = function(col,row,cols_nb) {
	return (row + col - cols_nb * 0.5 + 0.5 | 0) + (row - col + cols_nb * 0.5 - 0.5 | 0) * cols_nb;
};
utils.game.IsoTools.cell_index_from_xy = function(x,y,offset_x,offset_y,cell_w,cell_h,cols_nb) {
	var nX = (x - offset_x) / cell_w;
	var nY = (y - offset_y) / cell_h;
	return (nY + nX - cols_nb * 0.5 | 0) + (nY - nX + cols_nb * 0.5 | 0) * cols_nb;
};
utils.game.IsoTools.is_inside_map = function(x,y,offset_x,offset_y,cell_w,cell_h,cells_nb,cols_nb) {
	var p0_x = Std["int"](offset_x + utils.game.IsoTools.cell_col(cells_nb - cols_nb,cols_nb) * cell_w);
	var p0_y = Std["int"](offset_y + utils.game.IsoTools.cell_row(cells_nb - cols_nb,cols_nb) * cell_h + cell_h * 0.5);
	var p1_x = Std["int"](offset_x + utils.game.IsoTools.cell_col(0,cols_nb) * cell_w + cell_w * 0.5);
	var p1_y = Std["int"](offset_y + utils.game.IsoTools.cell_row(0,cols_nb) * cell_h);
	var p2_x = Std["int"](offset_x + utils.game.IsoTools.cell_col(cols_nb - 1,cols_nb) * cell_w + cell_w);
	var p2_y = Std["int"](offset_y + utils.game.IsoTools.cell_row(cols_nb - 1,cols_nb) * cell_h + cell_h * 0.5);
	var p3_x = Std["int"](offset_x + utils.game.IsoTools.cell_col(cells_nb - 1,cols_nb) * cell_w + cell_w * 0.5);
	var p3_y = Std["int"](offset_y + utils.game.IsoTools.cell_row(cells_nb - 1,cols_nb) * cell_h + cell_h);
	return (p1_x - p0_x) * (y - p0_y) - (p1_y - p0_y) * (x - p0_x) > 0 && (p2_x - p1_x) * (y - p1_y) - (p2_y - p1_y) * (x - p1_x) > 0 && (p3_x - p2_x) * (y - p2_y) - (p3_y - p2_y) * (x - p2_x) > 0 && (p0_x - p3_x) * (y - p3_y) - (p0_y - p3_y) * (x - p3_x) > 0;
};
utils.game.IsoTools.all_map_pts_xy = function(offset_x,offset_y,cell_w,cell_h,cells_nb,cols_nb) {
	var pts = [];
	var i = 0;
	while(i < cells_nb) {
		pts[i] = { x0 : Std["int"](offset_x + utils.game.IsoTools.cell_col(i,cols_nb) * cell_w), y0 : Std["int"](offset_y + utils.game.IsoTools.cell_row(i,cols_nb) * cell_h + cell_h * 0.5)};
		pts[i].x1 = pts[i].x0 + cell_w * 0.5 | 0;
		pts[i].y1 = pts[i].y0 - cell_h * 0.5 | 0;
		pts[i].x2 = pts[i].x0 + cell_w;
		pts[i].y2 = pts[i].y0;
		pts[i].x3 = pts[i].x1;
		pts[i].y3 = pts[i].y0 + cell_h * 0.5 | 0;
		i++;
	}
	return pts;
};
utils.system = {};
utils.system.DeviceCapabilities = function() { };
$hxClasses["utils.system.DeviceCapabilities"] = utils.system.DeviceCapabilities;
utils.system.DeviceCapabilities.__name__ = ["utils","system","DeviceCapabilities"];
utils.system.DeviceCapabilities.get_height = function() {
	return window.innerHeight | 0;
};
utils.system.DeviceCapabilities.get_width = function() {
	return window.innerWidth | 0;
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
buildings.Building.CASINO = 1;
buildings.Building.EGLISE = 2;
buildings.Building.HANGAR_BLEU = 3;
buildings.Building.HANGAR_CYAN = 4;
buildings.Building.HANGAR_JAUNE = 5;
buildings.Building.HANGAR_ROUGE = 6;
buildings.Building.HANGAR_VERT = 7;
buildings.Building.HANGAR_VIOLET = 8;
buildings.Building.LABO = 9;
buildings.Building.NICHE = 10;
buildings.Building.PAS_DE_TIR = 11;
buildings.Building.ENTREPOT = 12;
buildings.Building.MUSEE = 13;
buildings.Building.LVL_1 = 256;
buildings.Building.LVL_2 = 512;
buildings.Building.LVL_3 = 768;
GameInfo.ressources = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("poudre0",{ name : "PLPP Yellow", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconYellowMineral.png", userPossesion : 15000, buyCost : 10, sellCost : 5, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("poudre1",{ name : "PLPP Green", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconGreenMineral.png", userPossesion : 15000, buyCost : 25, sellCost : 10, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("poudre2",{ name : "PLPP Cyan", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconCyanMineral.png", userPossesion : 15000, buyCost : 50, sellCost : 25, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("poudre3",{ name : "PLPP Blue", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconBlueMineral.png", userPossesion : 15000, buyCost : 100, sellCost : 40, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("poudre4",{ name : "PLPP Purple", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconPurpleMineral.png", userPossesion : 15000, buyCost : 300, sellCost : 200, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("poudre5",{ name : "PLPP Red", previewImg : "assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png", iconImg : "assets/UI/Icons/IconsRessources/IconRedMineral.png", userPossesion : 15000, buyCost : 1000, sellCost : 700, lastQuantityBuy : 0, lastQuantitySell : 0});
	_g.set("fric",{ name : "Dogeflooz", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png", iconImg : "assets/UI/Icons/IconsRessources/IconDogeflooz.png", userPossesion : 5000});
	_g.set("hardMoney",{ name : "Os D'or", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png", iconImg : "assets/UI/Icons/IconsRessources/IconOsDor.png", userPossesion : 15000});
	$r = _g;
	return $r;
}(this));
GameInfo.questsArticles = { current : [{ previewImg : "IconDogNiche", title : "Première niche", description : "Pas de niches, pas d'employés.Pas d'employés, pas\nde fusées.Pas de fusées... pas de fusées.\nOuvrez-donc le menu de construction.\nPuis achetez et construisez une niche !", rewards : [{ name : "fric", quantity : "100"},{ name : "poudre0", quantity : "10"}]},{ previewImg : "IconDogWorkshop", title : "Premier atelier", description : "Les ateliers servent à construire les fussées.\nPour l'instant vos pauvres employés s'ennuient à mourir.\nSoyez gentil et donnez leur du travail !\nPour rappel, les batiments peuvent être\nachetés depuis le menu de construction", rewards : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"}]},{ previewImg : "IconDogWorkshop", title : "Première fusée", description : "Construire votre première fusée est maintenant possible !\nCliquez sur votre atelier et comencez la\n construction de la fusée. N'oubliez pas de fouett..\n*hum* motiver vos employés en cliquant sur\n l'icone dans le atelier", rewards : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"}]},{ previewImg : "IconDogAstro", title : "La conquète de l'espace !", description : "Votre première fusée est prète à partir !\nVous n'avez plus qu'a appuyer sur le gros\nboutton vert pour la lancer. Ca ne devrait pas être\ntrop compliqué non ?", rewards : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"}]},{ previewImg : "IconDogCasino", title : "Black jack and...", description : "Vos employés veulent se détendre, vous voulez\n vous remplir les poches.\nUn casino semble le parfait compromis", rewards : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"}]},{ previewImg : "IconDogMusee", title : "La culture ça rapporte", description : "Les artefacts que vous trouvez sur les planètes\nsont incroyablement rares Et comme ce qui est\nrare est cher, les billets ne sont pas donnés. Entre la\nboutique de souvenirs et les entrées, vous allez\nencaisser sec !", rewards : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"}]}], finished : { }};
GameInfo.shopArticles = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("soft",(function($this) {
		var $r;
		var _g1 = new haxe.ds.StringMap();
		_g1.set("Dogeflooz1",{ name : "Dogeflooz x5000", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png", text : "Besoin d'un petit coup de boost ?\nUn peu juste pour le loyer ce mois ci ?\nLe pack NoobDoge est fait pour vous !", price : 1});
		_g1.set("Dogeflooz2",{ name : "Dogeflooz2 x50 000", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Dogeflooz.png", text : "Il y a des choses qui ne s'achètent pas\nPour tout le reste, il y a le Dogeflooz", price : 5});
		_g1.set("Dogeflooz3",{ name : "Dogeflooz2 x500 000", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Dogeflooz.png", text : "Une banque qui appartient a son\nDogeFlooz ça change tout", price : 25});
		_g1.set("Dogeflooz4",{ name : "Dogeflooz2 x5 000 000", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Dogeflooz.png", text : "En panne de slogans connus,\nrevenez plus tard", price : 99});
		$r = _g1;
		return $r;
	}($this)));
	_g.set("hard",(function($this) {
		var $r;
		var _g2 = new haxe.ds.StringMap();
		_g2.set("Os1",{ name : "Os d'or", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png", text : "Tout ce qui brille n'est pas de l'or\nMais ces os le sont bien", price : 1});
		_g2.set("Os2",{ name : "Os d'or x50", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Os.png", text : "Avec tout cet or, vous allez conquérir\nle monde, que dis-je l'espace !", price : 5});
		_g2.set("Os3",{ name : "Os d'or x500", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Os.png", text : "Aucune description ne poura définir\nprécisément la qualitée de ce pack", price : 25});
		_g2.set("Os4",{ name : "Os d'or x5000", previewImg : "assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Os.png", text : "Ce pack ce passe d'une description\ncar il se suffit à lui même", price : 99});
		$r = _g2;
		return $r;
	}($this)));
	$r = _g;
	return $r;
}(this));
GameInfo.buildMenuArticles = { niches : [{ buildingID : buildings.Building.NICHE, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png", title : "Niche en Bois", description : "L'association des travailleurs canins (l'ATC) impose un logement de fonction.\nDonc pour faire court niches = employés.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]}], spacechips : [{ buildingID : buildings.Building.HANGAR_JAUNE, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png", title : "Atelier Destination SprungField", description : "Boite magique où les fusées sont assemblées avec amour et bonne humeur.\nToute les rumeur au sujet des coups de fouet électrique ne sont que calomnies.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre2", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.HANGAR_VERT, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png", title : "Atelier Destination Modor", description : "Cet atelier construit des fusées grâce au pouvoir de l’amitié et à des techniques\n de management éprouvés.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre5", quantity : 250}]},{ buildingID : buildings.Building.HANGAR_CYAN, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png", title : "Atelier Destination Namok", description : "Dans cet atelier les employés sont les plus heureux au monde.\nLes semaines de 169 heures ne sont bien sur qu'un mythe.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre3", quantity : 10},{ name : "poudre4", quantity : 25}]},{ buildingID : buildings.Building.HANGAR_BLEU, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png", title : "Atelier Destination Terre", description : "Dans cet atelier, aucun incident n'a jamais été rapporté à la direction\net ce n'est absolument pas par crainte de représailles.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.HANGAR_VIOLET, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png", title : "Atelier Destination Wundërland", description : "Les soupçons des conséquences mortelles liés à la manipulation\n des moteurs à Dogetonium ont été réfutés par le professeur Van-Du.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.HANGAR_ROUGE, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png", title : "Atelier Destination StarWat", description : "Cet atelier utilise uniquement des huiles écologiques.\nQui ne sont en aucun cas faites a partir de travailleurs retraités.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]}], utilitaires : [{ buildingID : buildings.Building.CASINO, previewImg : "assets/UI/Icons/Buildings/popInBuiltArticlePreviewCasino.png", title : "Casino", description : "Un établissement haut de gamme qui ne propose que des jeux honnêtes\npermettant à nos fiers travailleurs de se détendre.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.EGLISE, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png", title : "Église", description : "Une modeste chapelle où nos employés implorent le grand manitou\nde nous accorder des finances prospères.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.ENTREPOT, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png", title : "Entrepot", description : "Les Entrepôts servent à stocker toutes les ressources physiques,\net absolument pas à faire un trafic de substances douteuses.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.LABO, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewLabo.png", title : "Labo", description : "Les labos servent à faire avancer la recherche.\nNos chiens ont une idée de ce qu'il font ne vous en faites pas.", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]},{ buildingID : buildings.Building.MUSEE, previewImg : "assets/UI/Icons/Buildings/PopInBuiltArticlePreviewMusee.png", title : "Musée", description : "Le Mussee est l'endroit ou vous présentez vos artefacts aliens au monde.\nEt en plus ça rapporte un max", hardPrice : 3, ressources : [{ name : "fric", quantity : 1000},{ name : "poudre0", quantity : 10},{ name : "poudre1", quantity : 25}]}]};
GameInfo.buildings = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("hangarNamok",{ destination : "Namok", previewImg : "assets/UI/Icons/Planet/IconNamek.png", level : 1, ressources : [{ name : "fric", quantity : "1000"},{ name : "poudre0", quantity : "10"},{ name : "poudre1", quantity : "25"}]});
	$r = _g;
	return $r;
}(this));
GameInfo.loaderCompletion = 0;
GameInfo.dogeNumber = 20;
GameInfo.dogeMaxNumber = 25;
GameInfo.stockPercent = 50;
GameInfo.building_2_build = buildings.Building.PAS_DE_TIR;
GameInfo.can_map_update = true;
GameInfo.is_building_context_pop_open = false;
GameInfo.BUILDINGS_IMG_FOLDER_PATH = "assets/Buildings/";
GameInfo.BUILDINGS_IMG_EXTENSION = ".png";
GameInfo.BUILDINGS_CONFIG = (function($this) {
	var $r;
	var _g = new haxe.ds.IntMap();
	_g.set(buildings.Building.CASINO | buildings.Building.LVL_1,{ width : 3, height : 3, building_time : 30, frames_nb : 25, img : "CasinoLv1"});
	_g.set(buildings.Building.CASINO | buildings.Building.LVL_2,{ width : 3, height : 3, building_time : 60, frames_nb : 18, img : "CasinoLv2"});
	_g.set(buildings.Building.CASINO | buildings.Building.LVL_3,{ width : 3, height : 3, building_time : 90, frames_nb : 12, img : "CasinoLv3"});
	_g.set(buildings.Building.EGLISE | buildings.Building.LVL_1,{ width : 3, height : 3, building_time : 30, frames_nb : 13, img : "EgliseLv1"});
	_g.set(buildings.Building.EGLISE | buildings.Building.LVL_2,{ width : 3, height : 3, building_time : 60, frames_nb : 16, img : "EgliseLv2"});
	_g.set(buildings.Building.EGLISE | buildings.Building.LVL_3,{ width : 3, height : 3, building_time : 90, frames_nb : 16, img : "EgliseLv3"});
	_g.set(buildings.Building.HANGAR_BLEU | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarBleuLv1"});
	_g.set(buildings.Building.HANGAR_BLEU | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarBleuLv2"});
	_g.set(buildings.Building.HANGAR_BLEU | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarBleuLv3"});
	_g.set(buildings.Building.HANGAR_CYAN | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarCyanLv1"});
	_g.set(buildings.Building.HANGAR_CYAN | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarCyanLv2"});
	_g.set(buildings.Building.HANGAR_CYAN | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarCyanLv3"});
	_g.set(buildings.Building.HANGAR_JAUNE | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarJauneLv1"});
	_g.set(buildings.Building.HANGAR_JAUNE | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarJauneLv2"});
	_g.set(buildings.Building.HANGAR_JAUNE | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarJauneLv3"});
	_g.set(buildings.Building.HANGAR_ROUGE | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarRougeLv1"});
	_g.set(buildings.Building.HANGAR_ROUGE | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarRougeLv2"});
	_g.set(buildings.Building.HANGAR_ROUGE | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarRougeLv3"});
	_g.set(buildings.Building.HANGAR_VERT | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarVertLv1"});
	_g.set(buildings.Building.HANGAR_VERT | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarVertLv2"});
	_g.set(buildings.Building.HANGAR_VERT | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarVertLv3"});
	_g.set(buildings.Building.HANGAR_VIOLET | buildings.Building.LVL_1,{ width : 4, height : 2, building_time : 30, frames_nb : 1, img : "HangarVioletLv1"});
	_g.set(buildings.Building.HANGAR_VIOLET | buildings.Building.LVL_2,{ width : 4, height : 2, building_time : 60, frames_nb : 1, img : "HangarVioletLv2"});
	_g.set(buildings.Building.HANGAR_VIOLET | buildings.Building.LVL_3,{ width : 4, height : 2, building_time : 90, frames_nb : 1, img : "HangarVioletLv3"});
	_g.set(buildings.Building.LABO | buildings.Building.LVL_1,{ width : 2, height : 2, building_time : 30, frames_nb : 1, img : "LaboLv1"});
	_g.set(buildings.Building.LABO | buildings.Building.LVL_2,{ width : 2, height : 2, building_time : 60, frames_nb : 1, img : "LaboLv2"});
	_g.set(buildings.Building.LABO | buildings.Building.LVL_3,{ width : 3, height : 3, building_time : 90, frames_nb : 1, img : "LaboLv3"});
	_g.set(buildings.Building.NICHE | buildings.Building.LVL_1,{ width : 1, height : 1, building_time : 30, frames_nb : 11, img : "NicheLv1"});
	_g.set(buildings.Building.NICHE | buildings.Building.LVL_2,{ width : 1, height : 1, building_time : 60, frames_nb : 33, img : "NicheLv2"});
	_g.set(buildings.Building.NICHE | buildings.Building.LVL_3,{ width : 1, height : 1, building_time : 90, frames_nb : 18, img : "NicheLv3"});
	_g.set(buildings.Building.PAS_DE_TIR | buildings.Building.LVL_1,{ width : 5, height : 5, building_time : 5, frames_nb : 23, img : "PasdetirLv1"});
	_g.set(buildings.Building.PAS_DE_TIR | buildings.Building.LVL_2,{ width : 5, height : 5, building_time : 60, frames_nb : 12, img : "PasdetirLv2"});
	_g.set(buildings.Building.PAS_DE_TIR | buildings.Building.LVL_3,{ width : 5, height : 5, building_time : 90, frames_nb : 7, img : "PasdetirLv3"});
	_g.set(buildings.Building.ENTREPOT | buildings.Building.LVL_1,{ width : 2, height : 2, building_time : 30, frames_nb : 4, img : "EntrepotLv1"});
	_g.set(buildings.Building.ENTREPOT | buildings.Building.LVL_2,{ width : 2, height : 2, building_time : 60, frames_nb : 4, img : "EntrepotLv2"});
	_g.set(buildings.Building.ENTREPOT | buildings.Building.LVL_3,{ width : 2, height : 2, building_time : 90, frames_nb : 4, img : "EntrepotLv3"});
	_g.set(buildings.Building.MUSEE | buildings.Building.LVL_1,{ width : 2, height : 2, building_time : 30, frames_nb : 1, img : "MuseeLv1"});
	_g.set(buildings.Building.MUSEE | buildings.Building.LVL_2,{ width : 2, height : 2, building_time : 60, frames_nb : 1, img : "MuseeLv2"});
	_g.set(buildings.Building.MUSEE | buildings.Building.LVL_3,{ width : 2, height : 3, building_time : 90, frames_nb : 1, img : "MuseeLv3"});
	$r = _g;
	return $r;
}(this));
LoadInfo.preloadAssets = ["assets/UI/SplashScreen/IconsSplash.jpg","assets/UI/SplashScreen/Title.png","assets/UI/SplashScreen/Planet.png","assets/UI/SplashScreen/PlanetLight.png","assets/UI/SplashScreen/doge/sprites.json","assets/UI/SplashScreen/doge/sprites.png","assets/UI/SplashScreen/PlanetGlow/sprites.json","assets/UI/SplashScreen/PlanetGlow/sprites.png","assets/UI/SplashScreen/LoadingFillBar.png","assets/UI/SplashScreen/LoadingFill01.png","assets/UI/SplashScreen/LoadingFill02.png","assets/UI/SplashScreen/LoadingFill03.png","assets/BG.jpg"];
LoadInfo.loadAssets = ["assets/Buildings/CasinoLv1/sprites.png","assets/Buildings/CasinoLv2/sprites.png","assets/Buildings/CasinoLv3/sprites.png","assets/Buildings/Echafaudage/Echafaudage01.png","assets/Buildings/Echafaudage/Echafaudage2.png","assets/Buildings/Echafaudage/Echafaudage3.png","assets/Buildings/Echafaudage/Echafaudage_1case.png","assets/Buildings/EgliseLv1/sprites.png","assets/Buildings/EgliseLv2/sprites.png","assets/Buildings/EgliseLv3/EgliseLv3_0.png","assets/Buildings/EgliseLv3/EgliseLv3_1.png","assets/Buildings/EgliseLv3/EgliseLv3_10.png","assets/Buildings/EgliseLv3/EgliseLv3_11.png","assets/Buildings/EgliseLv3/EgliseLv3_12.png","assets/Buildings/EgliseLv3/EgliseLv3_13.png","assets/Buildings/EgliseLv3/EgliseLv3_14.png","assets/Buildings/EgliseLv3/EgliseLv3_15.png","assets/Buildings/EgliseLv3/EgliseLv3_2.png","assets/Buildings/EgliseLv3/EgliseLv3_3.png","assets/Buildings/EgliseLv3/EgliseLv3_4.png","assets/Buildings/EgliseLv3/EgliseLv3_5.png","assets/Buildings/EgliseLv3/EgliseLv3_6.png","assets/Buildings/EgliseLv3/EgliseLv3_7.png","assets/Buildings/EgliseLv3/EgliseLv3_8.png","assets/Buildings/EgliseLv3/EgliseLv3_9.png","assets/Buildings/EgliseLv3/sprites.png","assets/Buildings/EntrepotLv1/sprites.png","assets/Buildings/EntrepotLv2/sprites.png","assets/Buildings/EntrepotLv3/sprites.png","assets/Buildings/Fusees/Bleu1/sprites.png","assets/Buildings/Fusees/Bleu2/sprites.png","assets/Buildings/Fusees/Bleu3/sprites.png","assets/Buildings/Fusees/Cyan1/sprites.png","assets/Buildings/Fusees/Cyan2/sprites.png","assets/Buildings/Fusees/Cyan3/sprites.png","assets/Buildings/Fusees/Fb1/sprites.png","assets/Buildings/Fusees/Fb2/sprites.png","assets/Buildings/Fusees/Fb3/sprites.png","assets/Buildings/Fusees/Jaune1/sprites.png","assets/Buildings/Fusees/Jaune2/sprites.png","assets/Buildings/Fusees/Jaune3/sprites.png","assets/Buildings/Fusees/Orange1/sprites.png","assets/Buildings/Fusees/Orange2/sprites.png","assets/Buildings/Fusees/Orange3/sprites.png","assets/Buildings/Fusees/Vert1/sprites.png","assets/Buildings/Fusees/Vert2/sprites.png","assets/Buildings/Fusees/Vert3/sprites.png","assets/Buildings/Fusees/Violet1/sprites.png","assets/Buildings/Fusees/Violet2/sprites.png","assets/Buildings/Fusees/Violet3/sprites.png","assets/Buildings/HangarBleuLv1/sprites.png","assets/Buildings/HangarBleuLv2/sprites.png","assets/Buildings/HangarBleuLv3/sprites.png","assets/Buildings/HangarCyanLv1/sprites.png","assets/Buildings/HangarCyanLv2/sprites.png","assets/Buildings/HangarCyanLv3/sprites.png","assets/Buildings/HangarJauneLv1/sprites.png","assets/Buildings/HangarJauneLv2/sprites.png","assets/Buildings/HangarJauneLv3/sprites.png","assets/Buildings/HangarRougeLv1/sprites.png","assets/Buildings/HangarRougeLv2/sprites.png","assets/Buildings/HangarRougeLv3/sprites.png","assets/Buildings/HangarVertLv1/sprites.png","assets/Buildings/HangarVertLv2/sprites.png","assets/Buildings/HangarVertLv3/sprites.png","assets/Buildings/HangarVioletLv1/sprites.png","assets/Buildings/HangarVioletLv2/sprites.png","assets/Buildings/HangarVioletLv3/sprites.png","assets/Buildings/LaboLv1/sprites.png","assets/Buildings/LaboLv2/sprites.png","assets/Buildings/LaboLv3/sprites.png","assets/Buildings/MuseeLv1/sprites.png","assets/Buildings/MuseeLv2/sprites.png","assets/Buildings/MuseeLv3/sprites.png","assets/Buildings/NicheLv1/sprites.png","assets/Buildings/NicheLv2/sprites.png","assets/Buildings/NicheLv3/sprites.png","assets/Buildings/PasDeTirLv1/sprites.png","assets/Buildings/PasDeTirLv2/sprites.png","assets/Buildings/PasDeTirLv3/sprites.png","assets/Dogs/DogCasino.png","assets/Dogs/DogChurch.png","assets/Dogs/DogHangarWorkshop.png","assets/Dogs/DogMusee.png","assets/Dogs/DogNiche.png","assets/Dogs/DogPasDeTir.png","assets/LoaderScene.png","assets/UI/Bulles/HudBulle.png","assets/UI/Cursor/curseur_down.png","assets/UI/Cursor/curseur_up.png","assets/UI/Hud/sprites.png","assets/UI/Icons/Artefacts/IconArtefactsDbz1.png","assets/UI/Icons/Artefacts/IconArtefactsDbz2.png","assets/UI/Icons/Artefacts/IconArtefactsDbz3.png","assets/UI/Icons/Artefacts/IconArtefactsLotr1.png","assets/UI/Icons/Artefacts/IconArtefactsLotr2.png","assets/UI/Icons/Artefacts/IconArtefactsLotr3.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons1.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons2.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons3.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars1.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars2.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars3.png","assets/UI/Icons/Artefacts/IconArtefactsTerre1.png","assets/UI/Icons/Artefacts/IconArtefactsTerre2.png","assets/UI/Icons/Artefacts/IconArtefactsTerre3.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland1.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland2.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland3.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewCasino.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewLabo.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewMusee.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png","assets/UI/Icons/Dogs/IconDogAstro.png","assets/UI/Icons/Dogs/IconDogCasino.png","assets/UI/Icons/Dogs/IconDogChurch.png","assets/UI/Icons/Dogs/IconDogMusee.png","assets/UI/Icons/Dogs/IconDogNiche.png","assets/UI/Icons/Dogs/IconDogWorkshop.png","assets/UI/Icons/Fusee/Bleu3.png","assets/UI/Icons/Fusee/IconFuseeBleu1.png","assets/UI/Icons/Fusee/IconFuseeBleu2.png","assets/UI/Icons/Fusee/IconFuseeCyan1.png","assets/UI/Icons/Fusee/IconFuseeCyan2.png","assets/UI/Icons/Fusee/IconFuseeCyan3.png","assets/UI/Icons/Fusee/IconFuseeFB1.png","assets/UI/Icons/Fusee/IconFuseeFB2.png","assets/UI/Icons/Fusee/IconFuseeFB3.png","assets/UI/Icons/Fusee/IconFuseeJaune1.png","assets/UI/Icons/Fusee/IconFuseeJaune2.png","assets/UI/Icons/Fusee/IconFuseeJaune3.png","assets/UI/Icons/Fusee/IconFuseeOrange1.png","assets/UI/Icons/Fusee/IconFuseeOrange2.png","assets/UI/Icons/Fusee/IconFuseeOrange3.png","assets/UI/Icons/Fusee/IconFuseeVert1.png","assets/UI/Icons/Fusee/IconFuseeVert2.png","assets/UI/Icons/Fusee/IconFuseeVert3.png","assets/UI/Icons/Fusee/IconFuseeViolet1.png","assets/UI/Icons/Fusee/IconFuseeViolet2.png","assets/UI/Icons/Fusee/IconFuseeViolet3.png","assets/UI/Icons/IconsRessources/IconBlueMineral.png","assets/UI/Icons/IconsRessources/IconCyanMineral.png","assets/UI/Icons/IconsRessources/IconDogeflooz.png","assets/UI/Icons/IconsRessources/IconGreenMineral.png","assets/UI/Icons/IconsRessources/IconOsDor.png","assets/UI/Icons/IconsRessources/IconPurpleMineral.png","assets/UI/Icons/IconsRessources/IconRedMineral.png","assets/UI/Icons/IconsRessources/IconYellowMineral.png","assets/UI/Icons/Planet/IconNamek.png","assets/UI/Icons/Planet/IconPlaneteDesEtoiles.png","assets/UI/Icons/Planet/IconPlaneteMilieu.png","assets/UI/Icons/Planet/IconSpringfield.png","assets/UI/Icons/Planet/IconTerre.png","assets/UI/Icons/Planet/IconWonderland.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Os.png","assets/UI/PopIn/ContourNotAfford.png","assets/UI/PopIn/ContourRessourceInsuffisant.png","assets/UI/PopIn/Overlay.png","assets/UI/PopIn/PopInArticleLock.png","assets/UI/PopIn/PopInBackground.png","assets/UI/PopIn/PopInCloseButtonActivel.png","assets/UI/PopIn/PopInCloseButtonNormal.png","assets/UI/PopIn/PopInScrollBackground.png","assets/UI/PopIn/PopInScrollOverlay.png","assets/UI/PopIn/PopInScrollingBar.png","assets/UI/PopIn/PopInScrollingTruc.png","assets/UI/PopInBuilt/PopInBuiltArticleEmptyRessource.png","assets/UI/PopInBuilt/PopInBuiltBgArticle.png","assets/UI/PopInBuilt/PopInBuiltHardActive.png","assets/UI/PopInBuilt/PopInBuiltHardNormal.png","assets/UI/PopInBuilt/PopInBuiltSoftActive.png","assets/UI/PopInBuilt/PopInBuiltSoftNormal.png","assets/UI/PopInBuilt/PopInBuiltSoftNotDispo.png","assets/UI/PopInBuilt/PopInHeaderFusees.png","assets/UI/PopInBuilt/PopInHeaderNiches.png","assets/UI/PopInBuilt/PopInHeaderUtilitaires.png","assets/UI/PopInBuilt/PopInOngletFuseeActive.png","assets/UI/PopInBuilt/PopInOngletFuseeNormal.png","assets/UI/PopInBuilt/PopInOngletNicheActive.png","assets/UI/PopInBuilt/PopInOngletNicheNormal.png","assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png","assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png","assets/UI/PopInBuilt/PopInTitleConstruction.png","assets/UI/PopInInventory/PopInInventoryArticleBg.png","assets/UI/PopInInventory/PopInInventoryBackground.png","assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png","assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","assets/UI/PopInInventory/PopInInventoryScrollingBar.png","assets/UI/PopInInventory/PopInInventoryScrollingTruc.png","assets/UI/PopInInventory/PopInInventoryTitle.png","assets/UI/PopInMarket/PopInHeaderBuy.png","assets/UI/PopInMarket/PopInHeaderSell.png","assets/UI/PopInMarket/PopInMarketBgArticle.png","assets/UI/PopInMarket/PopInMarketNbArticleActive.png","assets/UI/PopInMarket/PopInMarketNbArticleNormal.png","assets/UI/PopInMarket/PopInMarketValidActive.png","assets/UI/PopInMarket/PopInMarketValidNormal.png","assets/UI/PopInMarket/PopInOngletBuyActive.png","assets/UI/PopInMarket/PopInOngletBuyNormal.png","assets/UI/PopInMarket/PopInOngletSellActive.png","assets/UI/PopInMarket/PopInOngletSellNormal.png","assets/UI/PopInMarket/PopInTitleMarket.png","assets/UI/PopInObservatory/PopInObservatoryArticle.png","assets/UI/PopInObservatory/PopInScrollOverlay.png","assets/UI/PopInObservatory/PopInScrollingBar.png","assets/UI/PopInObservatory/PopInScrollingTruc.png","assets/UI/PopInObservatory/PopInTitleObservatory.png","assets/UI/PopInQuest/PopInQuestBgArticle.png","assets/UI/PopInQuest/PopInQuestOngletEnCoursActive.png","assets/UI/PopInQuest/PopInQuestOngletEnCoursNormal.png","assets/UI/PopInQuest/PopInQuestOngletFinishActive.png","assets/UI/PopInQuest/PopInQuestOngletFinishNormal.png","assets/UI/PopInQuest/PopInTitleQuest.png","assets/UI/PopInShop/PopInHeaderDogflooz.png","assets/UI/PopInShop/PopInHeaderOsDOr.png","assets/UI/PopInShop/PopInMarketValidActive.png","assets/UI/PopInShop/PopInMarketValidNormal.png","assets/UI/PopInShop/PopInOngletHardActive.png","assets/UI/PopInShop/PopInOngletHardNormal.png","assets/UI/PopInShop/PopInOngletSoftActive.png","assets/UI/PopInShop/PopInOngletSoftNormal.png","assets/UI/PopInShop/PopInShopBgArticle.png","assets/UI/PopInShop/PopInShopButtonConfirmActive.png","assets/UI/PopInShop/PopInShopButtonConfirmNormal.png","assets/UI/PopInShop/PopInTitleShop.png","assets/UI/PopInSocial/PopInSocialArticleBg.png","assets/UI/PopInSocial/PopInSocialBg.png","assets/UI/PopInSocial/PopInSocialButtonDownActivel.png","assets/UI/PopInSocial/PopInSocialButtonDownNormal.png","assets/UI/PopInSocial/PopInSocialButtonTradeActivel.png","assets/UI/PopInSocial/PopInSocialButtonTradeNormal.png","assets/UI/PopInSocial/PopInSocialButtonUpActive.png","assets/UI/PopInSocial/PopInSocialButtonUpNormal.png","assets/UI/PopInSocial/PopInSocialButtonVisitActive.png","assets/UI/PopInSocial/PopInSocialButtonVisitNormal.png","assets/UI/PopInSocial/PopInSocialPhotoBorders.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet0.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow3.png","assets/UI/PopInWorkshop/PopInTitleWorkshop.png","assets/UI/PopInWorkshop/PopInWorkshopArticleBG.png","assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png","assets/UI/PopInWorkshop/PopInWorkshopCancelButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopCancelButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopHeader.png","assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFill1.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFill2.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFillBar.png","assets/UI/PopInWorkshop/PopInWorkshopLoadIcon.png","assets/UI/PopInWorkshop/PopInWorkshopParticule.png","assets/UI/PopInWorkshop/PopInWorkshopTextBG.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle01.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle02.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle03.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle04.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle05.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle06.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle07.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle08.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle09.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle10.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick01.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick02.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick03.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick04.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick05.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick06.png","assets/alpha_bg.png","assets/Buildings/CasinoLv1/sprites.json","assets/Buildings/CasinoLv2/sprites.json","assets/Buildings/CasinoLv3/sprites.json","assets/Buildings/EgliseLv1/sprites.json","assets/Buildings/EgliseLv2/sprites.json","assets/Buildings/EgliseLv3/sprites.json","assets/Buildings/EntrepotLv1/sprites.json","assets/Buildings/EntrepotLv2/sprites.json","assets/Buildings/EntrepotLv3/sprites.json","assets/Buildings/Fusees/Bleu1/sprites.json","assets/Buildings/Fusees/Bleu2/sprites.json","assets/Buildings/Fusees/Bleu3/sprites.json","assets/Buildings/Fusees/Cyan1/sprites.json","assets/Buildings/Fusees/Cyan2/sprites.json","assets/Buildings/Fusees/Cyan3/sprites.json","assets/Buildings/Fusees/Fb1/sprites.json","assets/Buildings/Fusees/Fb2/sprites.json","assets/Buildings/Fusees/Fb3/sprites.json","assets/Buildings/Fusees/Jaune1/sprites.json","assets/Buildings/Fusees/Jaune2/sprites.json","assets/Buildings/Fusees/Jaune3/sprites.json","assets/Buildings/Fusees/Orange1/sprites.json","assets/Buildings/Fusees/Orange2/sprites.json","assets/Buildings/Fusees/Orange3/sprites.json","assets/Buildings/Fusees/Vert1/sprites.json","assets/Buildings/Fusees/Vert2/sprites.json","assets/Buildings/Fusees/Vert3/sprites.json","assets/Buildings/Fusees/Violet1/sprites.json","assets/Buildings/Fusees/Violet2/sprites.json","assets/Buildings/Fusees/Violet3/sprites.json","assets/Buildings/HangarBleuLv1/sprites.json","assets/Buildings/HangarBleuLv2/sprites.json","assets/Buildings/HangarBleuLv3/sprites.json","assets/Buildings/HangarCyanLv1/sprites.json","assets/Buildings/HangarCyanLv2/sprites.json","assets/Buildings/HangarCyanLv3/sprites.json","assets/Buildings/HangarJauneLv1/sprites.json","assets/Buildings/HangarJauneLv2/sprites.json","assets/Buildings/HangarJauneLv3/sprites.json","assets/Buildings/HangarRougeLv1/sprites.json","assets/Buildings/HangarRougeLv2/sprites.json","assets/Buildings/HangarRougeLv3/sprites.json","assets/Buildings/HangarVertLv1/sprites.json","assets/Buildings/HangarVertLv2/sprites.json","assets/Buildings/HangarVertLv3/sprites.json","assets/Buildings/HangarVioletLv1/sprites.json","assets/Buildings/HangarVioletLv2/sprites.json","assets/Buildings/HangarVioletLv3/sprites.json","assets/Buildings/LaboLv1/sprites.json","assets/Buildings/LaboLv2/sprites.json","assets/Buildings/LaboLv3/sprites.json","assets/Buildings/MuseeLv1/sprites.json","assets/Buildings/MuseeLv2/sprites.json","assets/Buildings/MuseeLv3/sprites.json","assets/Buildings/NicheLv1/sprites.json","assets/Buildings/NicheLv2/sprites.json","assets/Buildings/NicheLv3/sprites.json","assets/Buildings/PasDeTirLv1/sprites.json","assets/Buildings/PasDeTirLv2/sprites.json","assets/Buildings/PasDeTirLv3/sprites.json","assets/UI/Hud/sprites.json","assets/UI/HudBuildingContextBar.png"];
Main.CONFIG_PATH = "config.json";
buildings.PreviewBuilding.CANT_BUILD_COLOR = 16729156;
utils.events.Event.COMPLETE = "Event.COMPLETE";
utils.events.Event.GAME_LOOP = "Event.GAME_LOOP";
utils.events.Event.RESIZE = "Event.RESIZE";
Main.main();
})();

//# sourceMappingURL=Structure.js.map
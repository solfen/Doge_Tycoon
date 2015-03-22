(function () { "use strict";
var $hxClasses = {};
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var GameInfo = function() { };
$hxClasses["GameInfo"] = GameInfo;
GameInfo.__name__ = ["GameInfo"];
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var IsoMap = function(pBG_url,pCols_nb,pRows_nb,pCell_width,pCell_height) {
	PIXI.DisplayObjectContainer.call(this);
	var background = new PIXI.TilingSprite(PIXI.Texture.fromImage(pBG_url),pCols_nb * pCell_width,pRows_nb * pCell_height);
	this.addChild(background);
	this._graphics = new PIXI.Graphics();
	this._graphics.lineStyle(1,8965375,1);
	this.addChild(this._graphics);
	IsoMap.singleton = this;
	this._screen_margin = 0.15;
	this._screen_move_speed = 0.1;
	this._is_clicking = false;
	IsoMap.cols_nb = pCols_nb;
	IsoMap.rows_nb = pRows_nb;
	IsoMap.cell_width = pCell_width;
	IsoMap.cell_height = pCell_height;
	this._map_width = IsoMap.cols_nb * IsoMap.cell_width;
	this._map_height = IsoMap.rows_nb * IsoMap.cell_height;
	this._offset_x = 0;
	this._offset_y = 0;
	this._cells_pts = utils.game.IsoTools.all_map_pts_xy(this._offset_x,this._offset_y,IsoMap.cell_width,IsoMap.cell_height,IsoMap.cols_nb * IsoMap.rows_nb,IsoMap.cols_nb);
	this.x = Std["int"]((function($this) {
		var $r;
		var a = utils.system.DeviceCapabilities.get_width();
		$r = (function($this) {
			var $r;
			var $int = a;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}($this)) * 0.5;
		return $r;
	}(this)) - this._map_width * 0.5);
	this.y = Std["int"]((function($this) {
		var $r;
		var a1 = utils.system.DeviceCapabilities.get_height();
		$r = (function($this) {
			var $r;
			var int1 = a1;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}($this)) * 0.5;
		return $r;
	}(this)) - this._map_height * 0.5);
	this.obstacles_layer = new Array();
	this.buildings_layer = new Array();
	var i = IsoMap.cols_nb * IsoMap.rows_nb;
	while(i-- > 0) {
		this.obstacles_layer[i] = false;
		this.buildings_layer[i] = 0;
		this._graphics.moveTo(this._cells_pts[i].x0,this._cells_pts[i].y0);
		this._graphics.lineTo(this._cells_pts[i].x1,this._cells_pts[i].y1);
		this._graphics.lineTo(this._cells_pts[i].x2,this._cells_pts[i].y2);
		this._graphics.lineTo(this._cells_pts[i].x3,this._cells_pts[i].y3);
		this._graphics.lineTo(this._cells_pts[i].x0,this._cells_pts[i].y0);
		if(i / IsoMap.cols_nb - (i / IsoMap.cols_nb | 0) == 0) this.addChild(new PIXI.DisplayObjectContainer());
	}
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this._update));
};
$hxClasses["IsoMap"] = IsoMap;
IsoMap.__name__ = ["IsoMap"];
IsoMap.__super__ = PIXI.DisplayObjectContainer;
IsoMap.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	_update: function() {
		if(this._is_clicking && !utils.game.InputInfos.is_mouse_down) {
			this._is_clicking = false;
			this._on_click();
		} else if(!this._is_clicking && utils.game.InputInfos.is_mouse_down) this._is_clicking = true;
		if(utils.game.InputInfos.mouse_x < (function($this) {
			var $r;
			var a = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var $int = a;
				$r = $int < 0?4294967296.0 + $int:$int + 0.0;
				return $r;
			}($this)) * $this._screen_margin;
			return $r;
		}(this)) && this.x > -this._map_width * 0.5) this.x += Std["int"](((function($this) {
			var $r;
			var a1 = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var int1 = a1;
				$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
				return $r;
			}($this)) * $this._screen_margin;
			return $r;
		}(this)) - utils.game.InputInfos.mouse_x) * this._screen_move_speed); else if(utils.game.InputInfos.mouse_x > (function($this) {
			var $r;
			var a2 = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var int2 = a2;
				$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
				return $r;
			}($this)) * (1 - $this._screen_margin);
			return $r;
		}(this)) && this.x < this._map_width * 0.5) this.x += Std["int"](((function($this) {
			var $r;
			var a3 = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var int3 = a3;
				$r = int3 < 0?4294967296.0 + int3:int3 + 0.0;
				return $r;
			}($this)) * (1 - $this._screen_margin);
			return $r;
		}(this)) - utils.game.InputInfos.mouse_x) * this._screen_move_speed);
		if(utils.game.InputInfos.mouse_y < (function($this) {
			var $r;
			var a4 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int4 = a4;
				$r = int4 < 0?4294967296.0 + int4:int4 + 0.0;
				return $r;
			}($this)) * $this._screen_margin;
			return $r;
		}(this)) && this.y > -this._map_height * 0.5) this.y += Std["int"](((function($this) {
			var $r;
			var a5 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int5 = a5;
				$r = int5 < 0?4294967296.0 + int5:int5 + 0.0;
				return $r;
			}($this)) * $this._screen_margin;
			return $r;
		}(this)) - utils.game.InputInfos.mouse_y) * this._screen_move_speed); else if(utils.game.InputInfos.mouse_y > (function($this) {
			var $r;
			var a6 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int6 = a6;
				$r = int6 < 0?4294967296.0 + int6:int6 + 0.0;
				return $r;
			}($this)) * (1 - $this._screen_margin);
			return $r;
		}(this)) && this.y < this._map_height * 0.5) this.y += Std["int"](((function($this) {
			var $r;
			var a7 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int7 = a7;
				$r = int7 < 0?4294967296.0 + int7:int7 + 0.0;
				return $r;
			}($this)) * (1 - $this._screen_margin);
			return $r;
		}(this)) - utils.game.InputInfos.mouse_y) * this._screen_move_speed);
	}
	,_on_click: function() {
		var tmp_id = sprites.Building.CASINO | sprites.Building.LVL_1;
		var new_building = this.build_building(tmp_id,utils.game.InputInfos.mouse_x | 0,utils.game.InputInfos.mouse_y | 0);
	}
	,set_content: function(content) {
	}
	,build_building: function(pBuilding_id,pX,pY) {
		var index = utils.game.IsoTools.cell_index_from_xy(pX,pY,(this.x | 0) + this._offset_x,(this.y | 0) + this._offset_y,IsoMap.cell_width,IsoMap.cell_height,IsoMap.cols_nb);
		var col = utils.game.IsoTools.cell_col(index,IsoMap.cols_nb);
		var row = utils.game.IsoTools.cell_row(index,IsoMap.cols_nb);
		var new_x = utils.game.IsoTools.cell_x(col,IsoMap.cell_width,this._offset_x);
		var new_y = utils.game.IsoTools.cell_y(row,IsoMap.cell_height,this._offset_y);
		this.buildings_layer[index] = pBuilding_id;
		var building = new sprites.Building(pBuilding_id,col,row,new_x,new_y);
		console.log("index: " + index);
		console.log("col: " + col);
		console.log("row: " + row);
		try {
			this.getChildAt((row | 0) + 2).addChild(building);
		} catch( error ) {
			console.log(error);
		}
		return building;
	}
	,destroy_building: function(pX,pY) {
	}
	,__class__: IsoMap
});
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
	utils.events.EventDispatcher.call(this);
	this.stage = new PIXI.Stage(4160694);
	this.renderer = PIXI.autoDetectRenderer((function($this) {
		var $r;
		var this1 = utils.system.DeviceCapabilities.get_width();
		var $int = this1;
		$r = $int < 0?4294967296.0 + $int:$int + 0.0;
		return $r;
	}(this)),(function($this) {
		var $r;
		var this11 = utils.system.DeviceCapabilities.get_height();
		var int1 = this11;
		$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
		return $r;
	}(this)));
	window.document.body.appendChild(this.renderer.view);
	window.requestAnimationFrame($bind(this,this.gameLoop));
	window.addEventListener("resize",$bind(this,this.resize));
	this.preloadAssets();
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
Main.__super__ = utils.events.EventDispatcher;
Main.prototype = $extend(utils.events.EventDispatcher.prototype,{
	getStage: function() {
		return this.stage;
	}
	,preloadAssets: function() {
		var lLoader = new PIXI.AssetLoader(GameInfo.preloadAssets);
		lLoader.addEventListener("onComplete",$bind(this,this.loadAssets));
		lLoader.load();
	}
	,loadAssets: function(pEvent) {
		pEvent.target.removeEventListener("onComplete",$bind(this,this.loadAssets));
		scenes.ScenesManager.getInstance().loadScene("LoaderScene");
		var lLoader = new PIXI.AssetLoader(GameInfo.loadAssets);
		lLoader.addEventListener("onProgress",$bind(this,this.onLoadProgress));
		lLoader.addEventListener("onComplete",$bind(this,this.onLoadComplete));
		lLoader.load();
	}
	,onLoadProgress: function(pEvent) {
		var lLoader;
		lLoader = js.Boot.__cast(pEvent.target , PIXI.AssetLoader);
	}
	,onLoadComplete: function(pEvent) {
		pEvent.target.removeEventListener("onProgress",$bind(this,this.onLoadProgress));
		pEvent.target.removeEventListener("onComplete",$bind(this,this.onLoadComplete));
		scenes.ScenesManager.getInstance().loadScene("GameScene");
	}
	,gameLoop: function() {
		window.requestAnimationFrame($bind(this,this.gameLoop));
		this.render();
		this.dispatchEvent(new utils.events.Event("Event.GAME_LOOP"));
	}
	,resize: function(pEvent) {
		this.renderer.resize((function($this) {
			var $r;
			var this1 = utils.system.DeviceCapabilities.get_width();
			var $int = this1;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)),(function($this) {
			var $r;
			var this11 = utils.system.DeviceCapabilities.get_height();
			var int1 = this11;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)));
		this.dispatchEvent(new utils.events.Event("Event.RESIZE"));
	}
	,render: function() {
		this.renderer.render(this.stage);
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
var haxe = {};
haxe.ds = {};
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
	,__class__: haxe.ds.StringMap
};
var hud = {};
hud.IconHud = function(startX,startY,texture) {
	var lCompleteClassName = Type.getClassName(Type.getClass(this));
	var pos = lCompleteClassName.lastIndexOf(".") + 1;
	this.texturePath = HxOverrides.substr(lCompleteClassName,pos,null);
	this.texturePath = "assets/" + this.texturePath + ".png";
	if(texture != null) this.texturePath = "assets/" + texture + ".png";
	PIXI.Sprite.call(this,PIXI.Texture.fromImage(this.texturePath));
	this.x = startX;
	this.y = startY;
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
};
$hxClasses["hud.IconHud"] = hud.IconHud;
hud.IconHud.__name__ = ["hud","IconHud"];
hud.IconHud.__super__ = PIXI.Sprite;
hud.IconHud.prototype = $extend(PIXI.Sprite.prototype,{
	onClick: function(pData) {
	}
	,onMouseOver: function(pData) {
	}
	,__class__: hud.IconHud
});
hud.HudBuild = function(startX,startY,texture) {
	hud.IconHud.call(this,startX,startY,texture);
};
$hxClasses["hud.HudBuild"] = hud.HudBuild;
hud.HudBuild.__name__ = ["hud","HudBuild"];
hud.HudBuild.__super__ = hud.IconHud;
hud.HudBuild.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinBuild",(function($this) {
			var $r;
			var a = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var $int = a;
				$r = $int < 0?4294967296.0 + $int:$int + 0.0;
				return $r;
			}($this)) / (function($this) {
				var $r;
				var int1 = 2;
				$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
				return $r;
			}($this));
			return $r;
		}(this)),(function($this) {
			var $r;
			var a1 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int2 = a1;
				$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
				return $r;
			}($this)) / (function($this) {
				var $r;
				var int11 = 2;
				$r = int11 < 0?4294967296.0 + int11:int11 + 0.0;
				return $r;
			}($this));
			return $r;
		}(this)));
	}
	,__class__: hud.HudBuild
});
hud.HudManager = function() {
	this.childs = [];
	PIXI.DisplayObjectContainer.call(this);
	this.currentChild = new hud.HudBuild(50,50);
	this.childs.push(this.currentChild);
	this.addChild(this.currentChild);
};
$hxClasses["hud.HudManager"] = hud.HudManager;
hud.HudManager.__name__ = ["hud","HudManager"];
hud.HudManager.getInstance = function() {
	if(hud.HudManager.instance == null) hud.HudManager.instance = new hud.HudManager();
	return hud.HudManager.instance;
};
hud.HudManager.__super__ = PIXI.DisplayObjectContainer;
hud.HudManager.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	destroy: function() {
		var _g1 = 0;
		var _g = this.childs.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.removeChild(this.childs[i]);
		}
		this.childs = [];
		hud.HudManager.instance = null;
	}
	,__class__: hud.HudManager
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
popin.IconPopin = function(pX,pY,pTexturePath,pName,isInteractive) {
	PIXI.Sprite.call(this,PIXI.Texture.fromImage("assets/" + pTexturePath + ".png"));
	this.x = pX;
	this.y = pY;
	this.name = pName;
	this.interactive = isInteractive;
	this.buttonMode = isInteractive;
};
$hxClasses["popin.IconPopin"] = popin.IconPopin;
popin.IconPopin.__name__ = ["popin","IconPopin"];
popin.IconPopin.__super__ = PIXI.Sprite;
popin.IconPopin.prototype = $extend(PIXI.Sprite.prototype,{
	__class__: popin.IconPopin
});
popin.MyPopin = function(startX,startY,textureName,isModal) {
	if(isModal == null) isModal = true;
	if(startY == null) startY = 0;
	if(startX == null) startX = 0;
	this.childs = new haxe.ds.StringMap();
	PIXI.DisplayObjectContainer.call(this);
	this.x = startX;
	this.y = startY;
	if(isModal) {
		this.modalZone = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		this.modalZone.x = -startX;
		this.modalZone.y = -startY;
		this.modalZone.width = 2500;
		this.modalZone.height = 2500;
		this.modalZone.interactive = true;
		this.modalZone.click = $bind(this,this.stopClickEventPropagation);
		var v = this.modalZone;
		this.childs.set("modal",v);
		v;
		this.addChild(this.modalZone);
	}
	if(textureName == null) {
		var lCompleteClassName = Type.getClassName(Type.getClass(this));
		var lClassName;
		var pos = lCompleteClassName.lastIndexOf(".") + 1;
		lClassName = HxOverrides.substr(lCompleteClassName,pos,null);
		textureName = lClassName;
	}
	this.background = new PIXI.Sprite(PIXI.Texture.fromImage("assets/" + textureName + ".png"));
	this.background.anchor.set(0.5,0.5);
	var v1 = this.background;
	this.childs.set("background",v1);
	v1;
	this.addChild(this.background);
};
$hxClasses["popin.MyPopin"] = popin.MyPopin;
popin.MyPopin.__name__ = ["popin","MyPopin"];
popin.MyPopin.getInstance = function(startX,startY,textureName) {
	if(popin.MyPopin.instance == null) popin.MyPopin.instance = new popin.MyPopin(startX,startY,textureName);
	return popin.MyPopin.instance;
};
popin.MyPopin.__super__ = PIXI.DisplayObjectContainer;
popin.MyPopin.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	addIcon: function(x,y,textureName,name,isInteractive) {
		if(isInteractive == null) isInteractive = true;
		if(name == null) name = textureName;
		this.currentChild = new popin.IconPopin(x,y,textureName,name,isInteractive);
		if(isInteractive) this.currentChild.click = $bind(this,this.childClick);
		var v = this.currentChild;
		this.childs.set(name,v);
		v;
		this.addChild(this.currentChild);
	}
	,childClick: function(pEvent) {
	}
	,stopClickEventPropagation: function(pEvent) {
	}
	,destroy: function() {
	}
	,__class__: popin.MyPopin
});
popin.PopinBuild = function(startX,startY,texture) {
	popin.MyPopin.call(this,startX,startY,texture);
	this.addIcon(0,0,"closeButton","closeButton");
};
$hxClasses["popin.PopinBuild"] = popin.PopinBuild;
popin.PopinBuild.__name__ = ["popin","PopinBuild"];
popin.PopinBuild.getInstance = function(startX,startY,texture) {
	if(popin.PopinBuild.instance == null) popin.PopinBuild.instance = new popin.PopinBuild(startX,startY,texture);
	return popin.PopinBuild.instance;
};
popin.PopinBuild.__super__ = popin.MyPopin;
popin.PopinBuild.prototype = $extend(popin.MyPopin.prototype,{
	childClick: function(pEvent) {
		if(pEvent.target.name == "closeButton") popin.PopinManager.getInstance().closePopin("PopinBuild");
	}
	,__class__: popin.PopinBuild
});
popin.PopinManager = function() {
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
	openPopin: function(popinName,pX,pY) {
		var v = Type.createInstance(Type.resolveClass("popin." + popinName),[pX,pY]);
		this.childs.set(popinName,v);
		v;
		this.addChild(this.childs.get(popinName));
	}
	,closePopin: function(popinName) {
		this.removeChild(this.childs.get(popinName));
		this.childs.remove(popinName);
	}
	,closeAllPopin: function() {
		var $it0 = this.childs.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			this.removeChild(this.childs.get(key));
		}
		this.childs = new haxe.ds.StringMap();
	}
	,destroy: function() {
		this.closeAllPopin();
		Main.getInstance().getStage().removeChild(this);
		popin.PopinManager.instance = null;
	}
	,__class__: popin.PopinManager
});
var scenes = {};
scenes.GameScene = function() {
	PIXI.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	new utils.game.InputInfos(true,true);
	utils.game.InputInfos.mouse_x = Std["int"]((function($this) {
		var $r;
		var a = utils.system.DeviceCapabilities.get_width();
		$r = (function($this) {
			var $r;
			var $int = a;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}($this)) * 0.5;
		return $r;
	}(this)));
	utils.game.InputInfos.mouse_y = Std["int"]((function($this) {
		var $r;
		var a1 = utils.system.DeviceCapabilities.get_height();
		$r = (function($this) {
			var $r;
			var int1 = a1;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}($this)) * 0.5;
		return $r;
	}(this)));
	new IsoMap("assets/BG.jpg",64,64,128,64);
	this.addChild(IsoMap.singleton);
	this.addChild(hud.HudManager.getInstance());
	this.addChild(popin.PopinManager.getInstance());
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.doAction));
	Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.resize));
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
	PIXI.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	var img = new PIXI.Sprite(PIXI.Texture.fromImage("assets/LoaderScene.png"));
	img.anchor.set(0.5,0.5);
	var a = utils.system.DeviceCapabilities.get_width();
	img.x = (function($this) {
		var $r;
		var $int = a;
		$r = $int < 0?4294967296.0 + $int:$int + 0.0;
		return $r;
	}(this)) / (function($this) {
		var $r;
		var int1 = 2;
		$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
		return $r;
	}(this));
	var a1 = utils.system.DeviceCapabilities.get_height();
	img.y = (function($this) {
		var $r;
		var int2 = a1;
		$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
		return $r;
	}(this)) / (function($this) {
		var $r;
		var int3 = 2;
		$r = int3 < 0?4294967296.0 + int3:int3 + 0.0;
		return $r;
	}(this));
	this.addChild(img);
};
$hxClasses["scenes.LoaderScene"] = scenes.LoaderScene;
scenes.LoaderScene.__name__ = ["scenes","LoaderScene"];
scenes.LoaderScene.getInstance = function() {
	if(scenes.LoaderScene.instance == null) scenes.LoaderScene.instance = new scenes.LoaderScene();
	return scenes.LoaderScene.instance;
};
scenes.LoaderScene.__super__ = PIXI.DisplayObjectContainer;
scenes.LoaderScene.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	__class__: scenes.LoaderScene
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
		if(this.isThereAScene) Main.getInstance().getStage().removeChild(this.currentScene);
		this.currentScene = Type.createInstance(Type.resolveClass("scenes." + sceneName),[]);
		Main.getInstance().getStage().addChild(this.currentScene);
		this.isThereAScene = true;
	}
	,__class__: scenes.ScenesManager
};
var sprites = {};
sprites.Ambulance = function() {
	PIXI.MovieClip.call(this,sprites.Ambulance.getTexture());
	this.anchor.set(0.5,0.5);
	this.animationSpeed = 0.2;
	this.play();
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
};
$hxClasses["sprites.Ambulance"] = sprites.Ambulance;
sprites.Ambulance.__name__ = ["sprites","Ambulance"];
sprites.Ambulance.getTexture = function() {
	var lTexture = new Array();
	var _g1 = 0;
	var _g = sprites.Ambulance.images.length;
	while(_g1 < _g) {
		var i = _g1++;
		lTexture.push(PIXI.Texture.fromFrame("ambulance_" + sprites.Ambulance.images[i] + ".png"));
	}
	return lTexture;
};
sprites.Ambulance.__super__ = PIXI.MovieClip;
sprites.Ambulance.prototype = $extend(PIXI.MovieClip.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinBuild",(function($this) {
			var $r;
			var a = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var $int = a;
				$r = $int < 0?4294967296.0 + $int:$int + 0.0;
				return $r;
			}($this)) / (function($this) {
				var $r;
				var int1 = 2;
				$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
				return $r;
			}($this));
			return $r;
		}(this)),(function($this) {
			var $r;
			var a1 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int2 = a1;
				$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
				return $r;
			}($this)) / (function($this) {
				var $r;
				var int11 = 2;
				$r = int11 < 0?4294967296.0 + int11:int11 + 0.0;
				return $r;
			}($this));
			return $r;
		}(this)));
	}
	,__class__: sprites.Ambulance
});
sprites.Building = function(p_type,p_col,p_row,pX,pY) {
	this.type = p_type;
	this.lvl = 1;
	this.col = p_col;
	this.row = p_row;
	this.config = sprites.Building.BUILDINGS_CONFIG[this.get_id()];
	this.width_in_tiles_nb = this.config.width;
	this.height_in_tiles_nb = this.config.height;
	PIXI.MovieClip.call(this,this._get_texture());
	this.anchor.set(0,1);
	pX = pX - IsoMap.cell_width * (this.width_in_tiles_nb * 0.5 | 0) | 0;
	pY = pY + IsoMap.cell_height * (this.height_in_tiles_nb * 0.5 + 1 | 0) | 0;
	this.position.set(pX,pY);
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this._on_click);
};
$hxClasses["sprites.Building"] = sprites.Building;
sprites.Building.__name__ = ["sprites","Building"];
sprites.Building.GET_BUILDINGS_CONFIG = function() {
	var config = [];
	config[sprites.Building.CASINO | sprites.Building.LVL_1] = { width : 3, height : 3, vertical_dir : 0, img_i : 0};
	config[sprites.Building.CASINO | sprites.Building.LVL_2] = { width : 3, height : 3, vertical_dir : 0, img_i : 1};
	config[sprites.Building.CASINO | sprites.Building.LVL_3] = { width : 3, height : 3, vertical_dir : 0, img_i : 2};
	config[sprites.Building.EGLISE | sprites.Building.LVL_1] = { width : 3, height : 3, vertical_dir : 0, img_i : 3};
	config[sprites.Building.EGLISE | sprites.Building.LVL_2] = { width : 3, height : 3, vertical_dir : 0, img_i : 4};
	config[sprites.Building.EGLISE | sprites.Building.LVL_3] = { width : 3, height : 3, vertical_dir : 0, img_i : 5};
	config[sprites.Building.HANGAR_1 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 6};
	config[sprites.Building.HANGAR_1 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 7};
	config[sprites.Building.HANGAR_1 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 8};
	config[sprites.Building.HANGAR_2 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 9};
	config[sprites.Building.HANGAR_2 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 10};
	config[sprites.Building.HANGAR_2 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 11};
	config[sprites.Building.HANGAR_3 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 12};
	config[sprites.Building.HANGAR_3 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 13};
	config[sprites.Building.HANGAR_3 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 14};
	config[sprites.Building.HANGAR_4 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 15};
	config[sprites.Building.HANGAR_4 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 16};
	config[sprites.Building.HANGAR_4 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 17};
	config[sprites.Building.HANGAR_5 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 18};
	config[sprites.Building.HANGAR_5 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 19};
	config[sprites.Building.HANGAR_5 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 20};
	config[sprites.Building.HANGAR_6 | sprites.Building.LVL_1] = { width : 3, height : 2, vertical_dir : -1, img_i : 21};
	config[sprites.Building.HANGAR_6 | sprites.Building.LVL_2] = { width : 3, height : 2, vertical_dir : -1, img_i : 22};
	config[sprites.Building.HANGAR_6 | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : -1, img_i : 23};
	config[sprites.Building.LABO | sprites.Building.LVL_1] = { width : 2, height : 2, vertical_dir : 0, img_i : 24};
	config[sprites.Building.LABO | sprites.Building.LVL_2] = { width : 2, height : 2, vertical_dir : 0, img_i : 25};
	config[sprites.Building.LABO | sprites.Building.LVL_3] = { width : 3, height : 2, vertical_dir : 1, img_i : 26};
	config[sprites.Building.NICHE | sprites.Building.LVL_1] = { width : 1, height : 1, vertical_dir : 0, img_i : 27};
	config[sprites.Building.NICHE | sprites.Building.LVL_2] = { width : 1, height : 1, vertical_dir : 0, img_i : 28};
	config[sprites.Building.NICHE | sprites.Building.LVL_3] = { width : 1, height : 1, vertical_dir : 0, img_i : 29};
	config[sprites.Building.PAS_DE_TIR | sprites.Building.LVL_1] = { width : 5, height : 3, vertical_dir : 0, img_i : 30};
	config[sprites.Building.PAS_DE_TIR | sprites.Building.LVL_2] = { width : 5, height : 3, vertical_dir : 0, img_i : 31};
	config[sprites.Building.PAS_DE_TIR | sprites.Building.LVL_3] = { width : 5, height : 3, vertical_dir : 0, img_i : 32};
	return config;
};
sprites.Building.get_building_type = function(id) {
	return id & 255;
};
sprites.Building.get_building_lvl = function(id) {
	return id & 3840;
};
sprites.Building.__super__ = PIXI.MovieClip;
sprites.Building.prototype = $extend(PIXI.MovieClip.prototype,{
	upgrade: function() {
	}
	,get_id: function() {
		return this.type | this.lvl;
	}
	,_on_click: function(p_data) {
		console.log("click on building " + this.get_id());
	}
	,_get_texture: function() {
		var textures = new Array();
		textures.push(PIXI.Texture.fromFrame(sprites.Building.IMG_FOLDER_PATH + sprites.Building.BUILDINGS_IMG[this.config.img_i] + sprites.Building.IMG_EXTENSION));
		return textures;
	}
	,__class__: sprites.Building
});
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
utils.game.InputInfos = function(listen_click,listen_mousemove) {
	utils.game.InputInfos.singleton = this;
	utils.game.InputInfos.mouse_x = 0;
	utils.game.InputInfos.mouse_y = 0;
	utils.game.InputInfos.clicked_mouse_x = 0;
	utils.game.InputInfos.clicked_mouse_y = 0;
	utils.game.InputInfos.is_mouse_down = false;
	if(listen_click) {
		window.onmousedown = $bind(this,this._on_mousedown);
		window.onmouseup = $bind(this,this._on_mouseup);
	}
	if(listen_mousemove) window.onmousemove = $bind(this,this._on_mousemove);
};
$hxClasses["utils.game.InputInfos"] = utils.game.InputInfos;
utils.game.InputInfos.__name__ = ["utils","game","InputInfos"];
utils.game.InputInfos.prototype = {
	_on_mousedown: function(pData) {
		utils.game.InputInfos.is_mouse_down = true;
	}
	,_on_mouseup: function(pData) {
		utils.game.InputInfos.is_mouse_down = false;
		utils.game.InputInfos.clicked_mouse_x = pData.clientX;
		utils.game.InputInfos.clicked_mouse_y = pData.clientY;
	}
	,_on_mousemove: function(pData) {
		utils.game.InputInfos.mouse_x = pData.clientX;
		utils.game.InputInfos.mouse_y = pData.clientY;
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
	return window.innerHeight;
};
utils.system.DeviceCapabilities.get_width = function() {
	return window.innerWidth;
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
GameInfo.preloadAssets = ["assets/preload.png","assets/preload_bg.png","assets/LoaderScene.png"];
GameInfo.loadAssets = ["./assets/alpha_bg.png","./assets/BG.jpg","./assets/black_bg.png","./assets/Buildings/CasinoLv1.png","./assets/Buildings/CasinoLv2.png","./assets/Buildings/CasinoLv3.png","./assets/Buildings/EgliseLv1.png","./assets/Buildings/EgliseLv2.png","./assets/Buildings/EgliseLv3.png","./assets/Buildings/Hangar1Lv1.png","./assets/Buildings/Hangar1Lv2.png","./assets/Buildings/Hangar1Lv3.png","./assets/Buildings/Hangar2Lv1.png","./assets/Buildings/Hangar2Lv2.png","./assets/Buildings/Hangar2Lv3.png","./assets/Buildings/Hangar3Lv1.png","./assets/Buildings/Hangar3Lv2.png","./assets/Buildings/Hangar3Lv3.png","./assets/Buildings/Hangar4Lv1.png","./assets/Buildings/Hangar4Lv2.png","./assets/Buildings/Hangar4Lv3.png","./assets/Buildings/Hangar5Lv1.png","./assets/Buildings/Hangar5Lv2.png","./assets/Buildings/Hangar5Lv3.png","./assets/Buildings/Hangar6Lv1.png","./assets/Buildings/Hangar6Lv2.png","./assets/Buildings/Hangar6Lv3.png","./assets/Buildings/Labo1.png","./assets/Buildings/Labo2.png","./assets/Buildings/Labo3.png","./assets/Buildings/NicheLv1.png","./assets/Buildings/NicheLv2.png","./assets/Buildings/NicheLv3.png","./assets/Buildings/PasDeTir1.png","./assets/Buildings/PasDeTir2.png","./assets/Buildings/PasDeTir3.png","./assets/closeButton.png","./assets/game.png","./assets/HudBuild.png","./assets/Hud_B.png","./assets/Hud_TL.png","./assets/Hud_TR.png","./assets/Popin0.png","./assets/Popin1.png","./assets/PopinBuild.png","./assets/PopinOkCancel.png","./assets/Screen0.png","./assets/Screen1.png","./assets/TitleCard.png"];
GameInfo.userWidth = 1920;
GameInfo.userHeight = 1000;
Main.CONFIG_PATH = "config.json";
sprites.Ambulance.images = ["E","SE","S","SW","W","NW","N","NE"];
sprites.Building.CASINO = 1;
sprites.Building.EGLISE = 2;
sprites.Building.HANGAR_1 = 3;
sprites.Building.HANGAR_2 = 4;
sprites.Building.HANGAR_3 = 5;
sprites.Building.HANGAR_4 = 6;
sprites.Building.HANGAR_5 = 7;
sprites.Building.HANGAR_6 = 8;
sprites.Building.LABO = 9;
sprites.Building.NICHE = 10;
sprites.Building.PAS_DE_TIR = 11;
sprites.Building.LVL_1 = 256;
sprites.Building.LVL_2 = 512;
sprites.Building.LVL_3 = 768;
sprites.Building.IMG_FOLDER_PATH = "./assets/Buildings/";
sprites.Building.IMG_EXTENSION = ".png";
sprites.Building.BUILDINGS_IMG = ["CasinoLv1","CasinoLv2","CasinoLv3","EgliseLv1","EgliseLv2","EgliseLv3","Hangar1Lv1","Hangar1Lv2","Hangar1Lv3","Hangar2Lv1","Hangar2Lv2","Hangar2Lv3","Hangar3Lv1","Hangar3Lv2","Hangar3Lv3","Hangar4Lv1","Hangar4Lv2","Hangar4Lv3","Hangar5Lv1","Hangar5Lv2","Hangar5Lv3","Hangar6Lv1","Hangar6Lv2","Hangar6Lv3","Labo1","Labo2","Labo3","NicheLv1","NicheLv2","NicheLv3","PasDeTir1","PasDeTir2","PasDeTir3"];
sprites.Building.BUILDINGS_CONFIG = sprites.Building.GET_BUILDINGS_CONFIG();
utils.events.Event.COMPLETE = "Event.COMPLETE";
utils.events.Event.GAME_LOOP = "Event.GAME_LOOP";
utils.events.Event.RESIZE = "Event.RESIZE";
Main.main();
})();

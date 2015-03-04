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
	Main.stage = new PIXI.Stage(4160694);
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
	Main.stats = new Stats();
	window.document.body.appendChild(Main.stats.domElement);
	Main.stats.domElement.style.position = "absolute";
	Main.stats.domElement.style.top = "0px";
	this.gameLoop(0);
	window.addEventListener("resize",$bind(this,this.resize));
	haxe.Timer.delay($bind(this,this.preloadAssets),10);
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
		Main.stats.begin();
		window.requestAnimationFrame($bind(this,this.gameLoop));
		this.render();
		this.dispatchEvent(new utils.events.Event("Event.GAME_LOOP"));
		Main.stats.end();
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
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
};
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
var pixi = {};
pixi.display = {};
pixi.display.DisplayObject = function() {
	PIXI.DisplayObject.call(this);
	this.name = "";
};
$hxClasses["pixi.display.DisplayObject"] = pixi.display.DisplayObject;
pixi.display.DisplayObject.__name__ = ["pixi","display","DisplayObject"];
pixi.display.DisplayObject.__super__ = PIXI.DisplayObject;
pixi.display.DisplayObject.prototype = $extend(PIXI.DisplayObject.prototype,{
	__class__: pixi.display.DisplayObject
});
pixi.display.DisplayObjectContainer = function() {
	PIXI.DisplayObjectContainer.call(this);
};
$hxClasses["pixi.display.DisplayObjectContainer"] = pixi.display.DisplayObjectContainer;
pixi.display.DisplayObjectContainer.__name__ = ["pixi","display","DisplayObjectContainer"];
pixi.display.DisplayObjectContainer.__super__ = PIXI.DisplayObjectContainer;
pixi.display.DisplayObjectContainer.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	getChildByName: function(name) {
		var _g1 = 0;
		var _g = this.children.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.children[i].name == name) return this.children[i];
		}
		return null;
	}
	,applyScale: function(pixelRatio) {
		if(pixelRatio > 0) this.scale.set(1 / pixelRatio,1 / pixelRatio);
	}
	,__class__: pixi.display.DisplayObjectContainer
});
var hud = {};
hud.IconHud = function(startX,startY,texturePathNormal,texturePathActive,texturePathHover) {
	this.hoverTexture = null;
	this.activeTexture = null;
	this.normalTexture = PIXI.Texture.fromImage(texturePathNormal);
	if(texturePathActive != null) this.activeTexture = PIXI.Texture.fromImage(texturePathActive);
	if(texturePathHover != null) this.hoverTexture = PIXI.Texture.fromImage(texturePathHover);
	PIXI.Sprite.call(this,this.normalTexture);
	this.anchor.set(0.5,0.5);
	var _g1 = startX;
	var _g = utils.system.DeviceCapabilities.get_width();
	this.x = (function($this) {
		var $r;
		var $int = _g;
		$r = $int < 0?4294967296.0 + $int:$int + 0.0;
		return $r;
	}(this)) * _g1;
	var _g3 = startY;
	var _g2 = utils.system.DeviceCapabilities.get_height();
	this.y = (function($this) {
		var $r;
		var int1 = _g2;
		$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
		return $r;
	}(this)) * _g3;
};
$hxClasses["hud.IconHud"] = hud.IconHud;
hud.IconHud.__name__ = ["hud","IconHud"];
hud.IconHud.__super__ = PIXI.Sprite;
hud.IconHud.prototype = $extend(PIXI.Sprite.prototype,{
	changeTexture: function(state) {
		if(state == "active" && this.activeTexture != null) this.setTexture(this.activeTexture); else if(state == "hover" && this.hoverTexture != null) this.setTexture(this.hoverTexture); else if(state == "normal") this.setTexture(this.normalTexture); else console.log("IconHud changeTexture() : Invalid texture change, check if correct state and/or correct textures. State: " + state);
	}
	,__class__: hud.IconHud
});
hud.HudBuild = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/HUD/HudIconBuildNormal.png","assets/HUD/HudIconBuildActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudBuild"] = hud.HudBuild;
hud.HudBuild.__name__ = ["hud","HudBuild"];
hud.HudBuild.__super__ = hud.IconHud;
hud.HudBuild.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinBuild",0.5,0.5);
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudBuild
});
hud.HudInventory = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/HUD/HudIconInventoryNormal.png","assets/HUD/HudIconInventoryActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudInventory"] = hud.HudInventory;
hud.HudInventory.__name__ = ["hud","HudInventory"];
hud.HudInventory.__super__ = hud.IconHud;
hud.HudInventory.prototype = $extend(hud.IconHud.prototype,{
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
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudInventory
});
hud.HudManager = function() {
	this.childs = [];
	pixi.display.DisplayObjectContainer.call(this);
	this.newChild(new hud.HudBuild(0.95,0.95));
	this.newChild(new hud.HudInventory(0.9,0.95));
	this.newChild(new hud.HudShop(0.85,0.95));
	this.newChild(new hud.HudQuests(0.80,0.95));
	this.newChild(new hud.HudOptions(0.95,0.05));
};
$hxClasses["hud.HudManager"] = hud.HudManager;
hud.HudManager.__name__ = ["hud","HudManager"];
hud.HudManager.getInstance = function() {
	if(hud.HudManager.instance == null) hud.HudManager.instance = new hud.HudManager();
	return hud.HudManager.instance;
};
hud.HudManager.__super__ = pixi.display.DisplayObjectContainer;
hud.HudManager.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
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
	,newChild: function(child) {
		this.childs.push(child);
		this.addChild(child);
	}
	,__class__: hud.HudManager
});
hud.HudOptions = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/HUD/HudIconOptionNormal.png","assets/HUD/HudIconOptionActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudOptions"] = hud.HudOptions;
hud.HudOptions.__name__ = ["hud","HudOptions"];
hud.HudOptions.__super__ = hud.IconHud;
hud.HudOptions.prototype = $extend(hud.IconHud.prototype,{
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
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudOptions
});
hud.HudQuests = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/HUD/HudIconQuestNormal.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
};
$hxClasses["hud.HudQuests"] = hud.HudQuests;
hud.HudQuests.__name__ = ["hud","HudQuests"];
hud.HudQuests.__super__ = hud.IconHud;
hud.HudQuests.prototype = $extend(hud.IconHud.prototype,{
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
	,__class__: hud.HudQuests
});
hud.HudShop = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/HUD/HudIconShopNormal.png","assets/HUD/HudIconShopActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudShop"] = hud.HudShop;
hud.HudShop.__name__ = ["hud","HudShop"];
hud.HudShop.__super__ = hud.IconHud;
hud.HudShop.prototype = $extend(hud.IconHud.prototype,{
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
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudShop
});
var js = {};
js.Boot = function() { };
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
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
pixi.DomDefinitions = function() { };
$hxClasses["pixi.DomDefinitions"] = pixi.DomDefinitions;
pixi.DomDefinitions.__name__ = ["pixi","DomDefinitions"];
pixi.renderers = {};
pixi.renderers.IRenderer = function() { };
$hxClasses["pixi.renderers.IRenderer"] = pixi.renderers.IRenderer;
pixi.renderers.IRenderer.__name__ = ["pixi","renderers","IRenderer"];
pixi.renderers.IRenderer.prototype = {
	__class__: pixi.renderers.IRenderer
};
var popin = {};
popin.IconPopin = function(pX,pY,pTexturePath,pName,isInteractive) {
	PIXI.Sprite.call(this,PIXI.Texture.fromImage(pTexturePath));
	this.x = pX;
	this.y = pY;
	this._name = pName;
	this.interactive = isInteractive;
	this.buttonMode = isInteractive;
};
$hxClasses["popin.IconPopin"] = popin.IconPopin;
popin.IconPopin.__name__ = ["popin","IconPopin"];
popin.IconPopin.__super__ = PIXI.Sprite;
popin.IconPopin.prototype = $extend(PIXI.Sprite.prototype,{
	__class__: popin.IconPopin
});
popin.MyPopin = function(startX,startY,texturePath,isModal) {
	if(isModal == null) isModal = true;
	if(startY == null) startY = 0;
	if(startX == null) startX = 0;
	this.childs = new haxe.ds.StringMap();
	pixi.display.DisplayObjectContainer.call(this);
	var _g1 = startX;
	var _g = utils.system.DeviceCapabilities.get_width();
	this.x = (function($this) {
		var $r;
		var $int = _g;
		$r = $int < 0?4294967296.0 + $int:$int + 0.0;
		return $r;
	}(this)) * _g1;
	var _g3 = startY;
	var _g2 = utils.system.DeviceCapabilities.get_height();
	this.y = (function($this) {
		var $r;
		var int1 = _g2;
		$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
		return $r;
	}(this)) * _g3;
	if(isModal) {
		this.modalZone = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		var _g5 = -startX;
		var _g4 = utils.system.DeviceCapabilities.get_width();
		this.modalZone.x = (function($this) {
			var $r;
			var int2 = _g4;
			$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
			return $r;
		}(this)) * _g5;
		var _g7 = -startY;
		var _g6 = utils.system.DeviceCapabilities.get_height();
		this.modalZone.y = (function($this) {
			var $r;
			var int3 = _g6;
			$r = int3 < 0?4294967296.0 + int3:int3 + 0.0;
			return $r;
		}(this)) * _g7;
		var this1 = utils.system.DeviceCapabilities.get_width();
		var int4 = this1;
		if(int4 < 0) this.modalZone.width = 4294967296.0 + int4; else this.modalZone.width = int4 + 0.0;
		var this2 = utils.system.DeviceCapabilities.get_height();
		var int5 = this2;
		if(int5 < 0) this.modalZone.height = 4294967296.0 + int5; else this.modalZone.height = int5 + 0.0;
		this.modalZone.interactive = true;
		this.modalZone.click = $bind(this,this.stopClickEventPropagation);
		var v = this.modalZone;
		this.childs.set("modal",v);
		v;
		this.addChild(this.modalZone);
	}
	this.background = new PIXI.Sprite(PIXI.Texture.fromImage(texturePath));
	this.background.anchor.set(0.5,0.5);
	var v1 = this.background;
	this.childs.set("background",v1);
	v1;
	this.addChild(this.background);
};
$hxClasses["popin.MyPopin"] = popin.MyPopin;
popin.MyPopin.__name__ = ["popin","MyPopin"];
popin.MyPopin.__super__ = pixi.display.DisplayObjectContainer;
popin.MyPopin.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	addIcon: function(x,y,texturePath,name,isInteractive) {
		if(isInteractive == null) isInteractive = true;
		this.currentChild = new popin.IconPopin(x * this.background.width - this.background.width / 2,y * this.background.height - this.background.height / 2,texturePath,name,isInteractive);
		if(isInteractive) this.currentChild.click = $bind(this,this.childClick);
		var v = this.currentChild;
		this.childs.set(name,v);
		v;
		this.addChild(this.currentChild);
	}
	,addText: function(x,y,font,fontSize,txt,name,pAlign) {
		if(pAlign == null) pAlign = "center";
		var style = { font : fontSize + " " + font, align : pAlign};
		var tempText = new PIXI.BitmapText(txt,style);
		var _g1 = x;
		var _g = utils.system.DeviceCapabilities.get_width();
		tempText.position.x = (function($this) {
			var $r;
			var $int = _g;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)) * _g1;
		var _g3 = y;
		var _g2 = utils.system.DeviceCapabilities.get_height();
		tempText.position.y = (function($this) {
			var $r;
			var int1 = _g2;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)) * _g3;
		this.addChild(tempText);
	}
	,childClick: function(pEvent) {
	}
	,stopClickEventPropagation: function(pEvent) {
	}
	,destroy: function() {
	}
	,__class__: popin.MyPopin
});
popin.PopinBuild = function(startX,startY) {
	popin.MyPopin.call(this,startX,startY,"assets/Popins/PopInBackground.png");
	this.addIcon(-0.15,-0.15,"assets/Popins/PopInHeaderConstruction.png","header",false);
	this.addIcon(0.65,0.05,"assets/Popins/PopInTitleNiches.png","category",false);
	this.addIcon(0.10,0.15,"assets/Popins/PopInScrollBackground.png","contentBackground",false);
	this.addIcon(0.125,0.175,"assets/Popins/PopInBuiltBgArticle.png","articleBase",false);
	this.addIcon(0.14,0.1875,"assets/Popins/PopInBuiltArticlePreview.png","ArticlePreview",false);
	this.addIcon(0.3,0.275,"assets/Popins/PopInBuiltArticleBgRessources.png","ArticleRessourcesBack",false);
	this.addIcon(0.305,0.28,"assets/Popins/PopInBuiltArticleSoftRessource.png","SoftRessource1",false);
	this.addIcon(0.755,0.28,"assets/Popins/PopInBuiltArticleHardRessource.png","HardRessource",false);
	this.addIcon(0.695,0.2875,"assets/Popins/PopInBuiltSoftNormal.png","ArticleBgRessources",false);
	this.addIcon(0.82,0.2875,"assets/Popins/PopInBuiltHardNormal.png","ArticleBgRessources",false);
	this.addIcon(0.95,0,"assets/Popins/HudInventoryCloseButtonNormal.png","closeButton");
	this.addIcon(0.10,0.15,"assets/Popins/PopInScrollOverlay.png","contentBackground",false);
};
$hxClasses["popin.PopinBuild"] = popin.PopinBuild;
popin.PopinBuild.__name__ = ["popin","PopinBuild"];
popin.PopinBuild.__super__ = popin.MyPopin;
popin.PopinBuild.prototype = $extend(popin.MyPopin.prototype,{
	childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") popin.PopinManager.getInstance().closePopin("PopinBuild");
	}
	,__class__: popin.PopinBuild
});
popin.PopinManager = function() {
	this.childs = new haxe.ds.StringMap();
	pixi.display.DisplayObjectContainer.call(this);
};
$hxClasses["popin.PopinManager"] = popin.PopinManager;
popin.PopinManager.__name__ = ["popin","PopinManager"];
popin.PopinManager.getInstance = function() {
	if(popin.PopinManager.instance == null) popin.PopinManager.instance = new popin.PopinManager();
	return popin.PopinManager.instance;
};
popin.PopinManager.__super__ = pixi.display.DisplayObjectContainer;
popin.PopinManager.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
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
		Main.getStage().removeChild(this);
		popin.PopinManager.instance = null;
	}
	,__class__: popin.PopinManager
});
var scenes = {};
scenes.GameScene = function() {
	pixi.display.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	var background = new PIXI.Sprite(PIXI.Texture.fromImage("assets/game.png"));
	background.anchor.set(0.5,0.5);
	background.position.set((function($this) {
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
	this.addChild(background);
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
scenes.GameScene.__super__ = pixi.display.DisplayObjectContainer;
scenes.GameScene.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	doAction: function() {
	}
	,resize: function() {
		console.log(this);
	}
	,__class__: scenes.GameScene
});
scenes.LoaderScene = function() {
	pixi.display.DisplayObjectContainer.call(this);
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
scenes.LoaderScene.__super__ = pixi.display.DisplayObjectContainer;
scenes.LoaderScene.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
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
		if(this.isThereAScene) Main.getStage().removeChild(this.currentScene);
		this.currentScene = Type.createInstance(Type.resolveClass("scenes." + sceneName),[]);
		Main.getStage().addChild(this.currentScene);
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
GameInfo.preloadAssets = ["assets/preload.png","assets/preload_bg.png","assets/LoaderScene.png"];
GameInfo.loadAssets = ["assets/HUD/HudIconBuildActive.png","assets/HUD/HudIconBuildNormal.png","assets/HUD/HudIconInventoryActive.png","assets/HUD/HudIconInventoryNormal.png","assets/HUD/HudIconOptionActive.png","assets/HUD/HudIconOptionNormal.png","assets/HUD/HudIconQuestNormal.png","assets/HUD/HudIconShopActive.png","assets/HUD/HudIconShopNormal.png","assets/HUD/HudIconStockActive.png","assets/HUD/HudIconStockNormal.png","assets/HudBuild.png","assets/Hud_B.png","assets/Hud_TL.png","assets/Hud_TR.png","assets/LoaderScene.png","assets/Popin0.png","assets/Popin1.png","assets/PopinBuild.png","assets/PopinOkCancel.png","assets/Popins/HudIconRessource1.png","assets/Popins/HudIconRessource2.png","assets/Popins/HudIconRessource3.png","assets/Popins/HudIconRessource4.png","assets/Popins/HudIconRessource5.png","assets/Popins/HudIconRessource6.png","assets/Popins/HudInventoryCloseButtonActive.png","assets/Popins/HudInventoryCloseButtonNormal.png","assets/Popins/HudInventoryScrollingBar.png","assets/Popins/HudInventoryScrollingTruc.png","assets/Popins/HudInventoryTitle.png","assets/Popins/PopInBackground.png","assets/Popins/PopInBuiltArticleBgRessources.png","assets/Popins/PopInBuiltArticleEmptyRessource.png","assets/Popins/PopInBuiltBgArticle.png","assets/Popins/PopInBuiltHardActive.png","assets/Popins/PopInBuiltHardNormal.png","assets/Popins/PopInBuiltSoftActive.png","assets/Popins/PopInBuiltSoftNormal.png","assets/Popins/PopInHeaderConstruction.png","assets/Popins/PopInHeaderEglise.png","assets/Popins/PopInOngletButtonActive.png","assets/Popins/PopInOngletButtonNormal.png","assets/Popins/PopInScrollBackground.png","assets/Popins/PopInScrollOverlay.png","assets/Popins/PopInTitleFusees.png","assets/Popins/PopInTitleNiches.png","assets/Popins/PopInTitleUtilitaires.png","assets/Popins/PopInBuiltArticleSoftRessource.png","assets/Popins/PopInBuiltArticleHardRessource.png","assets/Popins/PopInBuiltArticlePreview.png","assets/Screen0.png","assets/Screen1.png","assets/TitleCard.png","assets/alpha_bg.png","assets/ambulance.png","assets/black_bg.png","assets/closeButton.png","assets/game.png","assets/preload.png","assets/preload_bg.png"];
GameInfo.userWidth = 1920;
GameInfo.userHeight = 1000;
Main.CONFIG_PATH = "config.json";
sprites.Ambulance.images = ["E","SE","S","SW","W","NW","N","NE"];
utils.events.Event.COMPLETE = "Event.COMPLETE";
utils.events.Event.GAME_LOOP = "Event.GAME_LOOP";
utils.events.Event.RESIZE = "Event.RESIZE";
Main.main();
})();

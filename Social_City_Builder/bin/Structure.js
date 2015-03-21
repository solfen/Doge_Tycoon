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
	var _g = this;
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
	this.WebFontConfig = { custom : { families : ["FuturaStdMedium","FuturaStdHeavy"], urls : ["fonts.css"]}, active : function() {
		_g.preloadAssets();
	}};
	WebFont.load(this.WebFontConfig);
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
		haxe.Log.trace(pResponse.status,{ fileName : "Main.hx", lineNumber : 117, className : "Main", methodName : "onFacebookConnect"});
		if(pResponse.status == "connected") {
			haxe.Log.trace("awww yeah ! you're in !",{ fileName : "Main.hx", lineNumber : 119, className : "Main", methodName : "onFacebookConnect"});
			FB.ui({ method : "share", href : "https://developers.facebook.com/docs"},$bind(this,this.test));
		} else if(pResponse.status == "not_authorized") haxe.Log.trace("Oh no ! you're not identified",{ fileName : "Main.hx", lineNumber : 123, className : "Main", methodName : "onFacebookConnect"});
	}
	,test: function() {
		haxe.Log.trace("succes",{ fileName : "Main.hx", lineNumber : 127, className : "Main", methodName : "test"});
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
haxe.Log = function() { };
$hxClasses["haxe.Log"] = haxe.Log;
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.prototype = {
	run: function() {
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
hud.IconHud = function(startX,startY,texturePathNormal,texturePathActive,texturePathHover,pIsUpdatable) {
	if(pIsUpdatable == null) pIsUpdatable = false;
	this.hoverTexture = null;
	this.activeTexture = null;
	this.normalTexture = PIXI.Texture.fromImage(texturePathNormal);
	if(texturePathActive != null) this.activeTexture = PIXI.Texture.fromImage(texturePathActive);
	if(texturePathHover != null) this.hoverTexture = PIXI.Texture.fromImage(texturePathHover);
	PIXI.Sprite.call(this,this.normalTexture);
	this.x = Std["int"]((function($this) {
		var $r;
		var _g1 = startX;
		var _g = utils.system.DeviceCapabilities.get_width();
		$r = (function($this) {
			var $r;
			var $int = _g;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}($this)) * _g1;
		return $r;
	}(this)));
	this.y = Std["int"]((function($this) {
		var $r;
		var _g3 = startY;
		var _g2 = utils.system.DeviceCapabilities.get_height();
		$r = (function($this) {
			var $r;
			var int1 = _g2;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}($this)) * _g3;
		return $r;
	}(this)));
	this.isUpdatable = pIsUpdatable;
};
$hxClasses["hud.IconHud"] = hud.IconHud;
hud.IconHud.__name__ = ["hud","IconHud"];
hud.IconHud.__super__ = PIXI.Sprite;
hud.IconHud.prototype = $extend(PIXI.Sprite.prototype,{
	changeTexture: function(state) {
		if(state == "active" && this.activeTexture != null) this.setTexture(this.activeTexture); else if(state == "hover" && this.hoverTexture != null) this.setTexture(this.hoverTexture); else if(state == "normal") this.setTexture(this.normalTexture); else haxe.Log.trace("IconHud changeTexture() : Invalid texture change, check if correct state and/or correct textures. State: " + state,{ fileName : "IconHud.hx", lineNumber : 44, className : "hud.IconHud", methodName : "changeTexture"});
	}
	,updateInfo: function() {
	}
	,__class__: hud.IconHud
});
hud.HudBuild = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconBuildNormal.png","assets/UI/Hud/HudIconBuildActive.png");
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
hud.HudDestroy = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconDestroyNormal.png","assets/UI/Hud/HudIconDestroyActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudDestroy"] = hud.HudDestroy;
hud.HudDestroy.__name__ = ["hud","HudDestroy"];
hud.HudDestroy.__super__ = hud.IconHud;
hud.HudDestroy.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudDestroy
});
hud.HudDoges = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudPopFillBar.png",null,null,true);
	this.barFill = new PIXI.Sprite(PIXI.Texture.fromImage("assets/UI/Hud/HudPopFill.png"));
	this.barFill.position.set(0.23 * this.width | 0,0.3 * this.height | 0);
	this.barFill.width = this.lastDogeNumber / this.lastDogeMaxNumber * this.width * .725 | 0;
	this.addChild(this.barFill);
	this.dogeIcon = new PIXI.Sprite(PIXI.Texture.fromImage("assets/UI/Hud/HudIconPop.png"));
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
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudMoneySoft.png",null,null,true);
	this.lastFric = GameInfo.fric;
	this.fricText = new PIXI.Text(this.lastFric + "",{ font : "35px FuturaStdHeavy", fill : "white"});
	this.fricText.position.x = this.width * 0.95 - this.fricText.width | 0;
	this.fricText.position.y = this.height / 2 - this.fricText.height / 2 | 0;
	this.addChild(this.fricText);
};
$hxClasses["hud.HudFric"] = hud.HudFric;
hud.HudFric.__name__ = ["hud","HudFric"];
hud.HudFric.__super__ = hud.IconHud;
hud.HudFric.prototype = $extend(hud.IconHud.prototype,{
	updateInfo: function() {
		if(this.lastFric != GameInfo.fric) {
			this.fricText.setText(GameInfo.fric + "");
			this.lastFric = GameInfo.fric;
		}
	}
	,__class__: hud.HudFric
});
hud.HudHardMoney = function(startX,startY) {
	this.lastHardMoney = GameInfo.hardMoney;
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudMoneyHard.png");
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
		if(this.lastHardMoney != GameInfo.hardMoney) {
			this.lastHardMoney = GameInfo.hardMoney;
			this.hardMoneyText.setText(this.lastHardMoney + "");
		}
	}
	,__class__: hud.HudHardMoney
});
hud.HudInventory = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconInventoryNormal.png","assets/UI/Hud/HudIconInventoryActive.png");
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
		popin.PopinManager.getInstance().openPopin("PopinInventory",0.5,0.5);
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
	this.refreshChildsInterval = 1000;
	this.lastX = 0;
	this.hudBottomY = 0;
	this.hudTopY = 0.025;
	this.hudWidthInterval = 0.05;
	this.containers = new haxe.ds.StringMap();
	this.childs = new haxe.ds.StringMap();
	pixi.display.DisplayObjectContainer.call(this);
	this.addContainer(0.01,0,"HudTop",0.92,0.05,"center");
	this.addHud(new hud.HudFric(0,this.hudTopY),"HudFric","HudTop");
	this.addHud(new hud.HudHardMoney(0,this.hudTopY),"HudHardMoney","HudTop");
	this.addHud(new hud.HudDoges(0,this.hudTopY),"HudDoges","HudTop");
	this.addHud(new hud.HudStock(0,this.hudTopY),"HudStock","HudTop");
	this.addContainer(0.94,0,"HudLeft",0.05,0.05,"right");
	this.addHud(new hud.HudOptions(0,this.hudTopY),"HudOptions","HudLeft");
	this.addContainer(0.01,0.9,"HudBottom",.98,0.01,"right");
	this.addHud(new hud.HudDestroy(0,this.hudBottomY),"HudDestroy","HudBottom");
	this.addHud(new hud.HudInventory(0,this.hudBottomY),"HudInventory","HudBottom");
	this.addHud(new hud.HudQuests(0,this.hudBottomY),"HudQuests","HudBottom");
	this.addHud(new hud.HudMarket(0,this.hudBottomY),"HudMarket","HudBottom");
	this.addHud(new hud.HudShop(0,this.hudBottomY),"HudShop","HudBottom");
	this.addHud(new hud.HudBuild(0,this.hudBottomY),"HudBuild","HudBottom");
	this.addHud(new hud.HudObservatory(0,this.hudBottomY),"HudObservatory","HudBottom");
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
hud.HudManager.__super__ = pixi.display.DisplayObjectContainer;
hud.HudManager.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
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
				i.position.x = Std["int"]((function($this) {
					var $r;
					var _g2 = childsWidth + container.interval;
					var _g1 = utils.system.DeviceCapabilities.get_width();
					$r = (function($this) {
						var $r;
						var $int = _g1;
						$r = $int < 0?4294967296.0 + $int:$int + 0.0;
						return $r;
					}($this)) * _g2;
					return $r;
				}(this)));
				childsWidth += (function($this) {
					var $r;
					var b;
					{
						var this1 = utils.system.DeviceCapabilities.get_width();
						var int1 = this1;
						if(int1 < 0) b = 4294967296.0 + int1; else b = int1 + 0.0;
					}
					$r = i.width / (function($this) {
						var $r;
						var int2 = b;
						$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
						return $r;
					}($this));
					return $r;
				}(this)) + container.interval;
			}
			if(childsWidth > container.maxWidth) {
				container.obj.scale.x = container.maxWidth / childsWidth;
				container.obj.scale.y = container.maxWidth / childsWidth;
				container.obj.position.x = Std["int"]((function($this) {
					var $r;
					var this11;
					{
						var b1 = utils.system.DeviceCapabilities.get_width();
						this11 = container.startX * b1;
					}
					var int3 = this11;
					$r = int3 < 0?4294967296.0 + int3:int3 + 0.0;
					return $r;
				}(this)));
			} else {
				var tempX;
				if(container.align == "left") {
					var int4 = container.startX;
					if(int4 < 0) tempX = 4294967296.0 + int4; else tempX = int4 + 0.0;
				} else if(container.align == "center") tempX = (function($this) {
					var $r;
					var int5 = container.startX;
					$r = int5 < 0?4294967296.0 + int5:int5 + 0.0;
					return $r;
				}(this)) + (container.maxWidth - childsWidth) / 2; else tempX = (function($this) {
					var $r;
					var int6 = container.startX;
					$r = int6 < 0?4294967296.0 + int6:int6 + 0.0;
					return $r;
				}(this)) + container.maxWidth - childsWidth;
				container.obj.position.x = Std["int"]((function($this) {
					var $r;
					var _g11 = tempX;
					var _g3 = utils.system.DeviceCapabilities.get_width();
					$r = (function($this) {
						var $r;
						var int7 = _g3;
						$r = int7 < 0?4294967296.0 + int7:int7 + 0.0;
						return $r;
					}($this)) * _g11;
					return $r;
				}(this)));
			}
			container.obj.position.y = Math.min(Std["int"]((function($this) {
				var $r;
				var this12;
				{
					var b2 = utils.system.DeviceCapabilities.get_height();
					this12 = container.startY * b2;
				}
				var int8 = this12;
				$r = int8 < 0?4294967296.0 + int8:int8 + 0.0;
				return $r;
			}(this))),(function($this) {
				var $r;
				var a = utils.system.DeviceCapabilities.get_height();
				$r = (function($this) {
					var $r;
					var int9 = a;
					$r = int9 < 0?4294967296.0 + int9:int9 + 0.0;
					return $r;
				}($this)) - container.obj.children[0].height;
				return $r;
			}(this)));
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
		var container = new pixi.display.DisplayObjectContainer();
		container.position.set(Std["int"]((function($this) {
			var $r;
			var _g1 = x;
			var _g = utils.system.DeviceCapabilities.get_width();
			$r = (function($this) {
				var $r;
				var $int = _g;
				$r = $int < 0?4294967296.0 + $int:$int + 0.0;
				return $r;
			}($this)) * _g1;
			return $r;
		}(this))),Std["int"]((function($this) {
			var $r;
			var _g3 = y;
			var _g2 = utils.system.DeviceCapabilities.get_height();
			$r = (function($this) {
				var $r;
				var int1 = _g2;
				$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
				return $r;
			}($this)) * _g3;
			return $r;
		}(this))));
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
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconMarketNormal.png","assets/UI/Hud/HudIconMarketActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudMarket"] = hud.HudMarket;
hud.HudMarket.__name__ = ["hud","HudMarket"];
hud.HudMarket.__super__ = hud.IconHud;
hud.HudMarket.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinMarket",0.5,0.5);
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudMarket
});
hud.HudObservatory = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconObservatoryNormal.png","assets/UI/Hud/HudIconObservatoryActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudObservatory"] = hud.HudObservatory;
hud.HudObservatory.__name__ = ["hud","HudObservatory"];
hud.HudObservatory.__super__ = hud.IconHud;
hud.HudObservatory.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinObservatory",0.5,0.5);
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudObservatory
});
hud.HudOptions = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconOptionNormal.png","assets/UI/Hud/HudIconOptionActive.png");
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
		popin.PopinManager.getInstance().openPopin("PopinOptions",0.5,0.5);
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
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconQuestNormal.png","assets/UI/Hud/HudIconQuestActive.png");
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
	this.mouseover = $bind(this,this.onMouseOver);
	this.mouseout = $bind(this,this.onMouseOut);
};
$hxClasses["hud.HudQuests"] = hud.HudQuests;
hud.HudQuests.__name__ = ["hud","HudQuests"];
hud.HudQuests.__super__ = hud.IconHud;
hud.HudQuests.prototype = $extend(hud.IconHud.prototype,{
	onClick: function(pData) {
		popin.PopinManager.getInstance().openPopin("PopinQuests",0.5,0.5);
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudQuests
});
hud.HudShop = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudIconShopNormal.png","assets/UI/Hud/HudIconShopActive.png");
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
		popin.PopinManager.getInstance().openPopin("PopinShop",0.5,0.5);
	}
	,onMouseOver: function(pData) {
		this.changeTexture("active");
	}
	,onMouseOut: function(pData) {
		this.changeTexture("normal");
	}
	,__class__: hud.HudShop
});
hud.HudStock = function(startX,startY) {
	hud.IconHud.call(this,startX,startY,"assets/UI/Hud/HudInventoryFillBar.png",null,null,true);
	this.barFill = new PIXI.Sprite(PIXI.Texture.fromImage("assets/UI/Hud/HudInventoryFill.png"));
	this.barFill.position.set(0.23 * this.width | 0,0.3 * this.height | 0);
	this.barFill.width = this.lastStockPercent / 100 * this.width * .725 | 0;
	this.addChild(this.barFill);
	this.inventoryIcon = new PIXI.Sprite(PIXI.Texture.fromImage("assets/UI/Hud/HudIconInventory.png"));
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
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js.Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js.Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js.Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
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
popin.IconPopin = function(pX,pY,texturePathNormal,pName,isInteractive,texturePathActive) {
	this.activeTexture = null;
	this.normalTexture = PIXI.Texture.fromImage(texturePathNormal);
	if(texturePathActive != null) this.activeTexture = PIXI.Texture.fromImage(texturePathActive);
	PIXI.Sprite.call(this,this.normalTexture);
	this.x = pX;
	this.y = pY;
	this._name = pName;
	this.interactive = isInteractive;
	this.buttonMode = isInteractive;
	if(isInteractive) {
		this.mouseover = $bind(this,this.onMouseOver);
		this.mouseout = $bind(this,this.onMouseOut);
	}
};
$hxClasses["popin.IconPopin"] = popin.IconPopin;
popin.IconPopin.__name__ = ["popin","IconPopin"];
popin.IconPopin.__super__ = PIXI.Sprite;
popin.IconPopin.prototype = $extend(PIXI.Sprite.prototype,{
	onMouseOver: function(pData) {
		if(this.activeTexture != null) this.setTexture(this.activeTexture);
	}
	,onMouseOut: function(pData) {
		this.setTexture(this.normalTexture);
	}
	,__class__: popin.IconPopin
});
popin.MyPopin = function(startX,startY,texturePath,isModal) {
	if(isModal == null) isModal = true;
	if(startY == null) startY = 0;
	if(startX == null) startX = 0;
	this.scrollDragging = false;
	this.containers = new haxe.ds.StringMap();
	this.childs = new haxe.ds.StringMap();
	pixi.display.DisplayObjectContainer.call(this);
	this.x = Std["int"]((function($this) {
		var $r;
		var _g1 = startX;
		var _g = utils.system.DeviceCapabilities.get_width();
		$r = (function($this) {
			var $r;
			var $int = _g;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}($this)) * _g1;
		return $r;
	}(this)));
	this.y = Std["int"]((function($this) {
		var $r;
		var _g3 = startY;
		var _g2 = utils.system.DeviceCapabilities.get_height();
		$r = (function($this) {
			var $r;
			var int1 = _g2;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}($this)) * _g3;
		return $r;
	}(this)));
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
		var this11 = utils.system.DeviceCapabilities.get_height();
		var int5 = this11;
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
	addIcon: function(x,y,texturePath,name,target,isInteractive,texturePathActive) {
		if(isInteractive == null) isInteractive = true;
		this.currentChild = new popin.IconPopin(x * this.background.width - this.background.width / 2 | 0,y * this.background.height - this.background.height / 2 | 0,texturePath,name,isInteractive,texturePathActive);
		if(isInteractive) this.currentChild.click = $bind(this,this.childClick);
		var v = this.currentChild;
		this.childs.set(name,v);
		v;
		target.addChild(this.currentChild);
	}
	,addText: function(x,y,font,fontSize,txt,name,target,pAlign) {
		if(pAlign == null) pAlign = "left";
		var style = { font : fontSize + " " + font, align : pAlign};
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
			if(_g.scrollDragging && newY > 0.23 * _g.background.height - _g.background.height / 2 && newY < 0.635 * _g.background.height - _g.background.height / 2) {
				var interval = 0.635 * _g.background.height - _g.background.height / 2 - (0.23 * _g.background.height - _g.background.height / 2);
				var maxScroll = _g.containers.get("verticalScroller").height - _g.childs.get("contentBackground").height + 100;
				_g.scrollIndicator.y = newY;
				_g.containers.get("verticalScroller").y = -((newY - (0.23 * _g.background.height - _g.background.height / 2)) * maxScroll / interval | 0);
			}
		};
		var v = this.scrollIndicator;
		this.childs.set("scrollingIndicator",v);
		v;
		this.addChild(this.scrollIndicator);
	}
	,removeVerticalScrollBar: function() {
		this.removeChild(this.childs.get("scrollingIndicator"));
		this.removeChild(this.childs.get("scrollingBar"));
		var v;
		this.childs.set("scrollingBar",null);
		v = null;
		this.childs.set("scrollingIndicator",v);
		this.scrollIndicator = v;
	}
	,addContainer: function(name,target,x,y) {
		if(y == null) y = 0;
		if(x == null) x = 0;
		var temp = new pixi.display.DisplayObjectContainer();
		temp.x = x;
		temp.y = y;
		this.containers.set(name,temp);
		temp;
		target.addChild(temp);
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
	this.currentTab = "nicheTab";
	this.hasVerticalScrollBar = false;
	this.articleInterline = 0.03;
	this.articleHeight = PIXI.Texture.fromImage("assets/UI/PopInBuilt/PopInBuiltBgArticle.png").height;
	popin.MyPopin.call(this,startX,startY,"assets/UI/PopIn/PopInBackground.png");
	this.articleHeight /= this.background.height;
	this.addIcon(-0.15,-0.15,"assets/UI/PopInBuilt/PopInTitleConstruction.png","popInTitle",this,false);
	this.addIcon(0.65,0.05,"assets/UI/PopInBuilt/PopInHeaderNiches.png","categoryHeader",this,false);
	this.addIcon(0.09,0.15,"assets/UI/PopIn/PopInScrollBackground.png","contentBackground",this,false);
	this.addIcon(-0.02,0.17,"assets/UI/PopInBuilt/PopInOngletNicheNormal.png","nicheTab",this,true,"assets/UI/PopInBuilt/PopInOngletNicheActive.png");
	this.addIcon(-0.02,0.29,"assets/UI/PopInBuilt/PopInOngletFuseeNormal.png","spaceshipTab",this,true,"assets/UI/PopInBuilt/PopInOngletFuseeActive.png");
	this.addIcon(-0.02,0.41,"assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png","utilitairesTab",this,true,"assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png");
	this.addIcon(0.95,0,"assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","closeButton",this,true,"assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png");
	this.addContainer("verticalScroller",this,0,0);
	this.addMask(this.childs.get("contentBackground").x,this.childs.get("contentBackground").y + 3,this.childs.get("contentBackground").width,this.childs.get("contentBackground").height - 6,this.containers.get("verticalScroller"));
	this.addBuildArticles(GameInfo.buildMenuArticles.niches);
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
			this.addIcon(0.125,0.175 + y,"assets/UI/PopInBuilt/PopInBuiltBgArticle.png","articleBase",this.containers.get("verticalScroller"),false);
			this.addIcon(0.697,0.309 + y,"assets/UI/PopInBuilt/PopInBuiltSoftNormal.png","buildSoft",this.containers.get("verticalScroller"),true);
			this.addIcon(0.825,0.309 + y,"assets/UI/PopInBuilt/PopInBuiltHardNormal.png","buildHard",this.containers.get("verticalScroller"),true);
			this.addIcon(0.14,0.1875 + y,"assets/UI/Icons/Buildings/" + Std.string(i.img) + ".png","ArticlePreview",this.containers.get("verticalScroller"),false);
			this.addIcon(0.758,0.3 + y,"assets/UI/Icons/IconsRessources/IconOsDor.png","HardRessource",this.containers.get("verticalScroller"),false);
			this.addText(0.78,0.34 + y,"FuturaStdHeavy","15px",i.hardPrice,"HardRessourcePrice",this.containers.get("verticalScroller"));
			var _g2 = 0;
			var _g1 = ressources.length;
			while(_g2 < _g1) {
				var j = _g2++;
				this.addIcon(0.308 + 0.065 * j,0.3 + y,"assets/UI/Icons/IconsRessources/" + ressources[j].img + ".png","SoftRessource" + j,this.containers.get("verticalScroller"),false);
				this.addText(0.315 + 0.065 * j,0.34 + y,"FuturaStdHeavy","15px",ressources[j].price,"SoftRessourcePrice" + j,this.containers.get("verticalScroller"));
			}
			if((cpt * (this.articleHeight + this.articleInterline) + this.articleHeight) * this.background.height > this.childs.get("contentBackground").height) {
				this.addVerticalScrollBar();
				this.hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}
	,childClick: function(pEvent) {
		if(pEvent.target._name == "closeButton") popin.PopinManager.getInstance().closePopin("PopinBuild"); else if(pEvent.target._name == "nicheTab" && this.currentTab != "nicheTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.niches);
			this.currentTab = "nicheTab";
		} else if(pEvent.target._name == "spaceshipTab" && this.currentTab != "spaceshipTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.spacechips);
			this.currentTab = "spaceshipTab";
		} else if(pEvent.target._name == "utilitairesTab" && this.currentTab != "utilitairesTab") {
			this.containers.get("verticalScroller").children = [];
			this.containers.get("verticalScroller").position.set(0,0);
			this.addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
			this.currentTab = "utilitairesTab";
		} else if(pEvent.target._name == "buildSoft") {
			var index = Math.round(((pEvent.target.y + this.background.height / 2) / this.background.height - 0.309) / (this.articleHeight + this.articleInterline));
			if(this.currentTab == "nicheTab") haxe.Log.trace("trying to buy the article : " + index + " here's the ressources needed : ",{ fileName : "PopinBuild.hx", lineNumber : 95, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.niches[index].ressources]}); else if(this.currentTab == "spaceshipTab") haxe.Log.trace("trying to buy the article : " + index + " here's the ressources needed : ",{ fileName : "PopinBuild.hx", lineNumber : 97, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.spacechips[index].ressources]}); else if(this.currentTab == "utilitairesTab") haxe.Log.trace("trying to buy the article : " + index + " here's the ressources needed : ",{ fileName : "PopinBuild.hx", lineNumber : 99, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.utilitaires[index].ressources]});
		} else if(pEvent.target._name == "buildHard") {
			var index1 = Math.round(((pEvent.target.y + this.background.height / 2) / this.background.height - 0.309) / (this.articleHeight + this.articleInterline));
			if(this.currentTab == "nicheTab") haxe.Log.trace("trying to buy the article : " + index1 + " here's the hard price : ",{ fileName : "PopinBuild.hx", lineNumber : 105, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.niches[index1].hardPrice]}); else if(this.currentTab == "spaceshipTab") haxe.Log.trace("trying to buy the article : " + index1 + " here's the hard price : ",{ fileName : "PopinBuild.hx", lineNumber : 107, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.spacechips[index1].hardPrice]}); else if(this.currentTab == "utilitairesTab") haxe.Log.trace("trying to buy the article : " + index1 + " here's the hard price : ",{ fileName : "PopinBuild.hx", lineNumber : 109, className : "popin.PopinBuild", methodName : "childClick", customParams : [GameInfo.buildMenuArticles.utilitaires[index1].hardPrice]});
		}
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
	}
	,__class__: scenes.GameScene
});
scenes.LoaderScene = function() {
	pixi.display.DisplayObjectContainer.call(this);
	this.x = 0;
	this.y = 0;
	var img = new PIXI.Sprite(PIXI.Texture.fromImage("assets/UI/SplashScreen/IconsSplash.jpg"));
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
		var int11 = 2;
		$r = int11 < 0?4294967296.0 + int11:int11 + 0.0;
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
GameInfo.preloadAssets = ["assets/UI/SplashScreen/IconsSplash.jpg"];
GameInfo.loadAssets = ["assets/Dogs/DogCasino.png","assets/Dogs/DogChurch.png","assets/Dogs/DogHangarWorkshop.png","assets/Dogs/DogMusee.png","assets/Dogs/DogNiche.png","assets/Dogs/DogPasDeTir.png","assets/UI/Bulles/HudBulle.png","assets/UI/Cursor/curseur_down.png","assets/UI/Cursor/curseur_up.png","assets/UI/Hud/HudBuildFill.png","assets/UI/Hud/HudBuildFillBar.png","assets/UI/Hud/HudIconBuild.png","assets/UI/Hud/HudIconBuildActive.png","assets/UI/Hud/HudIconBuildNormal.png","assets/UI/Hud/HudIconDestroyActive.png","assets/UI/Hud/HudIconDestroyNormal.png","assets/UI/Hud/HudIconInventory.png","assets/UI/Hud/HudIconInventoryActive.png","assets/UI/Hud/HudIconInventoryNormal.png","assets/UI/Hud/HudIconMarketActive.png","assets/UI/Hud/HudIconMarketNormal.png","assets/UI/Hud/HudIconObservatoryActive.png","assets/UI/Hud/HudIconObservatoryNormal.png","assets/UI/Hud/HudIconOptionActive.png","assets/UI/Hud/HudIconOptionNormal.png","assets/UI/Hud/HudIconPop.png","assets/UI/Hud/HudIconQuestActive.png","assets/UI/Hud/HudIconQuestNormal.png","assets/UI/Hud/HudIconShopActive.png","assets/UI/Hud/HudIconShopNormal.png","assets/UI/Hud/HudInventoryFill.png","assets/UI/Hud/HudInventoryFillBar.png","assets/UI/Hud/HudMoneyHard.png","assets/UI/Hud/HudMoneySoft.png","assets/UI/Hud/HudPopFill.png","assets/UI/Hud/HudPopFillBar.png","assets/UI/Icons/Artefacts/IconArtefactsDbz1.png","assets/UI/Icons/Artefacts/IconArtefactsDbz2.png","assets/UI/Icons/Artefacts/IconArtefactsDbz3.png","assets/UI/Icons/Artefacts/IconArtefactsLotr1.png","assets/UI/Icons/Artefacts/IconArtefactsLotr2.png","assets/UI/Icons/Artefacts/IconArtefactsLotr3.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons1.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons2.png","assets/UI/Icons/Artefacts/IconArtefactsSimpsons3.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars1.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars2.png","assets/UI/Icons/Artefacts/IconArtefactsStarwars3.png","assets/UI/Icons/Artefacts/IconArtefactsTerre1.png","assets/UI/Icons/Artefacts/IconArtefactsTerre2.png","assets/UI/Icons/Artefacts/IconArtefactsTerre3.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland1.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland2.png","assets/UI/Icons/Artefacts/IconArtefactsWonderland3.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewCasino.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEglise.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewEntrepot.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar1.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar2.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar3.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar4.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar5.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewHangar6.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewLabo.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewMusee.png","assets/UI/Icons/Buildings/PopInBuiltArticlePreviewNiche.png","assets/UI/Icons/Dogs/IconDogAstro.png","assets/UI/Icons/Dogs/IconDogCasino.png","assets/UI/Icons/Dogs/IconDogChurch.png","assets/UI/Icons/Dogs/IconDogMusee.png","assets/UI/Icons/Dogs/IconDogNiche.png","assets/UI/Icons/Dogs/IconDogWorkshop.png","assets/UI/Icons/Fusee/Bleu3.png","assets/UI/Icons/Fusee/IconFuseeBleu1.png","assets/UI/Icons/Fusee/IconFuseeBleu2.png","assets/UI/Icons/Fusee/IconFuseeCyan1.png","assets/UI/Icons/Fusee/IconFuseeCyan2.png","assets/UI/Icons/Fusee/IconFuseeCyan3.png","assets/UI/Icons/Fusee/IconFuseeFB1.png","assets/UI/Icons/Fusee/IconFuseeFB2.png","assets/UI/Icons/Fusee/IconFuseeFB3.png","assets/UI/Icons/Fusee/IconFuseeJaune1.png","assets/UI/Icons/Fusee/IconFuseeJaune2.png","assets/UI/Icons/Fusee/IconFuseeJaune3.png","assets/UI/Icons/Fusee/IconFuseeOrange1.png","assets/UI/Icons/Fusee/IconFuseeOrange2.png","assets/UI/Icons/Fusee/IconFuseeOrange3.png","assets/UI/Icons/Fusee/IconFuseeVert1.png","assets/UI/Icons/Fusee/IconFuseeVert2.png","assets/UI/Icons/Fusee/IconFuseeVert3.png","assets/UI/Icons/Fusee/IconFuseeViolet1.png","assets/UI/Icons/Fusee/IconFuseeViolet2.png","assets/UI/Icons/Fusee/IconFuseeViolet3.png","assets/UI/Icons/IconsRessources/IconBlueMineral.png","assets/UI/Icons/IconsRessources/IconCyanMineral.png","assets/UI/Icons/IconsRessources/IconDogeflooz.png","assets/UI/Icons/IconsRessources/IconGreenMineral.png","assets/UI/Icons/IconsRessources/IconOsDor.png","assets/UI/Icons/IconsRessources/IconPurpleMineral.png","assets/UI/Icons/IconsRessources/IconRedMineral.png","assets/UI/Icons/IconsRessources/IconYellowMineral.png","assets/UI/Icons/Planet/IconNamek.png","assets/UI/Icons/Planet/IconPlaneteDesEtoiles.png","assets/UI/Icons/Planet/IconPlaneteMilieu.png","assets/UI/Icons/Planet/IconSpringfield.png","assets/UI/Icons/Planet/IconTerre.png","assets/UI/Icons/Planet/IconWonderland.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewBlueMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewCyanMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewGreenMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewPurpleMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewRedMineral.png","assets/UI/Icons/PreviewRessources/PopInMarketArticlePreviewYellowMineral.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview2Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview3Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview4Os.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Dogeflooz.png","assets/UI/Icons/PreviewRessources/PopInShopArticlePreview5Os.png","assets/UI/PopIn/ContourNotAfford.png","assets/UI/PopIn/ContourRessourceInsuffisant.png","assets/UI/PopIn/Overlay.png","assets/UI/PopIn/PopInArticleLock.png","assets/UI/PopIn/PopInBackground.png","assets/UI/PopIn/PopInCloseButtonActivel.png","assets/UI/PopIn/PopInCloseButtonNormal.png","assets/UI/PopIn/PopInScrollBackground.png","assets/UI/PopIn/PopInScrollOverlay.png","assets/UI/PopIn/PopInScrollingBar.png","assets/UI/PopIn/PopInScrollingTruc.png","assets/UI/PopInBuilt/PopInBuiltArticleEmptyRessource.png","assets/UI/PopInBuilt/PopInBuiltBgArticle.png","assets/UI/PopInBuilt/PopInBuiltHardActive.png","assets/UI/PopInBuilt/PopInBuiltHardNormal.png","assets/UI/PopInBuilt/PopInBuiltSoftActive.png","assets/UI/PopInBuilt/PopInBuiltSoftNormal.png","assets/UI/PopInBuilt/PopInBuiltSoftNotDispo.png","assets/UI/PopInBuilt/PopInHeaderFusees.png","assets/UI/PopInBuilt/PopInHeaderNiches.png","assets/UI/PopInBuilt/PopInHeaderUtilitaires.png","assets/UI/PopInBuilt/PopInOngletFuseeActive.png","assets/UI/PopInBuilt/PopInOngletFuseeNormal.png","assets/UI/PopInBuilt/PopInOngletNicheActive.png","assets/UI/PopInBuilt/PopInOngletNicheNormal.png","assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png","assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png","assets/UI/PopInBuilt/PopInTitleConstruction.png","assets/UI/PopInInventory/PopInInventoryArticleBg.png","assets/UI/PopInInventory/PopInInventoryBackground.png","assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png","assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png","assets/UI/PopInInventory/PopInInventoryScrollingBar.png","assets/UI/PopInInventory/PopInInventoryScrollingTruc.png","assets/UI/PopInInventory/PopInInventoryTitle.png","assets/UI/PopInMarket/PopInHeaderBuy.png","assets/UI/PopInMarket/PopInHeaderSell.png","assets/UI/PopInMarket/PopInMarketBgArticle.png","assets/UI/PopInMarket/PopInMarketNbArticleActivel.png","assets/UI/PopInMarket/PopInMarketNbArticleNormal.png","assets/UI/PopInMarket/PopInMarketValidActive.png","assets/UI/PopInMarket/PopInMarketValidNormal.png","assets/UI/PopInMarket/PopInOngletBuyActive.png","assets/UI/PopInMarket/PopInOngletBuyNormal.png","assets/UI/PopInMarket/PopInOngletSellActive.png","assets/UI/PopInMarket/PopInOngletSellNormal.png","assets/UI/PopInMarket/PopInTitleMarket.png","assets/UI/PopInObservatory/PopInObservatoryArticle.png","assets/UI/PopInObservatory/PopInScrollOverlay.png","assets/UI/PopInObservatory/PopInScrollingBar.png","assets/UI/PopInObservatory/PopInScrollingTruc.png","assets/UI/PopInObservatory/PopInTitleObservatory.png","assets/UI/PopInQuest/PopInQuestBgArticle.png","assets/UI/PopInQuest/PopInQuestOngletEnCoursActive.png","assets/UI/PopInQuest/PopInQuestOngletEnCoursNormal.png","assets/UI/PopInQuest/PopInQuestOngletFinishActive.png","assets/UI/PopInQuest/PopInQuestOngletFinishNormal.png","assets/UI/PopInQuest/PopInTitleQuest.png","assets/UI/PopInSocial/PopInShop/PopInHeaderDogflooz.png","assets/UI/PopInSocial/PopInShop/PopInHeaderOsDOr.png","assets/UI/PopInSocial/PopInShop/PopInMarketValidActive.png","assets/UI/PopInSocial/PopInShop/PopInMarketValidNormal.png","assets/UI/PopInSocial/PopInShop/PopInOngletHardActive.png","assets/UI/PopInSocial/PopInShop/PopInOngletHardNormal.png","assets/UI/PopInSocial/PopInShop/PopInOngletSoftActive.png","assets/UI/PopInSocial/PopInShop/PopInOngletSotNormal.png","assets/UI/PopInSocial/PopInShop/PopInShopBgArticle.png","assets/UI/PopInSocial/PopInShop/PopInShopButtonConfirmActive.png","assets/UI/PopInSocial/PopInShop/PopInShopButtonConfirmNormal.png","assets/UI/PopInSocial/PopInShop/PopInTitleShop.png","assets/UI/PopInSocial/PopInSocialArticleBg.png","assets/UI/PopInSocial/PopInSocialBg.png","assets/UI/PopInSocial/PopInSocialButtonDownActivel.png","assets/UI/PopInSocial/PopInSocialButtonDownNormal.png","assets/UI/PopInSocial/PopInSocialButtonTradeActivel.png","assets/UI/PopInSocial/PopInSocialButtonTradeNormal.png","assets/UI/PopInSocial/PopInSocialButtonUpActive.png","assets/UI/PopInSocial/PopInSocialButtonUpNormal.png","assets/UI/PopInSocial/PopInSocialButtonVisitActive.png","assets/UI/PopInSocial/PopInSocialButtonVisitNormal.png","assets/UI/PopInSocial/PopInSocialPhotoBorders.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyBlue3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyCyan3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyFb3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyRed3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyVert3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet1.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyViolet3.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow2.png","assets/UI/PopInWorkshop/FuseeNotReady/PopInWorkshopFuseeNotReadyYellow3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyBlue3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyCyan3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyFb3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyRed3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyVert3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet0.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyViolet3.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow1.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow2.png","assets/UI/PopInWorkshop/FuseeReady/PopInWorkshopFuseeReadyYellow3.png","assets/UI/PopInWorkshop/PopInTitleWorkshop.png","assets/UI/PopInWorkshop/PopInWorkshopArticleBG.png","assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png","assets/UI/PopInWorkshop/PopInWorkshopCancelButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopCancelButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopDestroyButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopHeader.png","assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonActive.png","assets/UI/PopInWorkshop/PopInWorkshopLaunchButtonNormal.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFill1.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFill2.png","assets/UI/PopInWorkshop/PopInWorkshopLoadFillBar.png","assets/UI/PopInWorkshop/PopInWorkshopLoadIcon.png","assets/UI/PopInWorkshop/PopInWorkshopParticule.png","assets/UI/PopInWorkshop/PopInWorkshopTextBG.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle01.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle02.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle03.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle04.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle05.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle06.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle07.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle08.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle09.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerIdle10.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick01.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick02.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick03.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick04.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick05.png","assets/UI/PopInWorkshop/hammer/PopInWorkshopHammerOnClick06.png","assets/UI/SplashScreen/LoadingFill01.png","assets/UI/SplashScreen/LoadingFill02.png","assets/UI/SplashScreen/LoadingFill03.png","assets/UI/SplashScreen/LoadingFillBar.png","assets/UI/SplashScreen/Planet.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow01.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow02.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow03.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow04.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow05.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow06.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow07.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow08.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow09.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow10.png","assets/UI/SplashScreen/PlanetGlow/PlanetGlow11.png","assets/UI/SplashScreen/PlanetLight.png","assets/UI/SplashScreen/Title.png"];
GameInfo.buildMenuArticles = { niches : [{ img : "PopInBuiltArticlePreviewNiche", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]}], spacechips : [{ img : "PopInBuiltArticlePreviewHangar1", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewHangar2", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewHangar3", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewHangar4", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewHangar5", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]}], utilitaires : [{ img : "PopInBuiltArticlePreviewCasino", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewEglise", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]},{ img : "PopInBuiltArticlePreviewEntrepot", hardPrice : 3, ressources : [{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"},{ img : "IconDogeflooz", price : "1000"}]}]};
GameInfo.userWidth = 1920;
GameInfo.userHeight = 1000;
GameInfo.fric = 15000;
GameInfo.hardMoney = 150;
GameInfo.dogeNumber = 20;
GameInfo.dogeMaxNumber = 25;
GameInfo.stockPercent = 50;
Main.CONFIG_PATH = "config.json";
sprites.Ambulance.images = ["E","SE","S","SW","W","NW","N","NE"];
utils.events.Event.COMPLETE = "Event.COMPLETE";
utils.events.Event.GAME_LOOP = "Event.GAME_LOOP";
utils.events.Event.RESIZE = "Event.RESIZE";
Main.main();
})();

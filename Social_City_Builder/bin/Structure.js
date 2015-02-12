(function () { "use strict";
var $hxClasses = {};
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
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
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
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
var com = {};
com.isartdigital = {};
com.isartdigital.utils = {};
com.isartdigital.utils.events = {};
com.isartdigital.utils.events.IEventDispatcher = function() { };
$hxClasses["com.isartdigital.utils.events.IEventDispatcher"] = com.isartdigital.utils.events.IEventDispatcher;
com.isartdigital.utils.events.IEventDispatcher.__name__ = ["com","isartdigital","utils","events","IEventDispatcher"];
com.isartdigital.utils.events.IEventDispatcher.prototype = {
	__class__: com.isartdigital.utils.events.IEventDispatcher
};
com.isartdigital.utils.events.EventDispatcher = function() {
	this.listeners = [];
};
$hxClasses["com.isartdigital.utils.events.EventDispatcher"] = com.isartdigital.utils.events.EventDispatcher;
com.isartdigital.utils.events.EventDispatcher.__name__ = ["com","isartdigital","utils","events","EventDispatcher"];
com.isartdigital.utils.events.EventDispatcher.__interfaces__ = [com.isartdigital.utils.events.IEventDispatcher];
com.isartdigital.utils.events.EventDispatcher.prototype = {
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
	,__class__: com.isartdigital.utils.events.EventDispatcher
};
com.isartdigital.Main = function() {
	com.isartdigital.utils.events.EventDispatcher.call(this);
	this.stage = new PIXI.Stage(4160694);
	this.renderer = PIXI.autoDetectRenderer((function($this) {
		var $r;
		var this1 = com.isartdigital.utils.system.DeviceCapabilities.get_width();
		var $int = this1;
		$r = $int < 0?4294967296.0 + $int:$int + 0.0;
		return $r;
	}(this)),(function($this) {
		var $r;
		var this11 = com.isartdigital.utils.system.DeviceCapabilities.get_height();
		var int1 = this11;
		$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
		return $r;
	}(this)));
	window.document.body.appendChild(this.renderer.view);
	window.requestAnimationFrame($bind(this,this.gameLoop));
	var lConfig = new PIXI.JsonLoader("config.json");
	lConfig.addEventListener("loaded",$bind(this,this.preloadAssets));
	lConfig.load();
};
$hxClasses["com.isartdigital.Main"] = com.isartdigital.Main;
com.isartdigital.Main.__name__ = ["com","isartdigital","Main"];
com.isartdigital.Main.main = function() {
	com.isartdigital.Main.getInstance();
};
com.isartdigital.Main.getInstance = function() {
	if(com.isartdigital.Main.instance == null) com.isartdigital.Main.instance = new com.isartdigital.Main();
	return com.isartdigital.Main.instance;
};
com.isartdigital.Main.__super__ = com.isartdigital.utils.events.EventDispatcher;
com.isartdigital.Main.prototype = $extend(com.isartdigital.utils.events.EventDispatcher.prototype,{
	getStage: function() {
		return this.stage;
	}
	,preloadAssets: function(pEvent) {
		pEvent.target.removeEventListener("loaded",$bind(this,this.preloadAssets));
		com.isartdigital.utils.Config.init((js.Boot.__cast(pEvent.target , PIXI.JsonLoader)).json);
		com.isartdigital.utils.game.GameStage.getInstance().set_scaleMode(com.isartdigital.utils.game.GameStageScale.NO_SCALE);
		com.isartdigital.utils.game.GameStage.getInstance().init($bind(this,this.render),400,300,true);
		this.stage.addChild(com.isartdigital.utils.game.GameStage.getInstance());
		window.addEventListener("resize",$bind(this,this.resize));
		this.resize();
		var lAssets = [];
		lAssets.push("assets/preload.png");
		lAssets.push("assets/preload_bg.png");
		var lLoader = new PIXI.AssetLoader(lAssets);
		lLoader.addEventListener("onComplete",$bind(this,this.loadAssets));
		lLoader.load();
	}
	,loadAssets: function(pEvent) {
		pEvent.target.removeEventListener("onComplete",$bind(this,this.loadAssets));
		var lAssets = [];
		lAssets.push("assets/TitleCard.png");
		lAssets.push("assets/HudBuild.png");
		lAssets.push("assets/Screen0.png");
		lAssets.push("assets/Screen1.png");
		lAssets.push("assets/Popin0.png");
		lAssets.push("assets/Popin1.png");
		lAssets.push("assets/PopinOkCancel.png");
		lAssets.push("assets/alpha_bg.png");
		lAssets.push("assets/black_bg.png");
		lAssets.push("assets/game.png");
		lAssets.push("assets/Hud_TL.png");
		lAssets.push("assets/Hud_TR.png");
		lAssets.push("assets/Hud_B.png");
		lAssets.push("assets/closeButton.png");
		lAssets.push("assets/ambulance.json");
		var lLoader = new PIXI.AssetLoader(lAssets);
		lLoader.addEventListener("onProgress",$bind(this,this.onLoadProgress));
		lLoader.addEventListener("onComplete",$bind(this,this.onLoadComplete));
		com.isartdigital.myGame.ui.UIManager.getInstance().openScreen(com.isartdigital.myGame.ui.GraphicLoader.getInstance());
		lLoader.load();
	}
	,onLoadProgress: function(pEvent) {
		var lLoader;
		lLoader = js.Boot.__cast(pEvent.target , PIXI.AssetLoader);
		com.isartdigital.myGame.ui.GraphicLoader.getInstance().update((lLoader.assetURLs.length - lLoader.loadCount) / lLoader.assetURLs.length);
	}
	,onLoadComplete: function(pEvent) {
		pEvent.target.removeEventListener("onProgress",$bind(this,this.onLoadProgress));
		pEvent.target.removeEventListener("onComplete",$bind(this,this.onLoadComplete));
		com.isartdigital.myGame.ui.UIManager.getInstance().openScreen(com.isartdigital.myGame.ui.screens.TitleCard.getInstance());
	}
	,gameLoop: function() {
		window.requestAnimationFrame($bind(this,this.gameLoop));
		this.render();
		this.dispatchEvent(new com.isartdigital.utils.events.Event("Event.GAME_LOOP"));
	}
	,resize: function(pEvent) {
		this.renderer.resize((function($this) {
			var $r;
			var this1 = com.isartdigital.utils.system.DeviceCapabilities.get_width();
			var $int = this1;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)),(function($this) {
			var $r;
			var this11 = com.isartdigital.utils.system.DeviceCapabilities.get_height();
			var int1 = this11;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)));
		com.isartdigital.utils.game.GameStage.getInstance().resize();
	}
	,render: function() {
		this.renderer.render(this.stage);
	}
	,destroy: function() {
		window.removeEventListener("resize",$bind(this,this.resize));
		com.isartdigital.Main.instance = null;
		com.isartdigital.utils.events.EventDispatcher.prototype.destroy.call(this);
	}
	,__class__: com.isartdigital.Main
});
com.isartdigital.utils.game = {};
com.isartdigital.utils.game.IAction = function() { };
$hxClasses["com.isartdigital.utils.game.IAction"] = com.isartdigital.utils.game.IAction;
com.isartdigital.utils.game.IAction.__name__ = ["com","isartdigital","utils","game","IAction"];
com.isartdigital.utils.game.IAction.prototype = {
	__class__: com.isartdigital.utils.game.IAction
};
com.isartdigital.myGame = {};
com.isartdigital.myGame.game = {};
com.isartdigital.myGame.game.GameManager = function() {
	this.background = new PIXI.Sprite(PIXI.Texture.fromImage("assets/game.png"));
	this.background.anchor.set(0.5,0.5);
};
$hxClasses["com.isartdigital.myGame.game.GameManager"] = com.isartdigital.myGame.game.GameManager;
com.isartdigital.myGame.game.GameManager.__name__ = ["com","isartdigital","myGame","game","GameManager"];
com.isartdigital.myGame.game.GameManager.__interfaces__ = [com.isartdigital.utils.game.IAction];
com.isartdigital.myGame.game.GameManager.getInstance = function() {
	if(com.isartdigital.myGame.game.GameManager.instance == null) com.isartdigital.myGame.game.GameManager.instance = new com.isartdigital.myGame.game.GameManager();
	return com.isartdigital.myGame.game.GameManager.instance;
};
com.isartdigital.myGame.game.GameManager.prototype = {
	start: function() {
		com.isartdigital.utils.game.GameStage.getInstance().getGameContainer().addChild(this.background);
		var lAmbulance = new com.isartdigital.myGame.game.sprites.Ambulance();
		com.isartdigital.utils.game.GameStage.getInstance().getGameContainer().addChild(lAmbulance);
		lAmbulance.position.set(100,100);
		com.isartdigital.myGame.ui.UIManager.getInstance().startGame();
		com.isartdigital.Main.getInstance().addEventListener("Event.GAME_LOOP",$bind(this,this.doAction));
		var lTL = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		lTL.anchor.set(0.5,0.5);
		com.isartdigital.utils.game.GameStage.getInstance().addChild(lTL);
		var lTR = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		com.isartdigital.utils.game.GameStage.getInstance().addChild(lTR);
		lTR.x = com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().width;
		var lBL = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		lBL.anchor.set(0.5,0.5);
		com.isartdigital.utils.game.GameStage.getInstance().addChild(lBL);
		lBL.y = com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().height;
		var lBR = new PIXI.Sprite(PIXI.Texture.fromImage("assets/alpha_bg.png"));
		lBR.anchor.set(0.5,0.5);
		com.isartdigital.utils.game.GameStage.getInstance().addChild(lBR);
		lBR.x = com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().width;
		lBR.y = com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().height;
	}
	,doAction: function() {
	}
	,destroy: function() {
		com.isartdigital.Main.getInstance().removeEventListener("Event.GAME_LOOP",$bind(this,this.doAction));
		com.isartdigital.myGame.game.GameManager.instance = null;
	}
	,__class__: com.isartdigital.myGame.game.GameManager
};
com.isartdigital.myGame.game.sprites = {};
com.isartdigital.myGame.game.sprites.Ambulance = function() {
	PIXI.MovieClip.call(this,com.isartdigital.myGame.game.sprites.Ambulance.getTexture());
	this.anchor.set(0.5,0.5);
	this.animationSpeed = 0.2;
	this.play();
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
};
$hxClasses["com.isartdigital.myGame.game.sprites.Ambulance"] = com.isartdigital.myGame.game.sprites.Ambulance;
com.isartdigital.myGame.game.sprites.Ambulance.__name__ = ["com","isartdigital","myGame","game","sprites","Ambulance"];
com.isartdigital.myGame.game.sprites.Ambulance.getTexture = function() {
	var lTexture = new Array();
	var _g1 = 0;
	var _g = com.isartdigital.myGame.game.sprites.Ambulance.images.length;
	while(_g1 < _g) {
		var i = _g1++;
		lTexture.push(PIXI.Texture.fromFrame("ambulance_" + com.isartdigital.myGame.game.sprites.Ambulance.images[i] + ".png"));
	}
	return lTexture;
};
com.isartdigital.myGame.game.sprites.Ambulance.__super__ = PIXI.MovieClip;
com.isartdigital.myGame.game.sprites.Ambulance.prototype = $extend(PIXI.MovieClip.prototype,{
	onClick: function(pData) {
		com.isartdigital.myGame.ui.popin.PopinManager.getInstance().openPopin("PopinBuild",com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().width / 2,com.isartdigital.utils.game.GameStage.getInstance().get_safeZone().width / 2);
	}
	,__class__: com.isartdigital.myGame.game.sprites.Ambulance
});
com.isartdigital.utils.ui = {};
com.isartdigital.utils.ui.UIComponent = function() {
	this.modalImage = "assets/alpha_bg.png";
	this._modal = true;
	PIXI.DisplayObjectContainer.call(this);
};
$hxClasses["com.isartdigital.utils.ui.UIComponent"] = com.isartdigital.utils.ui.UIComponent;
com.isartdigital.utils.ui.UIComponent.__name__ = ["com","isartdigital","utils","ui","UIComponent"];
com.isartdigital.utils.ui.UIComponent.__super__ = PIXI.DisplayObjectContainer;
com.isartdigital.utils.ui.UIComponent.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	open: function() {
		if(this.isOpened) return;
		this.isOpened = true;
		this.set_modal(this._modal);
		com.isartdigital.utils.game.GameStage.getInstance().addEventListener("GameStageEvent.RESIZE",$bind(this,this.onResize));
		this.onResize();
	}
	,get_modal: function() {
		return this._modal;
	}
	,set_modal: function(pModal) {
		this._modal = pModal;
		if(this._modal) {
			if(this.modalZone == null) {
				this.modalZone = new PIXI.Sprite(PIXI.Texture.fromImage(this.modalImage));
				this.modalZone.interactive = true;
				this.modalZone.click = $bind(this,this.stopPropagation);
			}
			if(this.parent != null) this.parent.addChildAt(this.modalZone,this.parent.getChildIndex(this));
		} else if(this.modalZone != null) {
			if(this.modalZone.parent != null) this.modalZone.parent.removeChild(this.modalZone);
			this.modalZone = null;
		}
		return this._modal;
	}
	,stopPropagation: function(pEvent) {
	}
	,close: function() {
		if(!this.isOpened) return;
		this.isOpened = false;
		this.set_modal(false);
		this.destroy();
	}
	,onResize: function(pEvent) {
		if(this.get_modal()) com.isartdigital.myGame.ui.UIManager.getInstance().setPosition(this.modalZone,com.isartdigital.utils.ui.UIPosition.FIT_SCREEN);
	}
	,destroy: function() {
		this.close();
	}
	,__class__: com.isartdigital.utils.ui.UIComponent
});
com.isartdigital.utils.ui.Screen = function() {
	com.isartdigital.utils.ui.UIComponent.call(this);
	this.modalImage = "assets/black_bg.png";
};
$hxClasses["com.isartdigital.utils.ui.Screen"] = com.isartdigital.utils.ui.Screen;
com.isartdigital.utils.ui.Screen.__name__ = ["com","isartdigital","utils","ui","Screen"];
com.isartdigital.utils.ui.Screen.__super__ = com.isartdigital.utils.ui.UIComponent;
com.isartdigital.utils.ui.Screen.prototype = $extend(com.isartdigital.utils.ui.UIComponent.prototype,{
	__class__: com.isartdigital.utils.ui.Screen
});
com.isartdigital.myGame.ui = {};
com.isartdigital.myGame.ui.GraphicLoader = function() {
	com.isartdigital.utils.ui.Screen.call(this);
	var lBg = new PIXI.Sprite(PIXI.Texture.fromImage("assets/preload_bg.png"));
	lBg.anchor.set(0.5,0.5);
	this.addChild(lBg);
	this.loaderBar = new PIXI.Sprite(PIXI.Texture.fromImage("assets/preload.png"));
	this.loaderBar.anchor.y = 0.5;
	this.loaderBar.x = -this.loaderBar.width / 2;
	this.addChild(this.loaderBar);
	this.loaderBar.scale.x = 0;
};
$hxClasses["com.isartdigital.myGame.ui.GraphicLoader"] = com.isartdigital.myGame.ui.GraphicLoader;
com.isartdigital.myGame.ui.GraphicLoader.__name__ = ["com","isartdigital","myGame","ui","GraphicLoader"];
com.isartdigital.myGame.ui.GraphicLoader.getInstance = function() {
	if(com.isartdigital.myGame.ui.GraphicLoader.instance == null) com.isartdigital.myGame.ui.GraphicLoader.instance = new com.isartdigital.myGame.ui.GraphicLoader();
	return com.isartdigital.myGame.ui.GraphicLoader.instance;
};
com.isartdigital.myGame.ui.GraphicLoader.__super__ = com.isartdigital.utils.ui.Screen;
com.isartdigital.myGame.ui.GraphicLoader.prototype = $extend(com.isartdigital.utils.ui.Screen.prototype,{
	update: function(pProgress) {
		this.loaderBar.scale.x = pProgress;
	}
	,destroy: function() {
		com.isartdigital.myGame.ui.GraphicLoader.instance = null;
		com.isartdigital.utils.ui.Screen.prototype.destroy.call(this);
	}
	,__class__: com.isartdigital.myGame.ui.GraphicLoader
});
com.isartdigital.myGame.ui.IconHud = function(startX,startY,texture) {
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
$hxClasses["com.isartdigital.myGame.ui.IconHud"] = com.isartdigital.myGame.ui.IconHud;
com.isartdigital.myGame.ui.IconHud.__name__ = ["com","isartdigital","myGame","ui","IconHud"];
com.isartdigital.myGame.ui.IconHud.__super__ = PIXI.Sprite;
com.isartdigital.myGame.ui.IconHud.prototype = $extend(PIXI.Sprite.prototype,{
	onClick: function(pData) {
	}
	,onMouseOver: function(pData) {
	}
	,__class__: com.isartdigital.myGame.ui.IconHud
});
com.isartdigital.myGame.ui.IconPopin = function(pX,pY,pTexturePath,pName,isInteractive) {
	PIXI.Sprite.call(this,PIXI.Texture.fromImage("assets/" + pTexturePath + ".png"));
	this.x = pX;
	this.y = pY;
	this.name = pName;
	this.interactive = isInteractive;
	this.buttonMode = isInteractive;
};
$hxClasses["com.isartdigital.myGame.ui.IconPopin"] = com.isartdigital.myGame.ui.IconPopin;
com.isartdigital.myGame.ui.IconPopin.__name__ = ["com","isartdigital","myGame","ui","IconPopin"];
com.isartdigital.myGame.ui.IconPopin.__super__ = PIXI.Sprite;
com.isartdigital.myGame.ui.IconPopin.prototype = $extend(PIXI.Sprite.prototype,{
	__class__: com.isartdigital.myGame.ui.IconPopin
});
com.isartdigital.myGame.ui.MyPopin = function(startX,startY,textureName,isModal) {
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
$hxClasses["com.isartdigital.myGame.ui.MyPopin"] = com.isartdigital.myGame.ui.MyPopin;
com.isartdigital.myGame.ui.MyPopin.__name__ = ["com","isartdigital","myGame","ui","MyPopin"];
com.isartdigital.myGame.ui.MyPopin.getInstance = function(startX,startY,textureName) {
	if(com.isartdigital.myGame.ui.MyPopin.instance == null) com.isartdigital.myGame.ui.MyPopin.instance = new com.isartdigital.myGame.ui.MyPopin(startX,startY,textureName);
	return com.isartdigital.myGame.ui.MyPopin.instance;
};
com.isartdigital.myGame.ui.MyPopin.__super__ = PIXI.DisplayObjectContainer;
com.isartdigital.myGame.ui.MyPopin.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	addIcon: function(x,y,textureName,name,isInteractive) {
		if(isInteractive == null) isInteractive = true;
		if(name == null) name = textureName;
		this.currentChild = new com.isartdigital.myGame.ui.IconPopin(x,y,textureName,name,isInteractive);
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
	,__class__: com.isartdigital.myGame.ui.MyPopin
});
com.isartdigital.myGame.ui.MyScreen = function() {
	com.isartdigital.utils.ui.Screen.call(this);
	var lCompleteClassName = Type.getClassName(Type.getClass(this));
	var lClassName;
	var pos = lCompleteClassName.lastIndexOf(".") + 1;
	lClassName = HxOverrides.substr(lCompleteClassName,pos,null);
	this.background = new PIXI.Sprite(PIXI.Texture.fromImage("assets/" + lClassName + ".png"));
	this.background.anchor.set(0.5,0.5);
	this.addChild(this.background);
	this.interactive = true;
	this.buttonMode = true;
	this.click = $bind(this,this.onClick);
};
$hxClasses["com.isartdigital.myGame.ui.MyScreen"] = com.isartdigital.myGame.ui.MyScreen;
com.isartdigital.myGame.ui.MyScreen.__name__ = ["com","isartdigital","myGame","ui","MyScreen"];
com.isartdigital.myGame.ui.MyScreen.__super__ = com.isartdigital.utils.ui.Screen;
com.isartdigital.myGame.ui.MyScreen.prototype = $extend(com.isartdigital.utils.ui.Screen.prototype,{
	onClick: function(pData) {
		console.log("click screen");
	}
	,__class__: com.isartdigital.myGame.ui.MyScreen
});
com.isartdigital.myGame.ui.UIManager = function() {
	this.popins = [];
};
$hxClasses["com.isartdigital.myGame.ui.UIManager"] = com.isartdigital.myGame.ui.UIManager;
com.isartdigital.myGame.ui.UIManager.__name__ = ["com","isartdigital","myGame","ui","UIManager"];
com.isartdigital.myGame.ui.UIManager.getInstance = function() {
	if(com.isartdigital.myGame.ui.UIManager.instance == null) com.isartdigital.myGame.ui.UIManager.instance = new com.isartdigital.myGame.ui.UIManager();
	return com.isartdigital.myGame.ui.UIManager.instance;
};
com.isartdigital.myGame.ui.UIManager.prototype = {
	openScreen: function(pScreen) {
		this.closeScreens();
		com.isartdigital.utils.game.GameStage.getInstance().getScreensContainer().addChild(pScreen);
		pScreen.open();
	}
	,closeScreens: function() {
		var lContainer = com.isartdigital.utils.game.GameStage.getInstance().getScreensContainer();
		while(lContainer.children.length > 0) {
			var lCurrent;
			lCurrent = js.Boot.__cast(lContainer.getChildAt(lContainer.children.length - 1) , com.isartdigital.utils.ui.Screen);
			lContainer.removeChild(lCurrent);
			lCurrent.close();
		}
	}
	,openPopin: function(pPopin) {
		this.popins.push(pPopin);
		com.isartdigital.utils.game.GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
	}
	,closeCurrentPopin: function() {
		if(this.popins.length == 0) return;
		var lCurrent = this.popins.pop();
		com.isartdigital.utils.game.GameStage.getInstance().getPopinsContainer().removeChild(lCurrent);
		lCurrent.close();
	}
	,openHud: function(pHUD) {
		com.isartdigital.utils.game.GameStage.getInstance().getHudContainer().addChild(pHUD);
	}
	,closeHud: function() {
		com.isartdigital.utils.game.GameStage.getInstance().getHudContainer().removeChild(com.isartdigital.myGame.ui.hud.HudManager.getInstance());
	}
	,setPosition: function(pTarget,pPosition,pOffsetX,pOffsetY) {
		if(pOffsetY == null) pOffsetY = 0;
		if(pOffsetX == null) pOffsetX = 0;
		if(pTarget.parent == null) return;
		var lTopLeft = new PIXI.Point(0,0);
		var lBottomRight = new PIXI.Point((function($this) {
			var $r;
			var this1 = com.isartdigital.utils.system.DeviceCapabilities.get_width();
			var $int = this1;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)),(function($this) {
			var $r;
			var this11 = com.isartdigital.utils.system.DeviceCapabilities.get_height();
			var int1 = this11;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)));
		lTopLeft = pTarget.parent.toLocal(lTopLeft);
		lBottomRight = pTarget.parent.toLocal(lBottomRight);
		if(pPosition == com.isartdigital.utils.ui.UIPosition.TOP || pPosition == com.isartdigital.utils.ui.UIPosition.TOP_LEFT || pPosition == com.isartdigital.utils.ui.UIPosition.TOP_RIGHT) pTarget.y = lTopLeft.y + pOffsetY;
		if(pPosition == com.isartdigital.utils.ui.UIPosition.BOTTOM || pPosition == com.isartdigital.utils.ui.UIPosition.BOTTOM_LEFT || pPosition == com.isartdigital.utils.ui.UIPosition.BOTTOM_RIGHT) pTarget.y = lBottomRight.y - pOffsetY;
		if(pPosition == com.isartdigital.utils.ui.UIPosition.LEFT || pPosition == com.isartdigital.utils.ui.UIPosition.TOP_LEFT || pPosition == com.isartdigital.utils.ui.UIPosition.BOTTOM_LEFT) pTarget.x = lTopLeft.x + pOffsetX;
		if(pPosition == com.isartdigital.utils.ui.UIPosition.RIGHT || pPosition == com.isartdigital.utils.ui.UIPosition.TOP_RIGHT || pPosition == com.isartdigital.utils.ui.UIPosition.BOTTOM_RIGHT) pTarget.x = lBottomRight.x - pOffsetX;
		if(pPosition == com.isartdigital.utils.ui.UIPosition.FIT_WIDTH || pPosition == com.isartdigital.utils.ui.UIPosition.FIT_SCREEN) {
			pTarget.x = lTopLeft.x;
			pTarget.width = lBottomRight.x - lTopLeft.x;
		}
		if(pPosition == com.isartdigital.utils.ui.UIPosition.FIT_HEIGHT || pPosition == com.isartdigital.utils.ui.UIPosition.FIT_SCREEN) {
			pTarget.y = lTopLeft.y;
			pTarget.height = lBottomRight.y - lTopLeft.y;
		}
	}
	,startGame: function() {
		this.closeScreens();
		com.isartdigital.utils.game.GameStage.getInstance().getHudContainer().addChild(com.isartdigital.myGame.ui.hud.HudManager.getInstance());
		com.isartdigital.myGame.ui.hud.HudManager.getInstance();
		com.isartdigital.myGame.ui.popin.PopinManager.getInstance();
	}
	,destroy: function() {
		com.isartdigital.myGame.ui.UIManager.instance = null;
	}
	,__class__: com.isartdigital.myGame.ui.UIManager
};
com.isartdigital.myGame.ui.hud = {};
com.isartdigital.myGame.ui.hud.HudBuild = function(startX,startY,texture) {
	com.isartdigital.myGame.ui.IconHud.call(this,startX,startY,texture);
};
$hxClasses["com.isartdigital.myGame.ui.hud.HudBuild"] = com.isartdigital.myGame.ui.hud.HudBuild;
com.isartdigital.myGame.ui.hud.HudBuild.__name__ = ["com","isartdigital","myGame","ui","hud","HudBuild"];
com.isartdigital.myGame.ui.hud.HudBuild.__super__ = com.isartdigital.myGame.ui.IconHud;
com.isartdigital.myGame.ui.hud.HudBuild.prototype = $extend(com.isartdigital.myGame.ui.IconHud.prototype,{
	onClick: function(pData) {
	}
	,__class__: com.isartdigital.myGame.ui.hud.HudBuild
});
com.isartdigital.myGame.ui.hud.HudManager = function() {
	this.childs = [];
	PIXI.DisplayObjectContainer.call(this);
	this.interactive = true;
	this.click = $bind(this,this.onClick);
	this.currentChild = new com.isartdigital.myGame.ui.hud.HudBuild(50,50);
	this.childs.push(this.currentChild);
	this.addChild(this.currentChild);
	this.childs.push(new com.isartdigital.myGame.ui.hud.HudBuild(0,0));
	this.addChild(this.childs[this.childs.length - 1]);
	com.isartdigital.Main.getInstance().getStage().addChild(this);
};
$hxClasses["com.isartdigital.myGame.ui.hud.HudManager"] = com.isartdigital.myGame.ui.hud.HudManager;
com.isartdigital.myGame.ui.hud.HudManager.__name__ = ["com","isartdigital","myGame","ui","hud","HudManager"];
com.isartdigital.myGame.ui.hud.HudManager.getInstance = function() {
	if(com.isartdigital.myGame.ui.hud.HudManager.instance == null) com.isartdigital.myGame.ui.hud.HudManager.instance = new com.isartdigital.myGame.ui.hud.HudManager();
	return com.isartdigital.myGame.ui.hud.HudManager.instance;
};
com.isartdigital.myGame.ui.hud.HudManager.__super__ = PIXI.DisplayObjectContainer;
com.isartdigital.myGame.ui.hud.HudManager.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	onResize: function(pEvent) {
	}
	,onClick: function(pData) {
		this.destroy();
	}
	,destroy: function() {
		var _g1 = 0;
		var _g = this.childs.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.removeChild(this.childs[i]);
		}
		this.childs = [];
		com.isartdigital.Main.getInstance().getStage().removeChild(this);
		com.isartdigital.myGame.ui.hud.HudManager.instance = null;
	}
	,__class__: com.isartdigital.myGame.ui.hud.HudManager
});
com.isartdigital.myGame.ui.popin = {};
com.isartdigital.myGame.ui.popin.PopinBuild = function(startX,startY,texture) {
	com.isartdigital.myGame.ui.MyPopin.call(this,startX,startY,texture);
	this.addIcon(0,0,"closeButton","closeButton");
};
$hxClasses["com.isartdigital.myGame.ui.popin.PopinBuild"] = com.isartdigital.myGame.ui.popin.PopinBuild;
com.isartdigital.myGame.ui.popin.PopinBuild.__name__ = ["com","isartdigital","myGame","ui","popin","PopinBuild"];
com.isartdigital.myGame.ui.popin.PopinBuild.getInstance = function(startX,startY,texture) {
	if(com.isartdigital.myGame.ui.popin.PopinBuild.instance == null) com.isartdigital.myGame.ui.popin.PopinBuild.instance = new com.isartdigital.myGame.ui.popin.PopinBuild(startX,startY,texture);
	return com.isartdigital.myGame.ui.popin.PopinBuild.instance;
};
com.isartdigital.myGame.ui.popin.PopinBuild.__super__ = com.isartdigital.myGame.ui.MyPopin;
com.isartdigital.myGame.ui.popin.PopinBuild.prototype = $extend(com.isartdigital.myGame.ui.MyPopin.prototype,{
	childClick: function(pEvent) {
		console.log((function($this) {
			var $r;
			var key = pEvent.target.name;
			$r = $this.childs.get(key);
			return $r;
		}(this)));
		if(pEvent.target.name == "closeButton") com.isartdigital.myGame.ui.popin.PopinManager.getInstance().closePopin("PopinBuild");
	}
	,__class__: com.isartdigital.myGame.ui.popin.PopinBuild
});
com.isartdigital.myGame.ui.popin.PopinManager = function() {
	this.childs = new haxe.ds.StringMap();
	PIXI.DisplayObjectContainer.call(this);
	com.isartdigital.Main.getInstance().getStage().addChild(this);
};
$hxClasses["com.isartdigital.myGame.ui.popin.PopinManager"] = com.isartdigital.myGame.ui.popin.PopinManager;
com.isartdigital.myGame.ui.popin.PopinManager.__name__ = ["com","isartdigital","myGame","ui","popin","PopinManager"];
com.isartdigital.myGame.ui.popin.PopinManager.getInstance = function() {
	if(com.isartdigital.myGame.ui.popin.PopinManager.instance == null) com.isartdigital.myGame.ui.popin.PopinManager.instance = new com.isartdigital.myGame.ui.popin.PopinManager();
	return com.isartdigital.myGame.ui.popin.PopinManager.instance;
};
com.isartdigital.myGame.ui.popin.PopinManager.__super__ = PIXI.DisplayObjectContainer;
com.isartdigital.myGame.ui.popin.PopinManager.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	onResize: function(pEvent) {
	}
	,openPopin: function(popinName,pX,pY) {
		var v = Type.createInstance(Type.resolveClass("com.isartdigital.myGame.ui.popin." + popinName),[pX,pY]);
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
		com.isartdigital.Main.getInstance().getStage().removeChild(this);
		com.isartdigital.myGame.ui.popin.PopinManager.instance = null;
	}
	,__class__: com.isartdigital.myGame.ui.popin.PopinManager
});
com.isartdigital.myGame.ui.screens = {};
com.isartdigital.myGame.ui.screens.Screen0 = function() {
	com.isartdigital.myGame.ui.MyScreen.call(this);
};
$hxClasses["com.isartdigital.myGame.ui.screens.Screen0"] = com.isartdigital.myGame.ui.screens.Screen0;
com.isartdigital.myGame.ui.screens.Screen0.__name__ = ["com","isartdigital","myGame","ui","screens","Screen0"];
com.isartdigital.myGame.ui.screens.Screen0.getInstance = function() {
	if(com.isartdigital.myGame.ui.screens.Screen0.instance == null) com.isartdigital.myGame.ui.screens.Screen0.instance = new com.isartdigital.myGame.ui.screens.Screen0();
	return com.isartdigital.myGame.ui.screens.Screen0.instance;
};
com.isartdigital.myGame.ui.screens.Screen0.__super__ = com.isartdigital.myGame.ui.MyScreen;
com.isartdigital.myGame.ui.screens.Screen0.prototype = $extend(com.isartdigital.myGame.ui.MyScreen.prototype,{
	onClick: function(pData) {
		com.isartdigital.myGame.ui.MyScreen.prototype.onClick.call(this,pData);
		com.isartdigital.myGame.ui.UIManager.getInstance().openScreen(com.isartdigital.myGame.ui.screens.Screen1.getInstance());
	}
	,destroy: function() {
		com.isartdigital.myGame.ui.screens.Screen0.instance = null;
		com.isartdigital.myGame.ui.MyScreen.prototype.destroy.call(this);
	}
	,__class__: com.isartdigital.myGame.ui.screens.Screen0
});
com.isartdigital.myGame.ui.screens.Screen1 = function() {
	com.isartdigital.myGame.ui.MyScreen.call(this);
};
$hxClasses["com.isartdigital.myGame.ui.screens.Screen1"] = com.isartdigital.myGame.ui.screens.Screen1;
com.isartdigital.myGame.ui.screens.Screen1.__name__ = ["com","isartdigital","myGame","ui","screens","Screen1"];
com.isartdigital.myGame.ui.screens.Screen1.getInstance = function() {
	if(com.isartdigital.myGame.ui.screens.Screen1.instance == null) com.isartdigital.myGame.ui.screens.Screen1.instance = new com.isartdigital.myGame.ui.screens.Screen1();
	return com.isartdigital.myGame.ui.screens.Screen1.instance;
};
com.isartdigital.myGame.ui.screens.Screen1.__super__ = com.isartdigital.myGame.ui.MyScreen;
com.isartdigital.myGame.ui.screens.Screen1.prototype = $extend(com.isartdigital.myGame.ui.MyScreen.prototype,{
	onClick: function(pData) {
		com.isartdigital.myGame.ui.MyScreen.prototype.onClick.call(this,pData);
		com.isartdigital.myGame.game.GameManager.getInstance().start();
	}
	,destroy: function() {
		com.isartdigital.myGame.ui.screens.Screen1.instance = null;
		com.isartdigital.myGame.ui.MyScreen.prototype.destroy.call(this);
	}
	,__class__: com.isartdigital.myGame.ui.screens.Screen1
});
com.isartdigital.myGame.ui.screens.TitleCard = function() {
	com.isartdigital.myGame.ui.MyScreen.call(this);
};
$hxClasses["com.isartdigital.myGame.ui.screens.TitleCard"] = com.isartdigital.myGame.ui.screens.TitleCard;
com.isartdigital.myGame.ui.screens.TitleCard.__name__ = ["com","isartdigital","myGame","ui","screens","TitleCard"];
com.isartdigital.myGame.ui.screens.TitleCard.getInstance = function() {
	if(com.isartdigital.myGame.ui.screens.TitleCard.instance == null) com.isartdigital.myGame.ui.screens.TitleCard.instance = new com.isartdigital.myGame.ui.screens.TitleCard();
	return com.isartdigital.myGame.ui.screens.TitleCard.instance;
};
com.isartdigital.myGame.ui.screens.TitleCard.__super__ = com.isartdigital.myGame.ui.MyScreen;
com.isartdigital.myGame.ui.screens.TitleCard.prototype = $extend(com.isartdigital.myGame.ui.MyScreen.prototype,{
	onClick: function(pData) {
		com.isartdigital.myGame.ui.MyScreen.prototype.onClick.call(this,pData);
		com.isartdigital.myGame.ui.UIManager.getInstance().openScreen(com.isartdigital.myGame.ui.screens.Screen0.getInstance());
	}
	,destroy: function() {
		com.isartdigital.myGame.ui.screens.TitleCard.instance = null;
		com.isartdigital.myGame.ui.MyScreen.prototype.destroy.call(this);
	}
	,__class__: com.isartdigital.myGame.ui.screens.TitleCard
});
com.isartdigital.utils.Config = function() { };
$hxClasses["com.isartdigital.utils.Config"] = com.isartdigital.utils.Config;
com.isartdigital.utils.Config.__name__ = ["com","isartdigital","utils","Config"];
com.isartdigital.utils.Config.init = function(pConfig) {
	var _g = 0;
	var _g1 = Reflect.fields(pConfig);
	while(_g < _g1.length) {
		var i = _g1[_g];
		++_g;
		Reflect.setField(com.isartdigital.utils.Config._data,i,Reflect.field(pConfig,i));
	}
	if(com.isartdigital.utils.Config._data.version == null) com.isartdigital.utils.Config._data.version = "0.0.0";
	if(com.isartdigital.utils.Config._data.langPath == null) com.isartdigital.utils.Config._data.langPath = "";
	if(com.isartdigital.utils.Config._data.language == null) com.isartdigital.utils.Config._data.language = HxOverrides.substr(window.navigator.language,0,2);
	if(com.isartdigital.utils.Config._data.languages == []) com.isartdigital.utils.Config._data.languages.push(com.isartdigital.utils.Config._data.language);
	if(com.isartdigital.utils.Config._data.debug == []) com.isartdigital.utils.Config._data.debug = false;
};
com.isartdigital.utils.Config.get_data = function() {
	return com.isartdigital.utils.Config._data;
};
com.isartdigital.utils.Config.get_version = function() {
	return com.isartdigital.utils.Config._data.version;
};
com.isartdigital.utils.Config.get_langPath = function() {
	return com.isartdigital.utils.Config._data.langPath;
};
com.isartdigital.utils.Config.get_language = function() {
	return com.isartdigital.utils.Config.get_data().language;
};
com.isartdigital.utils.Config.get_languages = function() {
	return com.isartdigital.utils.Config.get_data().languages;
};
com.isartdigital.utils.Config.get_debug = function() {
	return com.isartdigital.utils.Config.get_data().debug;
};
com.isartdigital.utils.events.Event = function(pType) {
	this.type = pType;
};
$hxClasses["com.isartdigital.utils.events.Event"] = com.isartdigital.utils.events.Event;
com.isartdigital.utils.events.Event.__name__ = ["com","isartdigital","utils","events","Event"];
com.isartdigital.utils.events.Event.prototype = {
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
	,__class__: com.isartdigital.utils.events.Event
};
com.isartdigital.utils.events.GameStageEvent = function(pType,pWidth,pHeight) {
	com.isartdigital.utils.events.Event.call(this,pType);
	this.width = pWidth;
	this.height = pHeight;
};
$hxClasses["com.isartdigital.utils.events.GameStageEvent"] = com.isartdigital.utils.events.GameStageEvent;
com.isartdigital.utils.events.GameStageEvent.__name__ = ["com","isartdigital","utils","events","GameStageEvent"];
com.isartdigital.utils.events.GameStageEvent.__super__ = com.isartdigital.utils.events.Event;
com.isartdigital.utils.events.GameStageEvent.prototype = $extend(com.isartdigital.utils.events.Event.prototype,{
	toString: function() {
		return this.formatToString(["type","width","height"]);
	}
	,__class__: com.isartdigital.utils.events.GameStageEvent
});
com.isartdigital.utils.game.GameStage = function() {
	this._safeZone = new PIXI.Rectangle(0,0,2048,1366);
	this._scaleMode = com.isartdigital.utils.game.GameStageScale.SHOW_ALL;
	this._alignMode = com.isartdigital.utils.game.GameStageAlign.CENTER;
	PIXI.DisplayObjectContainer.call(this);
	this.eventDispatcher = new com.isartdigital.utils.events.EventDispatcher();
	this.gameContainer = new PIXI.DisplayObjectContainer();
	this.addChild(this.gameContainer);
	this.screensContainer = new PIXI.DisplayObjectContainer();
	this.addChild(this.screensContainer);
	this.hudContainer = new PIXI.DisplayObjectContainer();
	this.addChild(this.hudContainer);
	this.popinsContainer = new PIXI.DisplayObjectContainer();
	this.addChild(this.popinsContainer);
};
$hxClasses["com.isartdigital.utils.game.GameStage"] = com.isartdigital.utils.game.GameStage;
com.isartdigital.utils.game.GameStage.__name__ = ["com","isartdigital","utils","game","GameStage"];
com.isartdigital.utils.game.GameStage.__interfaces__ = [com.isartdigital.utils.events.IEventDispatcher];
com.isartdigital.utils.game.GameStage.getInstance = function() {
	if(com.isartdigital.utils.game.GameStage.instance == null) com.isartdigital.utils.game.GameStage.instance = new com.isartdigital.utils.game.GameStage();
	return com.isartdigital.utils.game.GameStage.instance;
};
com.isartdigital.utils.game.GameStage.__super__ = PIXI.DisplayObjectContainer;
com.isartdigital.utils.game.GameStage.prototype = $extend(PIXI.DisplayObjectContainer.prototype,{
	init: function(pRender,pSafeZoneWidth,pSafeZoneHeight,centerGameContainer,centerScreensContainer,centerPopinContainer) {
		if(centerPopinContainer == null) centerPopinContainer = true;
		if(centerScreensContainer == null) centerScreensContainer = true;
		if(centerGameContainer == null) centerGameContainer = false;
		if(pSafeZoneHeight == null) pSafeZoneHeight = 2048;
		if(pSafeZoneWidth == null) pSafeZoneWidth = 2048;
		this.render = pRender;
		this._safeZone = new PIXI.Rectangle(0,0,(function($this) {
			var $r;
			var $int = pSafeZoneWidth;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)),(function($this) {
			var $r;
			var int1 = pSafeZoneHeight;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)));
		if(centerGameContainer) {
			this.gameContainer.x = this.get_safeZone().width / 2;
			this.gameContainer.y = this.get_safeZone().height / 2;
		}
		if(centerScreensContainer) {
			this.screensContainer.x = this.get_safeZone().width / 2;
			this.screensContainer.y = this.get_safeZone().height / 2;
		}
		if(centerPopinContainer) {
			this.popinsContainer.x = this.get_safeZone().width / 2;
			this.popinsContainer.y = this.get_safeZone().height / 2;
		}
	}
	,resize: function() {
		var lWidth = com.isartdigital.utils.system.DeviceCapabilities.get_width();
		var lHeight = com.isartdigital.utils.system.DeviceCapabilities.get_height();
		var lRatio = Math.round(10000 * Math.min((function($this) {
			var $r;
			var $int = lWidth;
			$r = $int < 0?4294967296.0 + $int:$int + 0.0;
			return $r;
		}(this)) / this.get_safeZone().width,(function($this) {
			var $r;
			var int1 = lHeight;
			$r = int1 < 0?4294967296.0 + int1:int1 + 0.0;
			return $r;
		}(this)) / this.get_safeZone().height)) / 10000;
		if(this.get_scaleMode() == com.isartdigital.utils.game.GameStageScale.SHOW_ALL) this.scale.set(lRatio,lRatio); else this.scale.set(1,1);
		if(this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.LEFT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.TOP_LEFT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.BOTTOM_LEFT) this.x = 0; else if(this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.RIGHT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.TOP_RIGHT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.BOTTOM_RIGHT) this.x = (function($this) {
			var $r;
			var int2 = lWidth;
			$r = int2 < 0?4294967296.0 + int2:int2 + 0.0;
			return $r;
		}(this)) - this.get_safeZone().width * this.scale.x; else this.x = ((function($this) {
			var $r;
			var int3 = lWidth;
			$r = int3 < 0?4294967296.0 + int3:int3 + 0.0;
			return $r;
		}(this)) - this.get_safeZone().width * this.scale.x) / 2;
		if(this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.TOP || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.TOP_LEFT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.TOP_RIGHT) this.y = 0; else if(this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.BOTTOM || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.BOTTOM_LEFT || this.get_alignMode() == com.isartdigital.utils.game.GameStageAlign.BOTTOM_RIGHT) this.y = (function($this) {
			var $r;
			var int4 = lHeight;
			$r = int4 < 0?4294967296.0 + int4:int4 + 0.0;
			return $r;
		}(this)) - this.get_safeZone().height * this.scale.y; else this.y = ((function($this) {
			var $r;
			var int5 = lHeight;
			$r = int5 < 0?4294967296.0 + int5:int5 + 0.0;
			return $r;
		}(this)) - this.get_safeZone().height * this.scale.y) / 2;
		if(this.render != null) this.render();
		this.dispatchEvent(new com.isartdigital.utils.events.GameStageEvent("GameStageEvent.RESIZE",lWidth,lHeight));
	}
	,get_alignMode: function() {
		return this._alignMode;
	}
	,set_alignMode: function(pAlign) {
		this._alignMode = pAlign;
		this.resize();
		return this._alignMode;
	}
	,get_scaleMode: function() {
		return this._scaleMode;
	}
	,set_scaleMode: function(pScale) {
		this._scaleMode = pScale;
		this.resize();
		return this._scaleMode;
	}
	,get_safeZone: function() {
		return this._safeZone;
	}
	,getGameContainer: function() {
		return this.gameContainer;
	}
	,getScreensContainer: function() {
		return this.screensContainer;
	}
	,getHudContainer: function() {
		return this.hudContainer;
	}
	,getPopinsContainer: function() {
		return this.popinsContainer;
	}
	,hasEventListener: function(pType,pListener) {
		return this.eventDispatcher.hasEventListener(pType,pListener);
	}
	,addEventListener: function(pType,pListener) {
		this.eventDispatcher.addEventListener(pType,pListener);
	}
	,removeEventListener: function(pType,pListener) {
		this.eventDispatcher.removeEventListener(pType,pListener);
	}
	,dispatchEvent: function(pEvent) {
		this.eventDispatcher.dispatchEvent(pEvent);
		pEvent.target = this;
	}
	,destroy: function() {
		this.eventDispatcher.destroy();
		this.eventDispatcher = null;
		com.isartdigital.utils.game.GameStage.instance = null;
	}
	,__class__: com.isartdigital.utils.game.GameStage
});
com.isartdigital.utils.game.GameStageAlign = { __ename__ : true, __constructs__ : ["TOP","TOP_LEFT","TOP_RIGHT","CENTER","LEFT","RIGHT","BOTTOM","BOTTOM_LEFT","BOTTOM_RIGHT"] };
com.isartdigital.utils.game.GameStageAlign.TOP = ["TOP",0];
com.isartdigital.utils.game.GameStageAlign.TOP.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.TOP_LEFT = ["TOP_LEFT",1];
com.isartdigital.utils.game.GameStageAlign.TOP_LEFT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.TOP_RIGHT = ["TOP_RIGHT",2];
com.isartdigital.utils.game.GameStageAlign.TOP_RIGHT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.CENTER = ["CENTER",3];
com.isartdigital.utils.game.GameStageAlign.CENTER.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.LEFT = ["LEFT",4];
com.isartdigital.utils.game.GameStageAlign.LEFT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.RIGHT = ["RIGHT",5];
com.isartdigital.utils.game.GameStageAlign.RIGHT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.BOTTOM = ["BOTTOM",6];
com.isartdigital.utils.game.GameStageAlign.BOTTOM.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.BOTTOM_LEFT = ["BOTTOM_LEFT",7];
com.isartdigital.utils.game.GameStageAlign.BOTTOM_LEFT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageAlign.BOTTOM_RIGHT = ["BOTTOM_RIGHT",8];
com.isartdigital.utils.game.GameStageAlign.BOTTOM_RIGHT.__enum__ = com.isartdigital.utils.game.GameStageAlign;
com.isartdigital.utils.game.GameStageScale = { __ename__ : true, __constructs__ : ["NO_SCALE","SHOW_ALL"] };
com.isartdigital.utils.game.GameStageScale.NO_SCALE = ["NO_SCALE",0];
com.isartdigital.utils.game.GameStageScale.NO_SCALE.__enum__ = com.isartdigital.utils.game.GameStageScale;
com.isartdigital.utils.game.GameStageScale.SHOW_ALL = ["SHOW_ALL",1];
com.isartdigital.utils.game.GameStageScale.SHOW_ALL.__enum__ = com.isartdigital.utils.game.GameStageScale;
com.isartdigital.utils.system = {};
com.isartdigital.utils.system.DeviceCapabilities = function() { };
$hxClasses["com.isartdigital.utils.system.DeviceCapabilities"] = com.isartdigital.utils.system.DeviceCapabilities;
com.isartdigital.utils.system.DeviceCapabilities.__name__ = ["com","isartdigital","utils","system","DeviceCapabilities"];
com.isartdigital.utils.system.DeviceCapabilities.get_height = function() {
	return window.innerHeight;
};
com.isartdigital.utils.system.DeviceCapabilities.get_width = function() {
	return window.innerWidth;
};
com.isartdigital.utils.ui.Hud = function() {
	com.isartdigital.utils.ui.UIComponent.call(this);
};
$hxClasses["com.isartdigital.utils.ui.Hud"] = com.isartdigital.utils.ui.Hud;
com.isartdigital.utils.ui.Hud.__name__ = ["com","isartdigital","utils","ui","Hud"];
com.isartdigital.utils.ui.Hud.__super__ = com.isartdigital.utils.ui.UIComponent;
com.isartdigital.utils.ui.Hud.prototype = $extend(com.isartdigital.utils.ui.UIComponent.prototype,{
	__class__: com.isartdigital.utils.ui.Hud
});
com.isartdigital.utils.ui.Popin = function() {
	com.isartdigital.utils.ui.UIComponent.call(this);
};
$hxClasses["com.isartdigital.utils.ui.Popin"] = com.isartdigital.utils.ui.Popin;
com.isartdigital.utils.ui.Popin.__name__ = ["com","isartdigital","utils","ui","Popin"];
com.isartdigital.utils.ui.Popin.__super__ = com.isartdigital.utils.ui.UIComponent;
com.isartdigital.utils.ui.Popin.prototype = $extend(com.isartdigital.utils.ui.UIComponent.prototype,{
	__class__: com.isartdigital.utils.ui.Popin
});
com.isartdigital.utils.ui.UIPosition = { __ename__ : true, __constructs__ : ["LEFT","RIGHT","TOP","BOTTOM","TOP_LEFT","TOP_RIGHT","BOTTOM_LEFT","BOTTOM_RIGHT","FIT_WIDTH","FIT_HEIGHT","FIT_SCREEN"] };
com.isartdigital.utils.ui.UIPosition.LEFT = ["LEFT",0];
com.isartdigital.utils.ui.UIPosition.LEFT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.RIGHT = ["RIGHT",1];
com.isartdigital.utils.ui.UIPosition.RIGHT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.TOP = ["TOP",2];
com.isartdigital.utils.ui.UIPosition.TOP.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.BOTTOM = ["BOTTOM",3];
com.isartdigital.utils.ui.UIPosition.BOTTOM.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.TOP_LEFT = ["TOP_LEFT",4];
com.isartdigital.utils.ui.UIPosition.TOP_LEFT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.TOP_RIGHT = ["TOP_RIGHT",5];
com.isartdigital.utils.ui.UIPosition.TOP_RIGHT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.BOTTOM_LEFT = ["BOTTOM_LEFT",6];
com.isartdigital.utils.ui.UIPosition.BOTTOM_LEFT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.BOTTOM_RIGHT = ["BOTTOM_RIGHT",7];
com.isartdigital.utils.ui.UIPosition.BOTTOM_RIGHT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.FIT_WIDTH = ["FIT_WIDTH",8];
com.isartdigital.utils.ui.UIPosition.FIT_WIDTH.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.FIT_HEIGHT = ["FIT_HEIGHT",9];
com.isartdigital.utils.ui.UIPosition.FIT_HEIGHT.__enum__ = com.isartdigital.utils.ui.UIPosition;
com.isartdigital.utils.ui.UIPosition.FIT_SCREEN = ["FIT_SCREEN",10];
com.isartdigital.utils.ui.UIPosition.FIT_SCREEN.__enum__ = com.isartdigital.utils.ui.UIPosition;
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
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
com.isartdigital.Main.CONFIG_PATH = "config.json";
com.isartdigital.myGame.game.sprites.Ambulance.images = ["E","SE","S","SW","W","NW","N","NE"];
com.isartdigital.utils.Config._data = { };
com.isartdigital.utils.events.Event.COMPLETE = "Event.COMPLETE";
com.isartdigital.utils.events.Event.GAME_LOOP = "Event.GAME_LOOP";
com.isartdigital.utils.events.GameStageEvent.RESIZE = "GameStageEvent.RESIZE";
com.isartdigital.utils.game.GameStage.SAFE_ZONE_WIDTH = 2048;
com.isartdigital.utils.game.GameStage.SAFE_ZONE_HEIGHT = 1366;
com.isartdigital.Main.main();
})();

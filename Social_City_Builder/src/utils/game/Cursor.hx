package utils.game;

import js.Browser;
import pixi.display.MovieClip;
import pixi.display.Sprite;
import pixi.textures.Texture;

class Cursor extends pixi.display.DisplayObjectContainer
{
	private static var instance: Cursor;
	private var hammer:MovieClip;
	private var hammerTextures:Array<Texture> = [];
	private var dogeFinger:Sprite;
	private var dogeFingerTextureNormal:Texture;
	private var dogeFingerTextureActive:Texture;
	public var currentCursorImg:Sprite;
	public var dogeFingerOffsetX:Float = -7;
	public var dogeFingerOffsetY:Float = -3;


	public static function getInstance (): Cursor {
		if (instance == null) instance = new Cursor();
		return instance;
	}	

	private function new (){
		super();
		for(i in 1...7){
			hammerTextures.push(Texture.fromFrame("PopInWorkshopHammerOnClick0"+i+".png"));
		}
		hammer = new MovieClip(hammerTextures);
		hammer.visible = false;
		hammer.loop = false;
		hammer.anchor.set(0.5,0.5);
		hammer.animationSpeed = 0.25;
		addChild(hammer);

		dogeFingerTextureNormal = Texture.fromFrame("assets/UI/Cursor/curseur_up.png");
		dogeFingerTextureActive = Texture.fromFrame("assets/UI/Cursor/curseur_down.png");
		dogeFinger = new Sprite(dogeFingerTextureNormal);
		dogeFinger.visible = false;
		addChild(dogeFinger);
		setCursorToDoge();

		Browser.window.addEventListener('mousedown', onMousedown);		
		Browser.window.addEventListener('mouseup', onMouseup);		
		Browser.window.addEventListener('mousemove', onMousemove);
	}

	public function setCursorToNormal() : Void {
		Browser.document.body.style.cursor = "normal";
		hammer.visible = false;
		dogeFinger.visible = false;
		currentCursorImg = null;
	}
	public function setCursorToHammer() : Void {
		Browser.document.body.style.cursor = "none";
		dogeFinger.visible = false;
		hammer.visible = true;
		currentCursorImg = hammer;
	}
	public function setCursorToDoge() : Void {
		Browser.document.body.style.cursor = "none";
		hammer.visible = false;
		dogeFinger.visible = true;
		currentCursorImg = dogeFinger;
	}
	private function onMousedown(data) : Void {
		if(dogeFinger.visible){
			dogeFinger.setTexture(dogeFingerTextureActive);
		}
		else if(hammer.visible){
			hammer.gotoAndPlay(0);
		}
	}
	private function onMouseup(data) : Void {
		if(dogeFinger.visible){
			dogeFinger.setTexture(dogeFingerTextureNormal);
		}
	}
	private function onMousemove(data) : Void {
		if(dogeFinger.visible){
			dogeFinger.position.set(data.clientX+dogeFingerOffsetX,data.clientY+dogeFingerOffsetY);
		}		
		if(hammer.visible){
			hammer.position.set(data.clientX,data.clientY);
		}
	}

}
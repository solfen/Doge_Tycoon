package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.textures.Texture;
import externs.dat.gui.GUI;
import pixi.display.MovieClip;
import pixi.extras.TilingSprite;
import utils.game.ParticleSystem;
import pixi.InteractionData;
//Popinworkshop is lauched on hangar click
// It's prety huge and I could cut it into three popins but then I would have to choose which one to open in hangard click. And now that I write that I realise that it's not stupid at all so I'll probably do that after I get some sleep.
class PopinChurch extends MyPopin 
{	
	private var hasVerticalScrollBar:Bool = false;
	private var clickImage:MovieClip;
	private var clickImageAnimationSpeed:Float = 0.25;
	private var clickImageTexturesNb:Int = 10;
	private var clickImageTextures:Array<Texture> = [];
	private var particleSystem:ParticleSystem;
	private var faithBar:TilingSprite;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["clickImageAnimationSpeed","backTextX","backTextY","infoTextX","infoTextY","clickImageX","clickImageY","loadbarBackX","loadbarBackY","loadbarStartX","loadbarStartY","faithBarIconX","faithBarIconY","faithInfoX","faithInfoY","faithBarMaxWidth"];
	private var backTextX:Float = 0.3;
	private var backTextY:Float = 0.13;
	private var infoTextX:Float = 0.43;
	private var infoTextY:Float = 0.14;
	private var clickImageX:Float = 0.28;
	private var clickImageY:Float = 0.2;
	private var loadbarBackX:Float = 0.26;
	private var loadbarBackY:Float = 0.8;
	private var loadbarStartX:Float = 0.282;
	private var loadbarStartY:Float = 0.809;
	private var faithBarIconX:Float = 0.15;
	private var faithBarIconY:Float = 0.78;
	private var faithInfoX:Float = 0.47;
	private var faithInfoY:Float = 0.87;
	private var faithBarMaxWidth:Float = 0.91;

	private function new(?startX:Float,?startY:Float,?optParams:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		addContainer('main', this);
		addAll();

		//debugGUI();
	}

	private function addAll() : Void { 
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",containers['main'],true,'closeButtonActive.png',true);
		addIcon(-0.15,-0.15,'PopInTitleEglise.png',"popInTitle",containers['main'],false);
		addIcon(-0.45,0.27,'assets/Dogs/DogChurch.png',"dog",containers['main'],false);
		addIcon(backTextX,backTextY,'PopInChurchTextBG.png',"PopInChurchTextBG",containers['main'],false);
		addText(infoTextX,infoTextY,'FuturaStdHeavy','15px','Une prière par clic !','aideText',containers['main'],'white');
		addIcon(loadbarBackX,loadbarBackY,'PopInChurchFillBar.png',"fillBarBack",containers['main'],false);
		addIcon(loadbarStartX,loadbarStartY,'PopInChurchFillLeft.png',"fillLeft",containers['main'],false);
		addText(faithInfoX,faithInfoY,'FuturaStdHeavy','15px','','faithInfo',containers['main'],'white');

		faithBar = new TilingSprite(Texture.fromFrame('PopInChurchFillMiddle.png'), 100, icons["fillLeft"].height);
		faithBar.anchor.set(0,0);
		faithBar.position.set(icons["fillLeft"].position.x+icons["fillLeft"].width,icons["fillLeft"].position.y);
		containers['main'].addChild(faithBar);
		addIcon(0,loadbarStartY,'PopInChurchFillRight.png',"fillRight",containers['main'],false);
		icons['fillRight'].position.x = faithBar.position.x+faithBar.width;
		addIcon(faithBarIconX,faithBarIconY,'PopInChurchFaithIcon.png',"faithIcon",containers['main'],false);
		
		for(i in 0...clickImageTexturesNb){
			clickImageTextures.push(Texture.fromFrame("PopinChurchClick_"+i+".png"));
		}
		clickImage = new MovieClip(clickImageTextures);
		clickImage.position.set(Std.int(clickImageX*background.width-background.width/2),Std.int(clickImageY*background.height-background.height/2));
		clickImage.animationSpeed = clickImageAnimationSpeed;
		clickImage.play();
		clickImage.interactive = true;
		clickImage.mousedown = pray;
		containers['main'].addChild(clickImage);

		particleSystem = new ParticleSystem("PopInChurchFaithParticule.png");
		addChild(particleSystem);

		update();
	}

	override public function update() : Void {
		faithBar.width = GameInfo.faithPercent * (faithBarMaxWidth*(background.width-background.width/2));
		icons['fillRight'].position.x = faithBar.position.x+faithBar.width;
		var percent:String = Std.string(GameInfo.faithPercent*100);
		percent  = percent.substr(0, percent.indexOf('.')+3);
		texts['faithInfo'].setText('Foi : ' + percent + '%');
	}

	private function pray(pEvent:Dynamic) : Void {
		GameInfo.faithPercent = Math.min(GameInfo.faithPercent+GameInfo.prayerEffect,1);
		particleSystem.startParticlesEmission(pEvent.originalEvent.clientX,pEvent.originalEvent.clientY);
		update();
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			if(gui != null) gui.destroy();
			PopinManager.getInstance().closePopin("PopinChurch");
		}
	}

	private function refresh() {
		containers['main'].removeChildren(0,children.length);
		addAll();
	}
	private function debugGUI(){
		gui = new GUI();
		//gui.remember(this);
		for(i in guiValuesList){
			gui.add(this, i,-1,1).onChange(function(newValue) {
				refresh();
			});
		}
	}

	override public function destroy() : Void {
		super.destroy();
		if(particleSystem != null){
			removeChild(particleSystem);
			particleSystem.destroy();
			particleSystem = null;
		}
	}
}
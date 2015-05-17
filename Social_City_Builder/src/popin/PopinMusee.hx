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
class PopinMusee extends MyPopin 
{	
	private var hasVerticalScrollBar:Bool = false;
	private var clickImage:MovieClip;
	private var clickImageAnimationSpeed:Float = 0.25;
	private var clickImageTexturesNb:Int = 10;
	private var clickImageTextures:Array<Texture> = [];
	private var particleSystem:ParticleSystem;
	private var faithBar:TilingSprite;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["clickImageAnimationSpeed","headerX","headerY","backTextX","backTextY","infoTextX","infoTextY","clickImageX","clickImageY","museeInfoX","museeInfoY"];
	private var headerX:Float = 0.47;
	private var headerY:Float = 0.05;
	private var backTextX:Float = 0.3;
	private var backTextY:Float = 0.17;
	private var infoTextX:Float = 0.43;
	private var infoTextY:Float = 0.18;
	private var clickImageX:Float = 0.28;
	private var clickImageY:Float = 0.26;
	private var museeInfoX:Float = 0.41;
	private var museeInfoY:Float = 0.83;
	private var maxParticlesNb:Int = 20;
	private var minParticlesNb:Int = 3;
	private var cheatDogeClick:Float = 1;

	private function new(?startX:Float,?startY:Float,?optParams:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		headerTextures = [ 
			'acceuil'=>Texture.fromFrame('PopInHeaderAccueilMusee.png'),
			'monMusee'=>Texture.fromFrame('PopInHeaderMonMusee.png'),
			'musseeAmis'=>Texture.fromFrame('PopInHeaderMuseeAmis.png'),
		];
		addContainer('main', this);
		addAll();

		//debugGUI();
	}

	private function addAll() : Void {
		addHeader(headerX,headerY,headerTextures['acceuil']);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",containers['main'],true,'closeButtonActive.png',true);
		addIcon(-0.15,-0.15,'PopInMuseeTitle.png',"popInTitle",containers['main'],false);
		addIcon(-0.45,0.27,'assets/Dogs/DogMusee.png',"dog",containers['main'],false);
		addIcon(backTextX,backTextY,'PopInMuseeTextBG.png',"PopInMuseeTextBG",containers['main'],false);
		addText(infoTextX,infoTextY,'FuturaStdHeavy','15px','Une visite par clic !','aideText',containers['main'],'white');
		addText(museeInfoX,museeInfoY,'FuturaStdHeavy','16px','','museeInfo',containers['main'],'white');

		
		for(i in 0...clickImageTexturesNb){
			clickImageTextures.push(Texture.fromFrame("PopinMuseeClick_"+i+".png"));
		}
		clickImage = new MovieClip(clickImageTextures);
		clickImage.position.set(Std.int(clickImageX*background.width-background.width/2),Std.int(clickImageY*background.height-background.height/2));
		clickImage.animationSpeed = clickImageAnimationSpeed;
		clickImage.play();
		clickImage.interactive = true;
		clickImage.mousedown = visit;
		containers['main'].addChild(clickImage);

		particleSystem = new ParticleSystem("PopInMuseeParticule.png");
		addChild(particleSystem);

		update();
	}

	override public function update() : Void {
		var speed:String = Std.string(GameInfo.museeSoftSpeed);
		speed  = speed.substr(0, speed.indexOf('.')+3);
		texts['museeInfo'].setText('Dogeflooz/sec : ' + speed);
	}

	private function visit(pEvent:Dynamic) : Void {
		GameInfo.ressources['fric'].userPossesion += GameInfo.musseVisiteGain;
		hud.HudManager.getInstance().updateChildsText();
		particleSystem.setParticlesNb(Std.int(Math.min(GameInfo.musseVisiteGain*minParticlesNb,maxParticlesNb)));
		particleSystem.startParticlesEmission(pEvent.originalEvent.clientX,pEvent.originalEvent.clientY);
		update();
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			if(gui != null) gui.destroy();
			PopinManager.getInstance().closePopin("PopinMusee");
		}
	}

	private function refresh() {
		GameInfo.musseVisiteGain = cheatDogeClick;
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
		gui.add(this, "maxParticlesNb",0,100).onChange(function(newValue) {
			refresh();
		});			
		gui.add(this, "minParticlesNb",0,100).onChange(function(newValue) {
			refresh();
		});			
		gui.add(this, "cheatDogeClick",0,100).onChange(function(newValue) {
			refresh();
		});
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
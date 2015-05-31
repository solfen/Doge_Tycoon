package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;
import externs.dat.gui.GUI;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinFTUE extends MyPopin
{	
	private var articleWidth:Float = Texture.fromFrame("PopInMuseeArticleBg.png").width;
	private var hasVerticalScrollBar:Bool = false;
	private var ftueTexts:Array<String>;
	private var ftueTextIndex:Int;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["mainBackX","mainBackY","ftueTextX","ftueTextY","dogPosX","dogPosY"];
	private var mainBackX:Float = 0.11;
	private var mainBackY:Float = 0.17;
	private var ftueTextX:Float = 0.13;
	private var ftueTextY:Float = 0.21;
	private var dogPosX:Float = -0.74;
	private var dogPosY:Float = -0.05;

	private function new(?startX:Float,?startY:Float, ?optParam:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		trace(startX,startY);
		super(startX,startY, "PopInBackground.png");
		ftueTexts = ["Hey c’est toi le nouveau gérant ? Super !\nGrâce à toi on va enfin pouvoir partir à la\n conquête de l’espace !\n\nAvant toute chose, tu vas devoir construire\n une base de lancement. Comme le\n gouvernement t'en offre une, tu n'a plus\n qu'a fermer cette popup et placer ta base",
					"Génial tu a construit ta base !\nL'espace n'est plus si loin maintenant !\n\nCertains employés zélés t’ont donné des\nmissions pour t'aider avec la suite\n\nClique donc sur l’icône en forme de livre \n en bas à droite pour les voir",
					"Ils sont sympa tes employés hein ?\n\nLes missions peuvent être effectuées\n n'importe quand et dans n’importe\n quel ordre. Cela te donnera des buts à\n atteindre tout au long de ta carrière\n\n   Allez bonne chance patron, on compte\n sur toi !"
		];
		ftueTextIndex = optParam['ftueIndex'];
		addHeader(0.55,0.05,Texture.fromFrame('PopInFTUEHeader.png'));
		addIcon(-0.15,-0.15,'PopInFTUETitle.png',"popInTitle",this,false);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addContainer("main",this,0,0);
		addMain();

		//debugGUI();
	}
	private function addMain() {
		addIcon(mainBackX,mainBackY,'PopInScrollBackground.png',"contentBackground",containers["main"],false);
		addText(ftueTextX,ftueTextY,'FuturaStdHeavy','30px',ftueTexts[ftueTextIndex],'mainText',containers["main"],"black","center");
		addIcon(dogPosX,dogPosY,'assets/Dogs/DogAstro.png',"dog",containers["main"],false);
	}


	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinFTUE");
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == 'closeButton'){
			icons['closeButton'].setTextureToNormal();
		}
	}
	private function debugGUI(){
		gui = new GUI();
		//gui.remember(this);
		var listValues:Array<String> = guiValuesList;
		for(i in listValues){
			gui.add(this, i,-1,1).step(0.0001).onChange(function(newValue) {
				refresh();
			});
		}
	}
	private function refresh() {
		containers["main"].removeChildren(0,containers["main"].children.length);
		addMain();
	}
}
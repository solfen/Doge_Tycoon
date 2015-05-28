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
class PopinSpaceShipReturn extends MyPopin
{	
	private var articleWidth:Float = Texture.fromFrame("PopInMuseeArticleBg.png").width;
	private var articleInterline:Float = 0.02;
	private var hasVerticalScrollBar:Bool = false;
	private var destination:String;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["articleInterline","ressourcesBackX","ressourcesBackY","ressourceBaseX","ressourceBaseY","ressourceImgX","ressourceImgY","ressourcesTxtX","ressourcesTxtY","ressourcesNbX","ressourcesNbY","artefactsBackX","artefactsBackY","artefactBaseX","artefactBaseY","artefactImgX","artefactImgY","artefactsTxtX","artefactsTxtY","artefactsNbX","artefactsNbY"];
	private var ressourcesBackX:Float = 0.11;
	private var ressourcesBackY:Float = 0.21;
	private var ressourceBaseX:Float = 0.15;
	private var ressourceBaseY:Float = 0.225;
	private var ressourceImgX:Float = 0.158;
	private var ressourceImgY:Float = 0.243;
	private var ressourcesTxtX:Float = 0.11;
	private var ressourcesTxtY:Float = 0.15;
	private var ressourcesNbX:Float = 0.17;
	private var ressourcesNbY:Float = 0.43;
	private var artefactsBackX:Float = 0.11;
	private var artefactsBackY:Float = 0.604;
	private var artefactBaseX:Float = 0.15;
	private var artefactBaseY:Float = 0.615;
	private var artefactImgX:Float = 0.16;
	private var artefactImgY:Float = 0.63;
	private var artefactsTxtX:Float = 0.11;
	private var artefactsTxtY:Float = 0.54;
	private var artefactsNbX:Float = 0.17;
	private var artefactsNbY:Float = 0.81;
	private var dogPosX:Float = 0.81;
	private var dogPosY:Float = 0.81;


	private function new(?startX:Float,?startY:Float, ?optParam:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		articleWidth /= background.width; // background is defiened in MyPopin
		destination = optParam['destination'];

		addHeader(0.59,0.05,Texture.fromFrame('PopinReturnHeader.png'));
		addIcon(-0.15,-0.15,'PopInTitleReturn.png',"popInTitle",this,false);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addContainer("main",this,0,0);
		addRessources();
		addArtefacts();
		addIcon(-0.73,0.02,'assets/Dogs/DogAstro.png',"dog",this,false);
		//debugGUI();
	}

	private function addRessources(){
		addIcon(ressourcesBackX, ressourcesBackY,'PopinArticleBgReturn.png',"ressourcesBack",containers["main"],false);
		addText(ressourcesTxtX,ressourcesTxtY,'FuturaStdHeavy','25px',"RESSOURCES RÉCOLTÉES :",'ressourceTxt',containers["main"]);

		var cpt:Int = 0;
		var ressources:Array<Dynamic> = GameInfo.planetsRessources[destination];
		for(i in ressources) {
			var x:Float = cpt*(articleWidth+articleInterline);
			var nb:Int = Std.int(Math.random()*(i.maxNb-i.minNb) + i.minNb); // TEMP !! NEED TO HAVE A REAL RANDOM ATRIBUTION !!
			addIcon(ressourceBaseX+x,ressourceBaseY,'PopInMuseeArticleBg.png',"ressourceBase",containers["main"],false);
			addIcon(ressourceImgX+x,ressourceImgY,GameInfo.ressources[i.name].previewImg,"ressourceImg",containers["main"],false);
			addText(ressourcesNbX+x,ressourcesNbY,'FuturaStdHeavy','25px',"x"+nb,'ressourceTxt',containers["main"]);
			cpt++;

			GameInfo.ressources[i.name].userPossesion += nb;
		}
	}

	private function addArtefacts(){
		addIcon(artefactsBackX, artefactsBackY,'PopinArticleBgReturn.png',"artefactsBack",containers["main"],false);
		addText(artefactsTxtX,artefactsTxtY,'FuturaStdHeavy','25px',"ARTEFACTS TROUVÉS :",'artefactTxt',containers["main"]);

		var cpt:Int = 0;
		var artefacts:Array<Dynamic> = GameInfo.artefacts[destination];
		for(i in artefacts) {
			var x:Float = cpt*(articleWidth+articleInterline);
			var hasIt:Float = Math.random(); // TEMP !! NEED TO HAVE A REAL RANDOM ATRIBUTION !!
			if(hasIt >= 0.5){ 
				addIcon(artefactBaseX+x,artefactBaseY,'PopInMuseeArticleBg.png',"artefactBase",containers["main"],false);
				addIcon(artefactImgX+x,artefactImgY,i.img,"artefactImg",containers["main"],false);
				addText(artefactsNbX+x,artefactsNbY,'FuturaStdHeavy','25px',"x1",'artefactTxt',containers["main"]);
				i.userPossesion += 1;
				cpt++;
			}
		}
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinSpaceShipReturn");
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
		addRessources();
		addArtefacts();
	}
}
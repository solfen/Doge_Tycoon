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
	private var artefactInterline:Float = 0.107;
	private var hasVerticalScrollBar:Bool = false;
	private var ressources:Array<Int>;
	private var artefacts:Array<Dynamic>;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["articleInterline","artefactInterline","ressourcesBackX","ressourcesBackY","ressourceBaseX","ressourceBaseY","ressourceImgX","ressourceImgY","ressourcesTxtX","ressourcesTxtY","ressourcesNbX","ressourcesNbY","artefactsBackX","artefactsBackY","artefactBaseX","artefactBaseY","artefactImgX","artefactImgY","artefactsTxtX","artefactsTxtY","artefactsNbX","artefactsNbY"];
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


	private function new(?startX:Float,?startY:Float, ?optParams:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		articleWidth /= background.width; // background is defiened in MyPopin
		ressources = optParams['ressources'];
		artefacts = optParams['artefacts'];

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

		for(i in 0...ressources.length) {
			if(ressources[i] > 0){
				var x:Float = i*(articleWidth+articleInterline);
				addIcon(ressourceBaseX+x,ressourceBaseY,'PopInMuseeArticleBg.png',"ressourceBase",containers["main"],false);
				addIcon(ressourceImgX+x,ressourceImgY,GameInfo.ressources["poudre"+i].previewImg,"ressourceImg",containers["main"],false);
				addText(ressourcesNbX+x,ressourcesNbY,'FuturaStdHeavy','25px',"x"+ressources[i],'ressourceTxt',containers["main"]);

				GameInfo.ressources["poudre"+i].userPossesion += ressources[i];
			}
		}
	}

	private function addArtefacts(){
		addIcon(artefactsBackX, artefactsBackY,'PopinArticleBgReturn.png',"artefactsBack",containers["main"],false);
		addText(artefactsTxtX,artefactsTxtY,'FuturaStdHeavy','25px',"ARTEFACTS TROUVÉS :",'artefactTxt',containers["main"]);

		var matched:Bool;
		for(i in 0...artefacts.length) {
			matched = false;
			for(planetArtefact in GameInfo.artefacts) {
				if(matched){
					break;
				}
				for(id in planetArtefact.keys()){
					if(artefacts[i].facebookID == id) {
						var x:Float = i*(articleWidth+artefactInterline);
						addIcon(artefactBaseX+x,artefactBaseY, 'PopInMuseeArticleBg.png', "artefactBase", containers["main"], false);
						addIcon(artefactImgX+x,artefactImgY, planetArtefact[id].img, "artefactImg", containers["main"], false);
						addText(artefactsNbX+x,artefactsNbY, 'FuturaStdHeavy', '25px', "x1", 'artefactTxt', containers["main"]);
						planetArtefact[id].userPossesion += 1;
						matched = true;
						break;
					}
				}
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
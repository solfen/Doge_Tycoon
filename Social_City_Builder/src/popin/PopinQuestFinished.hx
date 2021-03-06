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
class PopinQuestFinished extends MyPopin
{	
	private var articleWidth:Float = Texture.fromFrame("PopInMuseeArticleBg.png").width;
	private var articleInterline:Float = 0.02;
	private var hasVerticalScrollBar:Bool = false;
	private var quest:Dynamic;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["articleInterline","ressourcesBackX","ressourcesBackY","ressourceBaseX","ressourceBaseY","ressourceImgX","ressourceImgY","ressourcesTxtX","ressourcesTxtY","ressourcesNbX","ressourcesNbY","dogPosX","dogPosY"];
	private var ressourcesBackX:Float = 0.11;
	private var ressourcesBackY:Float = 0.604;
	private var ressourceBaseX:Float = 0.15;
	private var ressourceBaseY:Float = 0.615;
	private var ressourceImgX:Float = 0.16;
	private var ressourceImgY:Float = 0.63;
	private var ressourcesTxtX:Float = 0.11;
	private var ressourcesTxtY:Float = 0.54;
	private var ressourcesNbX:Float = 0.17;
	private var ressourcesNbY:Float = 0.81;
	private var dogPosX:Float = -0.55;
	private var dogPosY:Float = 0.16;

	private function new(?startX:Float,?startY:Float, ?optParam:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		articleWidth /= background.width; // background is defiened in MyPopin
		quest = optParam['quest'];

		addHeader(0.55,0.05,Texture.fromFrame('PopinQuestFinishedHeader.png'));
		addIcon(-0.15,-0.15,'PopInTitleQuest.png',"popInTitle",this,false);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addContainer("main",this,0,0);
		addQuest();
		addRessources();
		//debugGUI();
	}
	private function addQuest() {
		addText(0.115,0.15,'FuturaStdHeavy','25px',"QUETE :",'ressourceTxt',containers["main"]);
		addIcon(0.115,0.2,'PopInQuestBgArticle.png',"articleBase",containers["main"],false);
		addIcon(0.13,0.21, 'IconDog'+quest.dog+'.png',"ArticlePreview",containers["main"],false);
		addText(0.298,0.2,'FuturaStdHeavy','25px',quest.title,'titleText',containers["main"]);
		addText(0.298,0.25,'FuturaStdMedium','12px',quest.description,'Description',containers["main"]);
		addIcon(quest.dogX,quest.dogY,'assets/Dogs/Dog' + quest.dog + '.png',"dog",containers["main"],false);
	}
	private function addRessources(){
		addIcon(ressourcesBackX, ressourcesBackY,'PopinArticleBgReturn.png',"ressourcesBack",containers["main"],false);
		addText(ressourcesTxtX,ressourcesTxtY,'FuturaStdHeavy','25px',"RÉCOMPENSE :",'ressourceTxt',containers["main"]);

		var cpt:Int = 0;
		var ressources:Array<Dynamic> = quest.rewards;
		for(i in ressources) {
			var x:Float = cpt*(articleWidth+articleInterline);
			var nb:Int = Std.int(i.quantity);
			addIcon(ressourceBaseX+x,ressourceBaseY,'PopInMuseeArticleBg.png',"ressourceBase",containers["main"],false);
			addIcon(ressourceImgX+x,ressourceImgY,GameInfo.ressources[i.name].previewImg,"ressourceImg",containers["main"],false);
			addText(ressourcesNbX+x,ressourcesNbY,'FuturaStdHeavy','25px',"x"+nb,'ressourceTxt',containers["main"]);
			cpt++;
		}
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinQuestFinished");
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
		addQuest();
	}
}
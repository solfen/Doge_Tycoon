package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;
import externs.dat.gui.GUI;
import utils.events.Event;
import hud.HudManager;
//Popinworkshop is lauched on hangar click
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinWorkshop extends MyPopin 
{	
	private var articleHeight:Float = Texture.fromFrame("PopInQuestBgArticle.png").height;
	private var hasVerticalScrollBar:Bool = false;
	private var workShopModel:Dynamic;
	private var workshopConfig:Dynamic;

	private var gui:GUI;
	private var guiListValues:Array<String> = ["articleBaseX","articleBaseY","articleInterline","articleNameX","articleNameY","articleBuildX","articleBuildY","articlePreviewX","articlePreviewY","startRessourcesX","stepRessourceX","ressourcesY","startQuantityX","quantityStepX","quantityY"];
	private var articleBaseX:Float = 0.31;
	private var articleBaseY:Float = 0.16;
	private var articleInterline:Float = 0.03;
	private var articleNameX:Float = 0.49;
	private var articleNameY:Float = 0.19;
	private var articleBuildX:Float = 0.838;
	private var articleBuildY:Float = 0.193;
	private var articleNameFontSize:Float = 22;
	private var articlePreviewX:Float = 0.33;
	private var articlePreviewY:Float = 0.18;
	private var startRessourcesX:Float = 0.49;
	private var stepRessourceX:Float = 0.07;
	private var ressourcesY:Float = 0.266;
	private var startQuantityX:Float = 0.5;
	private var quantityStepX:Float = 0.07;
	private var quantityY:Float = 0.31;

	private function new(?startX:Float,?startY:Float,?optParams:Map<String,Dynamic>) 
	{
		//debugGUI();
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		workshopConfig = GameInfo.actualWorkshops['51']; // TODO : obtain ID from param
		workShopModel = GameInfo.workshopsModels[workshopConfig.workshopType];
		headerTextures = [ 
			'atelier'=>Texture.fromFrame('PopInWorkshopHeader.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin
		addContainer("verticalScroller",this,0,0);
		addHeader(0.65,0.05,headerTextures['atelier']);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addIcon(-0.15,-0.15,'PopInTitleWorkshop.png',"popInTitle",this,false);
		addIcon(-0.4,0.27,'assets/Dogs/DogHangarWorkshop.png',"dog",this,false);
		workshopConfig.state == 'buy' ? addBuyState():null;
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addBuyState(){
		addIcon(0.1,0.15,workShopModel.previewImg,"destinationPreview",containers["verticalScroller"],false);
		addIcon(0.1,0.39,'PopInWorkshopBgPlanet.png',"destinationTextBg",containers["verticalScroller"],false);
		addText(0.105,0.41,'FuturaStdHeavy','14px',workShopModel.destination,'description',containers["verticalScroller"],'white');
		for(i in 0...workshopConfig.level){
			var y:Float = i*(articleHeight+articleInterline);
			var article:Dynamic =  workShopModel.spaceships[i];
			var ressources:Array<Dynamic> = article.ressources;
			addIcon(articleBaseX,articleBaseY+y,'PopInWorkshopArticleBG.png',"articleBase"+i,containers["verticalScroller"],false);
			addIcon(articlePreviewX,articlePreviewY+y,article.previewImg,"ArticlePreview"+i,containers["verticalScroller"],false);
			addText(articleNameX,articleNameY+y,'FuturaStdHeavy',articleNameFontSize+'px',article.name,'articleName'+i,containers["verticalScroller"],'black');
			addIcon(articleBuildX,articleBuildY+y,'PopInBuiltSoftNormal.png',"buildSoft"+i,containers["verticalScroller"],true,'PopInBuiltSoftActive.png',true);
			for(j in 0...ressources.length){
				addIcon(startRessourcesX+stepRessourceX*j,ressourcesY+y,GameInfo.ressources[ressources[j].name].iconImg,"ressource"+j, containers["verticalScroller"],false);
				addText(startQuantityX+quantityStepX*j,quantityY+y,'FuturaStdHeavy','13px',ressources[j].quantity,"ressourceQunatity"+j, containers["verticalScroller"],'white');
			}
		}
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			close();
		}
		else if(pEvent.target._name.indexOf("buildSoft") != -1){
			icons[pEvent.target._name].setTextureToNormal();

			var index:Int = Std.parseInt(pEvent.target._name.split('buildSoft')[1]); // deduce the index from the name
			var ressources:Array<Dynamic> = workShopModel.spaceships[index].ressources;
			var canBuy:Bool = true;

			for(i in ressources){
				if(GameInfo.ressources[i.name].userPossesion < i.quantity){
					canBuy = false;
					break;
				}
			}
			if(canBuy){
				for(i in ressources){
					GameInfo.ressources[i.name].userPossesion -= i.quantity;
				}
				HudManager.getInstance().updateChildsText();
				PopinManager.getInstance().updateInventory();
				workshopConfig.buildTimeStart = haxe.Timer.stamp();
				close();
			}
		}
	}
	private function close(){
		GameInfo.can_map_update = true;
		if(gui != null) gui.destroy();
		PopinManager.getInstance().closePopin("PopinWorkshop");
	}
	private function refresh() {
		containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
		addBuyState();
	}
	private function debugGUI(){
		gui = new GUI();
		//gui.remember(this);
		for(i in guiListValues){
			gui.add(this, i,0,1).step(0.0001).onChange(function(newValue) {
				refresh();
			});
		}
	}
}
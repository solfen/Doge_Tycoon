package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinBuild extends MyPopin
{	
	private var articleHeight:Float = Texture.fromImage("assets/UI/PopInBuilt/PopInBuiltBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var currentTab:String = "nicheTab";
	private function new(?startX:Float,?startY:Float) 
	{
		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		articleHeight /= background.height; // background is defiened in MyPopin
		addIcon(-0.15,-0.15,'assets/UI/PopInBuilt/PopInTitleConstruction.png',"popInTitle",this,false);
		addIcon(0.65,0.05,'assets/UI/PopInBuilt/PopInHeaderNiches.png',"categoryHeader",this,false);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollBackground.png',"contentBackground",this,false);

		addIcon(-0.02,0.17,'assets/UI/PopInBuilt/PopInOngletNicheNormal.png',"nicheTab",this,true,'assets/UI/PopInBuilt/PopInOngletNicheActive.png');
		addIcon(-0.02,0.29,'assets/UI/PopInBuilt/PopInOngletFuseeNormal.png',"spaceshipTab",this,true,'assets/UI/PopInBuilt/PopInOngletFuseeActive.png');
		addIcon(-0.02,0.41,'assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png',"utilitairesTab",this,true,'assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png');
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png');

		addContainer("verticalScroller",this,0,0);
		addMask(childs["contentBackground"].x, childs["contentBackground"].y+3, childs["contentBackground"].width, childs["contentBackground"].height-6,containers["verticalScroller"]);
		addBuildArticles(GameInfo.buildMenuArticles.niches);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollOverlay.png',"scrollOverlay",this,false);
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addBuildArticles(ItemsConfig:Array<Dynamic>){
		var cpt:Int = 0;
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for(i in ItemsConfig){
			var y:Float = cpt*(articleHeight+articleInterline);
			var ressources:Array<Dynamic> = i.ressources;
			addIcon(0.125,0.175+y,'assets/UI/PopInBuilt/PopInBuiltBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.697,0.309+y,'assets/UI/PopInBuilt/PopInBuiltSoftNormal.png',"buildSoft",containers["verticalScroller"],true);
			addIcon(0.825,0.309+y,'assets/UI/PopInBuilt/PopInBuiltHardNormal.png',"buildHard",containers["verticalScroller"],true);
			addIcon(0.14,0.1875+y,'assets/UI/Icons/Buildings/'+i.img+'.png',"ArticlePreview",containers["verticalScroller"],false);
			addIcon(0.758,0.3+y,'assets/UI/Icons/IconsRessources/IconOsDor.png',"HardRessource",containers["verticalScroller"],false);
			addText(0.78,0.34+y,'FuturaStdHeavy','15px',i.hardPrice,'HardRessourcePrice',containers["verticalScroller"]);

			for(j in 0...ressources.length){
				addIcon(0.308+0.065*j,0.3+y,'assets/UI/Icons/IconsRessources/'+ressources[j].img+'.png',"SoftRessource"+j,containers["verticalScroller"],false);
				addText(0.315+0.065*j,0.34+y,'FuturaStdHeavy','15px',ressources[j].price,"SoftRessourcePrice"+j,containers["verticalScroller"]);
			}

			if( (cpt*(articleHeight+articleInterline)+articleHeight)*background.height > childs["contentBackground"].height){
				addVerticalScrollBar();
				hasVerticalScrollBar = true;
			}
			cpt++;
		}
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			PopinManager.getInstance().closePopin("PopinBuild");
		}
		else if(pEvent.target._name == "nicheTab" && currentTab != "nicheTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.niches);
			currentTab = "nicheTab";
		}
		else if(pEvent.target._name == "spaceshipTab" && currentTab != "spaceshipTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.spacechips);
			currentTab = "spaceshipTab";
		}
		else if(pEvent.target._name == "utilitairesTab" && currentTab != "utilitairesTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
			currentTab = "utilitairesTab";
		}
		else if(pEvent.target._name == "buildSoft"){
			//we deduce the index of the article (first article in list is 0) from its position
			var index:Int = Math.round(((pEvent.target.y+background.height/2)/background.height - 0.309)/(articleHeight+articleInterline));
			if(currentTab == "nicheTab")
				trace("trying to buy the article : " + index + " here's the ressources needed : ", GameInfo.buildMenuArticles.niches[index].ressources);
			else if(currentTab == "spaceshipTab")
				trace("trying to buy the article : " + index + " here's the ressources needed : ", GameInfo.buildMenuArticles.spacechips[index].ressources);
			else if(currentTab == "utilitairesTab")
				trace("trying to buy the article : " + index + " here's the ressources needed : ", GameInfo.buildMenuArticles.utilitaires[index].ressources);
		}
		else if(pEvent.target._name == "buildHard"){
			//we deduce the index of the article (first article in list is 0) from its position
			var index:Int = Math.round(((pEvent.target.y+background.height/2)/background.height - 0.309)/(articleHeight+articleInterline));
			if(currentTab == "nicheTab")
				trace("trying to buy the article : " + index + " here's the hard price : ", GameInfo.buildMenuArticles.niches[index].hardPrice);
			else if(currentTab == "spaceshipTab")
				trace("trying to buy the article : " + index + " here's the hard price : ", GameInfo.buildMenuArticles.spacechips[index].hardPrice);
			else if(currentTab == "utilitairesTab")
				trace("trying to buy the article : " + index + " here's the hard price : ", GameInfo.buildMenuArticles.utilitaires[index].hardPrice);
		}
	}
}
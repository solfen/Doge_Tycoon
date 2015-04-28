package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;
import hud.HudManager;
//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinBuild extends MyPopin
{	
	private var articleHeight:Float = Texture.fromImage("assets/UI/PopInBuilt/PopInBuiltBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var currentTab:String = "utilitairesTab";

	private function new(?startX:Float,?startY:Float) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		headerTextures = [
			'niches'=>Texture.fromImage('assets/UI/PopInBuilt/PopInHeaderNiches.png'),
			'spaceships'=>Texture.fromImage('assets/UI/PopInBuilt/PopInHeaderFusees.png'),
			'utilitaire'=>Texture.fromImage('assets/UI/PopInBuilt/PopInHeaderUtilitaires.png')
		];
		articleHeight /= background.height; // background is defiened in MyPopin

		addHeader(0.65,0.05,headerTextures['utilitaire']);
		addIcon(-0.15,-0.15,'assets/UI/PopInBuilt/PopInTitleConstruction.png',"popInTitle",this,false);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollBackground.png',"contentBackground",this,false);

		addIcon(-0.02,0.17,'assets/UI/PopInBuilt/PopInOngletNicheNormal.png',"nicheTab",this,true,'assets/UI/PopInBuilt/PopInOngletNicheActive.png',true);
		addIcon(-0.02,0.29,'assets/UI/PopInBuilt/PopInOngletFuseeNormal.png',"spaceshipTab",this,true,'assets/UI/PopInBuilt/PopInOngletFuseeActive.png',true);
		addIcon(-0.02,0.41,'assets/UI/PopInBuilt/PopInOngletUtilitairesNormal.png',"utilitairesTab",this,true,'assets/UI/PopInBuilt/PopInOngletUtilitairesActive.png',true);
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png',true);

		addContainer("verticalScroller",this,0,0);
		addMask(icons["contentBackground"].x, icons["contentBackground"].y+3, icons["contentBackground"].width, icons["contentBackground"].height-6,containers["verticalScroller"]);
		addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
		icons[currentTab].setTextureToActive();
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
			addIcon(0.115,0.175+y,'assets/UI/PopInBuilt/PopInBuiltBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.687,0.309+y,'assets/UI/PopInBuilt/PopInBuiltSoftNormal.png',"buildSoft"+cpt,containers["verticalScroller"],true,'assets/UI/PopInBuilt/PopInBuiltSoftActive.png',true);
			addIcon(0.815,0.309+y,'assets/UI/PopInBuilt/PopInBuiltHardNormal.png',"buildHard"+cpt,containers["verticalScroller"],true,'assets/UI/PopInBuilt/PopInBuiltHardActive.png',true);
			addIcon(0.13,0.1875+y,i.previewImg,"ArticlePreview",containers["verticalScroller"],false);
			addIcon(0.748,0.3+y,GameInfo.ressources['hardMoney'].iconImg,"HardRessource",containers["verticalScroller"],false);
			addText(0.77,0.34+y,'FuturaStdHeavy','15px',i.hardPrice,'HardRessourcePrice',containers["verticalScroller"],'white');
			addText(0.298,0.18+y,'FuturaStdHeavy','25px',i.title,'titleText',containers["verticalScroller"]);
			addText(0.298,0.23+y,'FuturaStdMedium','12px',i.description,'Description',containers["verticalScroller"]);

			for(j in 0...ressources.length){
				addIcon(0.298+0.065*j,0.3+y,GameInfo.ressources[ressources[j].name].iconImg,"SoftRessource"+j, containers["verticalScroller"],false);
				addText(0.305+0.065*j,0.345+y,'FuturaStdHeavy','13px',ressources[j].quantity,"SoftRessourcePrice"+j, containers["verticalScroller"],'white');
			}

			if( (cpt*(articleHeight+articleInterline)+articleHeight)*background.height > icons["contentBackground"].height && !hasVerticalScrollBar){
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
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinBuild");
		}
		else if(pEvent.target._name == "nicheTab" && currentTab != "nicheTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.niches);
			currentTab = "nicheTab";
			header.setTexture(headerTextures['niches']);
			icons['spaceshipTab'].setTextureToNormal();
			icons['utilitairesTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == "spaceshipTab" && currentTab != "spaceshipTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.spacechips);
			currentTab = "spaceshipTab";
			header.setTexture(headerTextures['spaceships']);
			icons['nicheTab'].setTextureToNormal();
			icons['utilitairesTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == "utilitairesTab" && currentTab != "utilitairesTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.buildMenuArticles.utilitaires);
			currentTab = "utilitairesTab";
			header.setTexture(headerTextures['utilitaire']);
			icons['nicheTab'].setTextureToNormal();
			icons['spaceshipTab'].setTextureToNormal();
		}
		else if(pEvent.target._name.indexOf("buildSoft") != -1){
			icons[pEvent.target._name].setTextureToNormal();
			var index:Int = Std.parseInt(pEvent.target._name.split('buildSoft')[1]); // deduce the index from the name
			var ressources:Array<Dynamic>;
			var article:Dynamic = {};
			var canBuy:Bool = true;

			if(currentTab == "nicheTab")
				article = GameInfo.buildMenuArticles.niches[index];
			else if(currentTab == "spaceshipTab")
				article = GameInfo.buildMenuArticles.spacechips[index];
			else if(currentTab == "utilitairesTab")
				article = GameInfo.buildMenuArticles.utilitaires[index];

			ressources = article.ressources;
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
				GameInfo.building_2_build = article.buildingID;
				HudManager.getInstance().updateChildsText();
				GameInfo.can_map_update = true;
				PopinManager.getInstance().closePopin("PopinBuild");
				PopinManager.getInstance().updateInventory();
			}
		}
		else if(pEvent.target._name.indexOf("buildHard") != -1){
			icons[pEvent.target._name].setTextureToNormal();
			var index:Int = Std.parseInt(pEvent.target._name.split('buildHard')[1]);
			var article:Dynamic = {};
			if(currentTab == "nicheTab")
				article = GameInfo.buildMenuArticles.niches[index];
			else if(currentTab == "spaceshipTab")
				article = GameInfo.buildMenuArticles.spacechips[index];
			else if(currentTab == "utilitairesTab")
				article = GameInfo.buildMenuArticles.utilitaires[index];

			if(GameInfo.ressources['hardMoney'].userPossesion >= article.hardPrice){
				GameInfo.ressources['hardMoney'].userPossesion -= article.hardPrice;
				HudManager.getInstance().updateChildsText();
				GameInfo.building_2_build = article.buildingID;
				GameInfo.can_map_update = true;
				PopinManager.getInstance().closePopin("PopinBuild");
				PopinManager.getInstance().updateInventory();
			}
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == 'nicheTab' && currentTab != 'nicheTab'){
			icons['nicheTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == 'spaceshipTab' && currentTab != 'spaceshipTab'){
			icons['spaceshipTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == 'utilitairesTab' && currentTab != 'utilitairesTab'){
			icons['utilitairesTab'].setTextureToNormal();
		}
		else if(pEvent.target._name.indexOf("buildHard") != -1 || pEvent.target._name.indexOf("buildSoft") != -1){
			icons[pEvent.target._name].setTextureToNormal();
		}
		else if(pEvent.target._name == "closeButton"){
			icons["closeButton"].setTextureToNormal();
		}
	}
}
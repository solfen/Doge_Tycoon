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

		addContainer("VertivalScrollContainer",this,0,0);
		addMask(childs["contentBackground"].x, childs["contentBackground"].y+3, childs["contentBackground"].width, childs["contentBackground"].height-6,containers["VertivalScrollContainer"]);
		addIconsFromConfig(GameInfo.buildMenuArticles.niches);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollOverlay.png',"scrollOverlay",this,false);
	}

	// the items in this popin are defined in GameInfo
	private function addIconsFromConfig(ItemsConfig:Array<Dynamic>){
		var cpt:Int = 0;
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for (i in ItemsConfig){
			var typedSprites:Array<Dynamic> = i.sprites;
			if( (cpt*(articleHeight+articleInterline)+articleHeight)*background.height > childs["contentBackground"].height){
				addVerticalScrollBar();
				hasVerticalScrollBar = true;
			}
			for(j in typedSprites){
				var y:Float = j.y+(cpt*(articleHeight+articleInterline));
				addIcon(j.x , y , j.sprite, j.name ,containers["VertivalScrollContainer"], j.isInteractive );
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
			containers["VertivalScrollContainer"].children = [];
			containers["VertivalScrollContainer"].position.set(0,0);
			addIconsFromConfig(GameInfo.buildMenuArticles.niches);
			currentTab = "nicheTab";
		}
		else if(pEvent.target._name == "spaceshipTab" && currentTab != "spaceshipTab"){
			containers["VertivalScrollContainer"].children = [];
			containers["VertivalScrollContainer"].position.set(0,0);
			addIconsFromConfig(GameInfo.buildMenuArticles.spacechips);
			currentTab = "spaceshipTab";
		}
		else if(pEvent.target._name == "utilitairesTab" && currentTab != "utilitairesTab"){
			containers["VertivalScrollContainer"].children = [];
			containers["VertivalScrollContainer"].position.set(0,0);
			addIconsFromConfig(GameInfo.buildMenuArticles.utilitaires);
			currentTab = "utilitairesTab";
		}
	}
}
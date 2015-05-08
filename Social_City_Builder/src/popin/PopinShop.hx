package popin;
import popin.MyPopin;
import hud.HudManager;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinShop extends MyPopin
{	
	private var articleHeight:Float = Texture.fromFrame("PopInShopBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var currentTab:String = "softTab";

	private function new(?startX:Float,?startY:Float) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		headerTextures = [
			'softTab'=>Texture.fromFrame('PopInHeaderDogflooz.png'),
			'hardTab'=>Texture.fromFrame('PopInHeaderOsDOr.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin

		addHeader(0.65,0.05,headerTextures['softTab']);
		addIcon(-0.15,-0.15,'PopInTitleShop.png',"popInTitle",this,false);
		addIcon(0.09,0.15,'PopInScrollBackground.png',"contentBackground",this,false);
		addIcon(0.65, 0.875,'PopInShopButtonConfirmNormal.png',"confirmBtn",this,true,'PopInShopButtonConfirmActive.png',true);

		addIcon(-0.02,0.17,'PopInOngletSoftNormal.png',"softTab",this,true,'PopInOngletSoftActive.png',true);
		addIcon(-0.02,0.29,'PopInOngletHardNormal.png',"hardTab",this,true,'PopInOngletHardActive.png',true);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);

		addContainer("verticalScroller",this,0,0);
		addMask(icons["contentBackground"].x, icons["contentBackground"].y+3, icons["contentBackground"].width, icons["contentBackground"].height-6,containers["verticalScroller"]);
		addMarketArticles(GameInfo.shopArticles['soft']);
		icons["softTab"].setTextureToActive();
		addIcon(0.09,0.15,'PopInScrollOverlay.png',"scrollOverlay",this,false);
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addMarketArticles(ItemsConfig:Map<String,Dynamic>){
		var cpt:Int = 0;
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for(i in ItemsConfig){
			var y:Float = cpt*(articleHeight+articleInterline);

			addIcon(0.115,0.17+y,'PopInShopBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.13,0.1875+y,i.previewImg,"ArticlePreview",containers["verticalScroller"],false);
			addText(0.298,0.18+y,'FuturaStdHeavy','25px',i.name,'titleText',containers["verticalScroller"]);
			addText(0.31,0.24+y,'FuturaStdMedium','13px',i.text,'titleText',containers["verticalScroller"]);
			addIcon(0.757,0.24+y,'PopInMarketValidNormal.png',"validBtn"+cpt,containers["verticalScroller"],true,'PopInMarketValidActive.png',true);
			addText(0.66,0.26+y,'FuturaStdHeavy','25px',i.price+'€',"price",containers["verticalScroller"]);

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
		var name:String = pEvent.target._name;
		if(name == "closeButton"){
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinShop");
		}
		else if(name == "softTab" && currentTab != "softTab"){
			currentTab = "softTab";
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addMarketArticles(GameInfo.shopArticles['soft']);
			header.setTexture(headerTextures['softTab']);
			icons['hardTab'].setTextureToNormal();
		}
		else if(name == "hardTab" && currentTab != "hardTab"){
			currentTab = "hardTab";
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addMarketArticles(GameInfo.shopArticles['hard']);
			header.setTexture(headerTextures['hardTab']);
			icons['softTab'].setTextureToNormal();
		}

		else if(name.indexOf("validBtn") != -1){
			var index:Int = Std.parseInt(name.split('validBtn')[1]);
			if(currentTab == "softTab"){

			}
			else if(currentTab == "hardTab"){

			}
		}
		else if(name == "confirmBtn"){
			icons[name].setTextureToNormal();
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == 'softTab' && currentTab != 'softTab'){
			icons['softTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == 'hardTab' && currentTab != 'hardTab'){
			icons['hardTab'].setTextureToNormal();
		}		
		else if(pEvent.target._name.indexOf("validBtn") != -1){
			var index:Int = Std.parseInt(pEvent.target._name.split('validBtn')[1]);
			icons['validBtn'+index].setTextureToNormal();
		}
		else if(pEvent.target._name == "closeButton"){
			icons["closeButton"].setTextureToNormal();
		}
	}
}
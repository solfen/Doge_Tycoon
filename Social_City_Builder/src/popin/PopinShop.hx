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
	private var articleHeight:Float = Texture.fromImage("assets/UI/PopInMarket/PopInMarketBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var currentTab:String = "softTab";

	private function new(?startX:Float,?startY:Float) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		headerTextures = [
			'softTab'=>Texture.fromImage('assets/UI/PopInShop/PopInHeaderDogflooz.png'),
			'hardTab'=>Texture.fromImage('assets/UI/PopInShop/PopInHeaderOsDOr.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin

		addHeader(0.65,0.05,headerTextures['softTab']);
		addIcon(-0.15,-0.15,'assets/UI/PopInMarket/PopInTitleMarket.png',"popInTitle",this,false);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollBackground.png',"contentBackground",this,false);

		addIcon(-0.02,0.17,'assets/UI/PopInMarket/PopInOngletBuyNormal.png',"buyTab",this,true,'assets/UI/PopInMarket/PopInOngletBuyActive.png',true);
		addIcon(-0.02,0.29,'assets/UI/PopInMarket/PopInOngletSellNormal.png',"sellTab",this,true,'assets/UI/PopInMarket/PopInOngletSellActive.png',true);
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png',true);

		addContainer("verticalScroller",this,0,0);
		addMask(icons["contentBackground"].x, icons["contentBackground"].y+3, icons["contentBackground"].width, icons["contentBackground"].height-6,containers["verticalScroller"]);
		addMarketArticles(GameInfo.ressources);
		icons["buyTab"].setTextureToActive();
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollOverlay.png',"scrollOverlay",this,false);
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addMarketArticles(ItemsConfig:Map<String,Dynamic>){
		var cpt:Int = 0;
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for(i in ItemsConfig.keys()){
			if(i.indexOf('poudre') == -1)
				continue;

			var article = GameInfo.ressources[i];
			var y:Float = cpt*(articleHeight+articleInterline);

			addIcon(0.115,0.17+y,'assets/UI/PopInMarket/PopInMarketBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.13,0.1875+y,article.previewImg,"ArticlePreview",containers["verticalScroller"],false);
			addText(0.298,0.18+y,'FuturaStdHeavy','25px',article.name,'titleText',containers["verticalScroller"]);
			addIcon(0.42,0.253+y,'assets/UI/PopInMarket/PopInMarketNbArticleNormal.png',"1unit"+cpt,containers["verticalScroller"],true,'assets/UI/PopInMarket/PopInMarketNbArticleActive.png',true);
			addText(0.45,0.263+y,'FuturaStdHeavy','25px','x1','1unitText',containers["verticalScroller"]);
			addIcon(0.52,0.253+y,'assets/UI/PopInMarket/PopInMarketNbArticleNormal.png',"10unit"+cpt,containers["verticalScroller"],true,'assets/UI/PopInMarket/PopInMarketNbArticleActive.png',true);
			addText(0.535,0.263+y,'FuturaStdHeavy','25px','x10','10unitText',containers["verticalScroller"]);
			addIcon(0.62,0.253+y,'assets/UI/PopInMarket/PopInMarketNbArticleNormal.png',"100unit"+cpt,containers["verticalScroller"],true,'assets/UI/PopInMarket/PopInMarketNbArticleActive.png',true);
			addText(0.625,0.263+y,'FuturaStdHeavy','25px','x100','100unitText',containers["verticalScroller"]);
			addIcon(0.757,0.24+y,'assets/UI/PopInMarket/PopInMarketValidNormal.png',"validBtn"+cpt,containers["verticalScroller"],true,'assets/UI/PopInMarket/PopInMarketValidActive.png',true);

			addIcon(0.31,0.253+y,GameInfo.ressources['fric'].iconImg,"SoftRessource",containers["verticalScroller"],false);
			var cost:Float;
			article.lastQuantityBuy = 0;
			article.lastQuantitySell = 0;
			if(currentTab == 'buyTab'){
				cost = article.buyCost;
				/*if(article.lastQuantityBuy) // if user has already selected a quantity we select it by default (as it might leads to user mistakes i comented it maybe let the user choose in config)
					icons[article.lastQuantityBuy+"unit"+cpt].setTextureToActive();*/
			}
			else{
				cost = article.sellCost;
				/*if(article.lastQuantitySell) // if user has already selected a quantity we select it by default
					icons[article.lastQuantitySell+"unit"+cpt].setTextureToActive();*/
			}
			addText(0.317,0.3+y,'FuturaStdHeavy','13px',cost+'',"SoftRessourcePrice",containers["verticalScroller"],'white');

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
			PopinManager.getInstance().closePopin("PopinMarket");
		}
		else if(name == "buyTab" && currentTab != "buyTab"){
			currentTab = "buyTab";
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addMarketArticles(GameInfo.ressources);
			header.setTexture(headerTextures['buy']);
			icons['sellTab'].setTextureToNormal();
		}
		else if(name == "sellTab" && currentTab != "sellTab"){
			currentTab = "sellTab";
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addMarketArticles(GameInfo.ressources);
			header.setTexture(headerTextures['sell']);
			icons['buyTab'].setTextureToNormal();
		}
		else if(name.indexOf('1unit') != -1){
			var index:Int = Std.parseInt(name.split('1unit')[1]); //we deduce the index from the name
			icons['10unit'+index].setTextureToNormal();
			icons['100unit'+index].setTextureToNormal();
			currentTab == "buyTab" ? GameInfo.ressources['poudre'+index].lastQuantityBuy = 1:GameInfo.ressources['poudre'+index].lastQuantitySell = 1;
		}
		else if(name.indexOf('10unit') != -1){
			var index:Int = Std.parseInt(name.split('10unit')[1]);
			icons['1unit'+index].setTextureToNormal();
			icons['100unit'+index].setTextureToNormal();
			currentTab == "buyTab" ? GameInfo.ressources['poudre'+index].lastQuantityBuy = 10:GameInfo.ressources['poudre'+index].lastQuantitySell = 10;
		}
		else if(name.indexOf('100unit') != -1){
			var index:Int = Std.parseInt(name.split('100unit')[1]);
			icons['1unit'+index].setTextureToNormal();
			icons['10unit'+index].setTextureToNormal();
			currentTab == "buyTab" ? GameInfo.ressources['poudre'+index].lastQuantityBuy = 100:GameInfo.ressources['poudre'+index].lastQuantitySell = 100;
		}
		else if(name.indexOf("validBtn") != -1){
			var index:Int = Std.parseInt(name.split('validBtn')[1]);
			icons['validBtn'+index].setTextureToNormal();
			if(currentTab == "buyTab"){
				//lastquantity sell and buy are updated eachTime the user clicks on a quantityButton
				var cost:Float = GameInfo.ressources['poudre'+index].buyCost * GameInfo.ressources['poudre'+index].lastQuantityBuy;
				if(cost <= GameInfo.ressources['fric'].userPossesion){
					GameInfo.ressources['fric'].userPossesion -= cost;
					GameInfo.ressources['poudre'+index].userPossesion += GameInfo.ressources['poudre'+index].lastQuantityBuy;
					HudManager.getInstance().updateChildText();
				}
			}
			else if(currentTab == "sellTab"){
				var cost:Float = GameInfo.ressources['poudre'+index].sellCost * GameInfo.ressources['poudre'+index].lastQuantitySell;
				if(GameInfo.ressources['poudre'+index].userPossesion >= GameInfo.ressources['poudre'+index].lastQuantitySell){
					GameInfo.ressources['fric'].userPossesion += cost;
					GameInfo.ressources['poudre'+index].userPossesion -= GameInfo.ressources['poudre'+index].lastQuantitySell;
					HudManager.getInstance().updateChildText();
				}
			}
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == 'buyTab' && currentTab != 'buyTab'){
			icons['buyTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == 'sellTab' && currentTab != 'sellTab'){
			icons['sellTab'].setTextureToNormal();
		}		
		else if(pEvent.target._name.indexOf("validBtn") != -1){
			var index:Int = Std.parseInt(pEvent.target._name.split('validBtn')[1]);
			icons['validBtn'+index].setTextureToNormal();
		}
		else if(pEvent.target._name == "closeButton"){
			icons["closeButton"].setTextureToNormal();
		}		
		else if(pEvent.target._name.indexOf('1unit') != -1){
			var index:Int = Std.parseInt(pEvent.target._name.split('1unit')[1]); //we deduce the index from the pEvent.target._name
			icons['1unit'+index].setTextureToNormal();
		}
		else if(pEvent.target._name.indexOf('10unit') != -1){
			var index:Int = Std.parseInt(pEvent.target._name.split('10unit')[1]);
			icons['10unit'+index].setTextureToNormal();
		}
		else if(pEvent.target._name.indexOf('100unit') != -1){
			var index:Int = Std.parseInt(pEvent.target._name.split('100unit')[1]);
			icons['100unit'+index].setTextureToNormal();
		}
	}
}
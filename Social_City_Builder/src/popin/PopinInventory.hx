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
class PopinInventory extends MyPopin
{	
	private var articleHeight:Float = Texture.fromFrame("PopInInventoryArticleBg.png").height;
	private var articleInterline:Float = 0.01;
	private var hasVerticalScrollBar:Bool = false;
	private var isDraging:Bool = false;
	private var scrollHandle:Float = 0;
	private var textColor:String = "black";

	private function new(?startX:Float,?startY:Float) 
	{
		super(startX,startY, "PopInInventoryBackground.png");
		articleHeight /= background.height; // background is defiened in MyPopin

		addIcon(0,0,'PopInInventoryBackground.png',"contentBackground",this,false);
		addIcon(-0.15,-0.1,'PopInInventoryTitle.png',"title",this,false);
		addIcon(0.875, -0.025,'PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'PopInInventoryCloseButtonActive.png',true);

		addContainer("verticalScroller",this,0,0);
		//addMask(icons["contentBackground"].x, icons["contentBackground"].y+3, icons["contentBackground"].width, icons["contentBackground"].height-6,containers["verticalScroller"]);
		addRessourcestArticles(GameInfo.ressources);
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addRessourcestArticles(ItemsConfig:Map<String,Dynamic>){
		var cpt:Int = 0;
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for(i in ItemsConfig.keys()){
			var article = GameInfo.ressources[i];
			var y:Float = cpt*(articleHeight+articleInterline);

			addIcon(0.1,0.065+y,'PopInInventoryArticleBg.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.135,0.069+y,article.iconImg,"ArticlePreview",containers["verticalScroller"],false);
			addText(0.40,0.069+y,'FuturaStdHeavy','15px',article.name,'nameText',containers["verticalScroller"],textColor);
			addText(0.4,0.12+y,'FuturaStdHeavy','15px',article.userPossesion,'titleText',containers["verticalScroller"],textColor);

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
			PopinManager.getInstance().closePopin("PopinInventory");
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			icons["closeButton"].setTextureToNormal();
		}		
	}
	override public function update(){
		containers["verticalScroller"].children = [];
		addRessourcestArticles(GameInfo.ressources);
	}
}
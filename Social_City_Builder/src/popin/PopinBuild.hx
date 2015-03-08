package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinBuild extends MyPopin
{	
	private var articleHeight:Float = Texture.fromImage("assets/UI/PopInBuilt/PopInBuiltBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private function new(?startX:Float,?startY:Float) 
	{
		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		articleHeight /= background.height; // background is defiened in MyPopin
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true);
		addIcon(-0.15,-0.15,'assets/UI/PopInBuilt/PopInTitleConstruction.png',"popInTitle",this,false);
		addIcon(0.65,0.05,'assets/UI/PopInBuilt/PopInHeaderNiches.png',"categoryHeader",this,false);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollBackground.png',"contentBackground",this,false);
		addContainer("VertivalScrollContainer",this,-10,0);
		addMask(childs["contentBackground"].x, childs["contentBackground"].y+3, childs["contentBackground"].width, childs["contentBackground"].height-6,containers["VertivalScrollContainer"]);
		addIconsFromConfig(GameInfo.buildMenuArticles.niches);
		addIcon(0.09,0.15,'assets/UI/PopIn/PopInScrollOverlay.png',"scrollOverlay",this,false);
		//containers["VertivalScrollContainer"].y += 150;
	}

	// the items in this popin are defined in GameInfo
	private function addIconsFromConfig(ItemsConfig:Array<Dynamic>){
		var cpt:Int = 0;
		for (i in ItemsConfig){
			var typedItem:Array<Dynamic> = i.sprites;
			if( (cpt*(articleHeight+articleInterline)+articleHeight)*background.height > childs["contentBackground"].height ){
				addVerticalScrollBar();
			}
			for(j in typedItem){
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
	}
}
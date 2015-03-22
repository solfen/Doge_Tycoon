package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinWorkshop extends MyPopin
{	
	private var articleHeight:Float = Texture.fromImage("assets/UI/PopInQuest/PopInQuestBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;

	private function new(?startX:Float,?startY:Float) 
	{

		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		headerTextures = [ 
			'atelier'=>Texture.fromImage('assets/UI/PopInWorkshop/PopInWorkshopHeader.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin

		addHeader(0.65,0.05,headerTextures['atelier']);
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png',true);
		addIcon(-0.15,-0.15,'assets/UI/PopInWorkshop/PopInTitleWorkshop.png',"popInTitle",this,false);
		addIcon(0.1,0.15,'assets/UI/Icons/Planet/IconNamek.png',"destinationPreview",this,false);
		addIcon(0.1,0.39,'assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png',"destinationTextBg",this,false);
		addText(0.105,0.41,'FuturaStdHeavy','14px','Wundërland','Description',this,'white');
		addIcon(-0.4,0.27,'assets/Dogs/DogHangarWorkshop.png',"dog",this,false);
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
			var rewards:Array<Dynamic> = i.rewards;
			addIcon(0.115,0.175+y,'assets/UI/PopInQuest/PopInQuestBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.13,0.1875+y,'assets/UI/Icons/Dogs/'+i.previewImg+'.png',"ArticlePreview",containers["verticalScroller"],false);
			addText(0.298,0.175+y,'FuturaStdHeavy','25px',i.title,'titleText',containers["verticalScroller"]);
			addText(0.298,0.225+y,'FuturaStdMedium','12px',i.description,'Description',containers["verticalScroller"]);
			addText(0.71,0.215+y,'FuturaStdHeavy','18px','Récompenses','rewarsText',containers["verticalScroller"]);

			for(j in 0...rewards.length){
				addIcon(0.72+0.07*j,0.287+y,GameInfo.ressources[rewards[j].name].iconImg,"reaward"+j, containers["verticalScroller"],false);
				addText(0.728+0.07*j,0.335+y,'FuturaStdHeavy','13px',rewards[j].quantity,"rawardQuantity"+j, containers["verticalScroller"],'white');
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
			PopinManager.getInstance().closePopin("PopinWorkshop");
		}
	}
}
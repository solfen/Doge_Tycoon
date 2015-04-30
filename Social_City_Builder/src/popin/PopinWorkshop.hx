package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;

////////// !!!!!!!!!!!!!!!!!!!!!!!!!!!     PAS FAIT DU TOUT, NESCITTE TROP D'INFORMATIONS DE BUILDINGS QUE JE N'AI PAS ENCORE !!!!!!!!!!\\\\\\\\\\\\\\\\\\

//Popinworkshop is lauched on hangar click
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinWorkshop extends MyPopin 
{	
	private var articleHeight:Float = Texture.fromFrame("assets/UI/PopInQuest/PopInQuestBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var buildingRef:String;

	private function new(?startX:Float,?startY:Float,?ref:String= 'hangarNamok') 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "assets/UI/PopIn/PopInBackground.png");
		buildingRef = ref;
		headerTextures = [ 
			'atelier'=>Texture.fromFrame('assets/UI/PopInWorkshop/PopInWorkshopHeader.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin

		addHeader(0.65,0.05,headerTextures['atelier']);
		addIcon(0.95, 0,'assets/UI/PopInInventory/PopInInventoryCloseButtonNormal.png',"closeButton",this,true,'assets/UI/PopInInventory/PopInInventoryCloseButtonActive.png',true);
		addIcon(-0.15,-0.15,'assets/UI/PopInWorkshop/PopInTitleWorkshop.png',"popInTitle",this,false);
		addIcon(-0.4,0.27,'assets/Dogs/DogHangarWorkshop.png',"dog",this,false);
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addBuyState(){
		addIcon(0.1,0.15,GameInfo.buildings[buildingRef].previewImg,"destinationPreview",this,false);
		addIcon(0.1,0.39,'assets/UI/PopInWorkshop/PopInWorkshopBgPlanet.png',"destinationTextBg",this,false);
		addText(0.105,0.41,'FuturaStdHeavy','14px',GameInfo.buildings[buildingRef].destination,'description',this,'white');
		for(i in 0...GameInfo.buildings[buildingRef].level){
			var y:Float = i*(articleHeight+articleInterline);
			var article:Dynamic =  GameInfo.buildings[buildingRef].spaceships[i];
			var ressources:Array<Dynamic> = article.ressources;
			addIcon(0.115,0.175+y,'assets/UI/PopInWorkshop/PopInWorkshopArticleBG.png',"articleBase",this,false);
			addIcon(0.13,0.1875+y,'assets/UI/Icons/Dogs/'+article.previewImg+'.png',"ArticlePreview",this,false);
			addText(0.298,0.175+y,'FuturaStdHeavy','25px',article.title,'titleText',this);
			for(j in 0...ressources.length){
				addIcon(0.72+0.07*j,0.287+y,GameInfo.ressources[ressources[j].name].iconImg,"ressource"+j, this,false);
				addText(0.728+0.07*j,0.335+y,'FuturaStdHeavy','13px',ressources[j].quantity,"ressourceQunatity"+j, this,'white');
			}
		}
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			PopinManager.getInstance().closePopin("PopinWorkshop");
		}
	}
}
package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinQuests extends MyPopin
{	
	private var articleHeight:Float = Texture.fromFrame("PopInQuestBgArticle.png").height;
	private var articleInterline:Float = 0.03;
	private var hasVerticalScrollBar:Bool = false;
	private var currentTab:String = "currentQuestsTab";

	private function new(?startX:Float,?startY:Float) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		articleHeight /= background.height; // background is defiened in MyPopin

		addIcon(-0.15,-0.15,'PopInTitleQuest.png',"popInTitle",this,false);
		addIcon(0.09,0.15,'PopInScrollBackground.png',"contentBackground",this,false);

		addIcon(-0.02,0.17,'PopInQuestOngletEnCoursNormal.png',"currentQuestsTab",this,true,'PopInQuestOngletEnCoursActive.png',true);
		addIcon(-0.02,0.29,'PopInQuestOngletFinishNormal.png',"finishedQuestsTab",this,true,'PopInQuestOngletFinishActive.png',true);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);

		addContainer("verticalScroller",this,0,0);
		addMask(icons["contentBackground"].x, icons["contentBackground"].y+3, icons["contentBackground"].width, icons["contentBackground"].height-6,containers["verticalScroller"]);
		addBuildArticles(GameInfo.questsArticles.current);
		icons['currentQuestsTab'].setTextureToActive();
		addIcon(0.09,0.15,'PopInScrollOverlay.png',"scrollOverlay",this,false);
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
			addIcon(0.115,0.175+y,'PopInQuestBgArticle.png',"articleBase",containers["verticalScroller"],false);
			addIcon(0.13,0.1875+y, i.previewImg+'.png',"ArticlePreview",containers["verticalScroller"],false);
			addText(0.298,0.175+y,'FuturaStdHeavy','25px',i.title,'titleText',containers["verticalScroller"]);
			addText(0.298,0.225+y,'FuturaStdMedium','12px',i.description,'Description',containers["verticalScroller"]);
			addText(0.71,0.215+y,'FuturaStdHeavy','18px','Récompenses','rewarsText',containers["verticalScroller"]);

			for(j in 0...rewards.length){
				addIcon(0.72+0.07*j,0.287+y,GameInfo.ressources[rewards[j].name].iconImg,"reaward"+j, containers["verticalScroller"],false);
				addText(0.728+0.07*j,0.335+y,'FuturaStdHeavy','13px',rewards[j].quantity,"rawardQuantity"+j, containers["verticalScroller"],'white');
			}

			if( (cpt*(articleHeight+articleInterline)+articleHeight)*background.height > icons["contentBackground"].height && !hasVerticalScrollBar){
				addScrollBar();
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
			PopinManager.getInstance().closePopin("PopinQuests");
		}
		else if(pEvent.target._name == "currentQuestsTab" && currentTab != "currentQuestsTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.questsArticles.current);
			currentTab = "currentQuestsTab";
			//header.setTexture(headerTextures['niches']);
			icons['finishedQuestsTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == "finishedQuestsTab" && currentTab != "finishedQuestsTab"){
			containers["verticalScroller"].children = [];
			containers["verticalScroller"].position.set(0,0);
			addBuildArticles(GameInfo.questsArticles.finished);
			currentTab = "finishedQuestsTab";
			//header.setTexture(headerTextures['spaceships']);
			icons['currentQuestsTab'].setTextureToNormal();
		}

	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == 'currentQuestsTab' && currentTab != 'currentQuestsTab'){
			icons['currentQuestsTab'].setTextureToNormal();
		}
		else if(pEvent.target._name == 'finishedQuestsTab' && currentTab != 'finishedQuestsTab'){
			icons['finishedQuestsTab'].setTextureToNormal();
		}
	}
}
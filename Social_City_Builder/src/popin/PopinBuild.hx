package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
class PopinBuild extends MyPopin
{	
	private function new(?startX:Float,?startY:Float) 
	{
		super(startX,startY, "assets/Popins/PopInBackground.png");
		
		addIcon(-0.15,-0.15,'assets/Popins/PopInHeaderConstruction.png',"header",false);
		addIcon(0.65,0.05,'assets/Popins/PopInTitleNiches.png',"category",false);
		addIcon(0.10,0.15,'assets/Popins/PopInScrollBackground.png',"contentBackground",false);
		addIcon(0.125,0.175,'assets/Popins/PopInBuiltBgArticle.png',"articleBase",false);
		addIcon(0.14,0.1875,'assets/Popins/PopInBuiltArticlePreview.png',"ArticlePreview",false);
		addIcon(0.3,0.275,'assets/Popins/PopInBuiltArticleBgRessources.png',"ArticleRessourcesBack",false);
		addIcon(0.305,0.28,'assets/Popins/PopInBuiltArticleSoftRessource.png',"SoftRessource1",false);
		addIcon(0.755,0.28,'assets/Popins/PopInBuiltArticleHardRessource.png',"HardRessource",false);
		addIcon(0.695,0.2875,'assets/Popins/PopInBuiltSoftNormal.png',"ArticleBgRessources",false);
		addIcon(0.82,0.2875,'assets/Popins/PopInBuiltHardNormal.png',"ArticleBgRessources",false);
		addIcon(0.95,0,'assets/Popins/HudInventoryCloseButtonNormal.png',"closeButton");
		addIcon(0.10,0.15,'assets/Popins/PopInScrollOverlay.png',"contentBackground",false);
		//addText(0 , 0 , "Futura_STD" , "35px" , "test" , "testString" );
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			PopinManager.getInstance().closePopin("PopinBuild");
		}
	}
}
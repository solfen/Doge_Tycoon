package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import externs.dat.gui.GUI;
import utils.events.Event;
import hud.HudManager;
import pixi.extras.TilingSprite;
import utils.game.ParticleSystem;
import utils.game.Cursor;
//Popinworkshop is lauched on hangar click
// It's prety huge and I could cut it into three popins but then I would have to choose which one to open in hangard click. And now that I write that I realise that it's not stupid at all so I'll probably do that after I get some sleep.
class PopinWorkshop extends MyPopin 
{	
	private var articleHeight:Float = Texture.fromFrame("PopInQuestBgArticle.png").height;
	private var hasVerticalScrollBar:Bool = false;
	private var workShopModel:Dynamic;
	private var workshopConfig:Dynamic;
	private var particleSystem:ParticleSystem;

	private var gui:GUI;
	private var guiListValuesBuy:Array<String> = ["articleBaseX","articleBaseY","articleInterline","articleNameX","articleNameY","articleBuildX","articleBuildY","articlePreviewX","articlePreviewY","startRessourcesX","stepRessourceX","ressourcesY","startQuantityX","quantityStepX","quantityY"];
	private var articleBaseX:Float = 0.31;
	private var articleBaseY:Float = 0.16;
	private var articleInterline:Float = 0.03;
	private var articleNameX:Float = 0.49;
	private var articleNameY:Float = 0.19;
	private var articleBuildX:Float = 0.838;
	private var articleBuildY:Float = 0.193;
	private var articleNameFontSize:Float = 22;
	private var articlePreviewX:Float = 0.33;
	private var articlePreviewY:Float = 0.18;
	private var startRessourcesX:Float = 0.49;
	private var stepRessourceX:Float = 0.07;
	private var ressourcesY:Float = 0.266;
	private var startQuantityX:Float = 0.5;
	private var quantityStepX:Float = 0.07;
	private var quantityY:Float = 0.31;

	private var guiListValuesBuild:Array<String> = ["backTextX","backTextY","infoTextX","infoTextY","spaceshipBuildImgX","spaceshipBuildImgY","loadbarBackX","loadbarBackY","loadBarFillX","loadBarFillY","loadBarFillMaxWidth","cancelBuildX","cancelBuildY","buildLoadIconX","buildLoadIconY","buildTimeLeftX","buildTimeLeftY"];
	private var backTextX:Float = 0.3;
	private var backTextY:Float = 0.18;
	private var infoTextX:Float = 0.36;
	private var infoTextY:Float = 0.185;
	private var spaceshipBuildImgX:Float = 0.31;
	private var spaceshipBuildImgY:Float = 0.25;
	private var loadbarBackX:Float = 0.26;
	private var loadbarBackY:Float = 0.78;
	private var loadBarFillX:Float = 0.3;
	private var loadBarFillY:Float = 0.809;
	private var loadBarFillMaxWidth:Float = 0.959;
	private var cancelBuildX:Float = 0.81;
	private var cancelBuildY:Float = 0.75;
	private var buildLoadIconX:Float = 0.26;
	private var buildLoadIconY:Float = 0.76;
	private var buildTimeLeftX:Float = 0.45;
	private var buildTimeLeftY:Float = 0.86;
	private var loadingBar:TilingSprite;

	private var guiListValuesLaunch:Array<String> = ["backTextLaunchX","backTextLaunchY","infoTextLaunchX","infoTextLaunchY","spaceshipLaunchImgX","spaceshipLaunchImgY","destroyShipX","destroyShipY","launchShipX","launchShipY","dogPosY","dogPosX"];
	private var backTextLaunchX:Float = 0.29;
	private var backTextLaunchY:Float = 0.17;
	private var infoTextLaunchX:Float = 0.43;
	private var infoTextLaunchY:Float = 0.18;
	private var spaceshipLaunchImgX:Float = 0.3;
	private var spaceshipLaunchImgY:Float = 0.25;
	private var destroyShipX:Float = 0.765;
	private var destroyShipY:Float = 0.7;
	private var launchShipX:Float = 0.12;
	private var launchShipY:Float = 0.7;
	private var dogPosY:Float = 0.02;
	private var dogPosX:Float = -0.7;



	private function new(?startX:Float,?startY:Float,?optParams:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		workshopConfig = optParams['config']; // TODO : obtain ID from param
		workShopModel = GameInfo.workshopsModels[workshopConfig.workshopType];
		headerTextures = [ 
			'atelier'=>Texture.fromFrame('PopInWorkshopHeader.png'),
		];
		articleHeight /= background.height; // background is defiened in MyPopin
		addContainer("verticalScroller",this,0,0);
		addHeader(0.65,0.05,headerTextures['atelier']);
		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addIcon(-0.15,-0.15,'PopInTitleWorkshop.png',"popInTitle",this,false);
		addIcon(-0.4,0.27,'assets/Dogs/DogWorkshop.png',"dog",this,false);
		workshopConfig.state == 'buy' ? addBuyState(): workshopConfig.state == 'build' ? addBuildState() : addLaunchState();

		//debugGUI('build');
	}

	// This is an easy way to add articles in the popin
	// It reads the config in GameInfo and translate it in sprites
	private function addBuyState(){
		addIcon(0.1,0.15,workShopModel.previewImg,"destinationPreview",containers["verticalScroller"],false);
		addIcon(0.1,0.39,'PopInWorkshopBgPlanet.png',"destinationTextBg",containers["verticalScroller"],false);
		addText(0.105,0.41,'FuturaStdHeavy','14px',workShopModel.destination,'description',containers["verticalScroller"],'white');
		for(i in 0...workshopConfig.level){
			var y:Float = i*(articleHeight+articleInterline);
			var article:Dynamic =  GameInfo.rocketsConfig[workShopModel.spaceships[i]];
			var ressources:Array<Dynamic> = article.ressources;
			addIcon(articleBaseX,articleBaseY+y,'PopInWorkshopArticleBG.png',"articleBase"+i,containers["verticalScroller"],false);
			addIcon(articlePreviewX,articlePreviewY+y,article.previewImg,"ArticlePreview"+i,containers["verticalScroller"],false);
			addText(articleNameX,articleNameY+y,'FuturaStdHeavy',articleNameFontSize+'px',article.name,'articleName'+i,containers["verticalScroller"],'black');
			addIcon(articleBuildX,articleBuildY+y,'PopInBuiltSoftNormal.png',"buildSoft"+i,containers["verticalScroller"],true,'PopInBuiltSoftActive.png',true);
			for(j in 0...ressources.length){
				addIcon(startRessourcesX+stepRessourceX*j,ressourcesY+y,GameInfo.ressources[ressources[j].name].iconImg,"ressource"+j, containers["verticalScroller"],false);
				addText(startQuantityX+quantityStepX*j,quantityY+y,'FuturaStdHeavy','13px',ressources[j].quantity,"ressourceQunatity"+j, containers["verticalScroller"],'white');
			}
			removeChild(icons["dog"]);
			addIcon(-0.4,0.27,'assets/Dogs/DogWorkshop.png',"dog",this,false);	
		}
	}

	private function addBuildState() : Void { 
		addIcon(backTextX,backTextY,'PopInWorkshopTextBG.png',"PopInWorkshopTextBG",containers["verticalScroller"],false);
		addText(infoTextX,infoTextY,'FuturaStdHeavy','15px','Accélérez la production en cliquant !','aideText',containers["verticalScroller"],'white');
		addIcon(spaceshipBuildImgX,spaceshipBuildImgY,'PopInWorkshopFuseeNotReady'+workshopConfig.spaceShip+'.png',"buildImage",containers["verticalScroller"],true);
		addIcon(loadbarBackX,loadbarBackY,'PopInWorkshopLoadFillBar.png',"fillBarBack",containers["verticalScroller"],false);
		loadingBar = new TilingSprite(Texture.fromFrame('PopInWorkshopLoadFill1.png'), 0, 15);
		loadingBar.anchor.set(0,0.5);
		loadingBar.position.set(Std.int(loadBarFillX*background.width-background.width/2),Std.int(loadBarFillY*background.height-background.height/2));
		containers["verticalScroller"].addChild(loadingBar);
		addIcon(buildLoadIconX,buildLoadIconY,'PopInWorkshopLoadIcon.png',"buildLoadIcon",containers["verticalScroller"],false);
		addIcon(cancelBuildX,cancelBuildY,'PopInWorkshopCancelButtonNormal.png',"cancelBuild",containers["verticalScroller"],true,'PopInWorkshopCancelButtonActive.png',true);
		removeChild(icons["dog"]);
		addIcon(-0.4,0.27,'assets/Dogs/DogWorkshop.png',"dog",this,false);	
		addText(buildTimeLeftX,buildTimeLeftY,'FuturaStdHeavy','15px','','buildtTimeLeft',containers["verticalScroller"],'white');
		
		particleSystem = new ParticleSystem("PopInWorkshopLoadIcon.png");
		addChild(particleSystem);

		Main.getInstance().addEventListener(Event.GAME_LOOP, refreshBuildBar);
		icons["buildImage"].mouseover = function(data:InteractionData){
			Cursor.getInstance().setCursorToHammer();
		}
		icons["buildImage"].mouseout = function(data:InteractionData){
			Cursor.getInstance().setCursorToDoge();
		}
	}

	private function addLaunchState() : Void {
		addIcon(backTextLaunchX,backTextLaunchY,'PopInWorkshopTextBG.png',"PopInWorkshopTextBG",containers["verticalScroller"],false);
		addText(infoTextLaunchX,infoTextLaunchY,'FuturaStdHeavy','15px','La fussée est prête !','aideText',containers["verticalScroller"],'white');
		addIcon(spaceshipLaunchImgX,spaceshipLaunchImgY,'PopInWorkshopFuseeReady'+workshopConfig.spaceShip+'.png',"destinationTextBg",containers["verticalScroller"],false);
		addIcon(destroyShipX,destroyShipY,'PopInWorkshopDestroyButtonNormal.png',"destroyShip",containers["verticalScroller"],true,'PopInWorkshopDestroyButtonActive.png',true);
		addIcon(launchShipX,launchShipY,'PopInWorkshopLaunchButtonNormal.png',"launchShip",containers["verticalScroller"],true,'PopInWorkshopLaunchButtonActive.png',true);
		removeChild(icons["dog"]);
		addIcon(dogPosX,dogPosY,'assets/Dogs/DogAstro.png',"dog",this,false);		
	}

	// Pass this in gameplay update ?
	private function refreshBuildBar() {
		var timeElapsed:Float = haxe.Timer.stamp() - workshopConfig.buildTimeStart;
		var timeLeft:Float = Std.int(GameInfo.rocketsConfig[workshopConfig.spaceShip].constructionTime - timeElapsed);
		var progressPercent:Float = timeElapsed /  GameInfo.rocketsConfig[workshopConfig.spaceShip].constructionTime;
		loadingBar.width = progressPercent * (loadBarFillMaxWidth*background.width-background.width/2);
		if(progressPercent >= 1){
			removeChild(particleSystem);
			particleSystem.destroy();
			particleSystem = null;
			workshopConfig.state = 'launch';
			Main.getInstance().removeEventListener(Event.GAME_LOOP, refreshBuildBar);
			containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
			Cursor.getInstance().setCursorToDoge();
			addLaunchState();
		}
		texts['buildtTimeLeft'].setText('Temps restant : ' + utils.game.FormatTools.formatSeconds(timeLeft));
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "closeButton"){
			close();
		}
		else if(pEvent.target._name.indexOf("buildSoft") != -1){
			icons[pEvent.target._name].setTextureToNormal();

			var index:Int = Std.parseInt(pEvent.target._name.split('buildSoft')[1]); // deduce the index from the name
			var ressources:Array<Dynamic> = GameInfo.rocketsConfig[workShopModel.spaceships[index]].ressources;
			var canBuy:Bool = true;

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
				HudManager.getInstance().updateChilds();
				PopinManager.getInstance().updatePopin("PopinInventory");
				workshopConfig.buildTimeStart = haxe.Timer.stamp();
				workshopConfig.state = "build";
				workshopConfig.spaceShip = workShopModel.spaceships[index];
				containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
				GameInfo.rockets.rocketsConstructedNb++;
				addBuildState();
			}
		}
		else if(pEvent.target._name == 'buildImage'){
			particleSystem.startParticlesEmission(pEvent.originalEvent.clientX-0.35*Cursor.getInstance().currentCursorImg.width, pEvent.originalEvent.clientY+0.1*Cursor.getInstance().currentCursorImg.height);
			workshopConfig.buildTimeStart -= GameInfo.rocketsConfig[workshopConfig.spaceShip].constructionTime * GameInfo.rocketsConfig[workshopConfig.spaceShip].clickBonus;
		}
		else if(pEvent.target._name == 'cancelBuild'){
			workshopConfig.state = 'buy';
			Main.getInstance().removeEventListener(Event.GAME_LOOP, refreshBuildBar);
			containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
			addBuyState();
		}
		else if(pEvent.target._name == 'launchShip'){
			workshopConfig.state = 'buy';
			GameInfo.rockets.rocketsLaunchedNb++;
			GameInfo.shipToLaunch = workshopConfig.spaceShip;
			GameInfo.rockets.currentRocket = workshopConfig.spaceShip;
			GameInfo.rockets.currentRocketLaunchTime = haxe.Timer.stamp();
			close();
		}
		else if(pEvent.target._name == 'destroyShip'){
			workshopConfig.state = 'buy';
			containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
			addBuyState();
		}
	}
	private function close(){
		GameInfo.can_map_update = true;
		if(gui != null) gui.destroy();
		PopinManager.getInstance().closePopin("PopinWorkshop");
	}
	private function refresh(type:String) {
		containers["verticalScroller"].removeChildren(0,containers["verticalScroller"].children.length);
		type == "buy" ? addBuyState() : type == 'build' ? addBuildState() : addLaunchState();
	}
	private function debugGUI(type:String){
		gui = new GUI();
		//gui.remember(this);
		var listValues:Array<String> = type == "build" ?  guiListValuesBuild : type == 'buy' ? guiListValuesBuy : guiListValuesLaunch;
		for(i in listValues){
			gui.add(this, i,-1,1).step(0.0001).onChange(function(newValue) {
				refresh(type);
			});
		}
	}
	override public function destroy() : Void {
		super.destroy();
		if(particleSystem != null){
			removeChild(particleSystem);
			particleSystem.destroy();
			particleSystem = null;
			Main.getInstance().removeEventListener(Event.GAME_LOOP,refreshBuildBar);
		}
	}
}
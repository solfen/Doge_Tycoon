package popin;
import popin.MyPopin;
import popin.PopinManager;
import pixi.textures.Texture;
import externs.dat.gui.GUI;
import pixi.display.MovieClip;
import pixi.extras.TilingSprite;
import utils.game.ParticleSystem;
import pixi.InteractionData;
//Popinworkshop is lauched on hangar click
// It's prety huge and I could cut it into three popins but then I would have to choose which one to open in hangard click. And now that I write that I realise that it's not stupid at all so I'll probably do that after I get some sleep.
class PopinMusee extends MyPopin 
{	
	private var hasVerticalScrollBar:Bool = false;
	private var clickImage:MovieClip;
	private var clickImageAnimationSpeed:Float = 0.25;
	private var clickImageTexturesNb:Int = 10;
	private var clickImageTextures:Array<Texture> = [];
	private var particleSystem:ParticleSystem;
	private var completionBar:TilingSprite;
	private var completionBarMaxWidth:Float = 0.87;
	private var currentTab:String = "homeTab";
	private var planetsNames:Array<String> = ["SprungField","Mordor","Namok","Terre","Wundërland","StarWat"];
	private var lastPlanetIcon:IconPopin;
	private var currentPlanetIndex:Int = 0;
	private var currentFriendIndex:Int = 0;
	private var artefactToGive:String = '';
	private var isChekingWithServer:Bool = false;

	private var gui:GUI;
	private var guiValuesList:Array<String> = ["clickImageAnimationSpeed","headerX","headerY","backTextX","backTextY","infoTextX","infoTextY","clickImageX","clickImageY","museeInfoX","museeInfoY"];
	private var headerX:Float = 0.47;
	private var headerY:Float = 0.05;
	private var backTextX:Float = 0.3;
	private var backTextY:Float = 0.17;
	private var infoTextX:Float = 0.43;
	private var infoTextY:Float = 0.18;
	private var clickImageX:Float = 0.28;
	private var clickImageY:Float = 0.26;
	private var museeInfoX:Float = 0.41;
	private var museeInfoY:Float = 0.83;
	private var maxParticlesNb:Int = 20;
	private var minParticlesNb:Int = 3;
	private var cheatDogeClick:Float = 1;

	private var guiValuesListArtefacts:Array<String> = ["completionBarMaxWidth","planetTabX","planetTabY","planetTabInterval","articleInterline","friendBackInterline","articleBaseX","articleBaseY","friendBaseX","friendBaseY","actionButtonX","actionButtonY","articleImageX","articleImageY","articleNbX","articleNbY","headerMyAretefactsX","headerMyAretefactsY","headerFriendsAretefactsX","headerFriendsAretefactsY","backFillBarX","backFillBarY","loadbarStartX","loadbarStartY","completionInfoX","completionInfoY","scrollBackroundX","scrollBackroundY","scrollBarX","scrollBarY","scrollIndicOffsetX","scrollIndicOffsetY","artefactTxtX","artefactTxtY"];
	private var articleWidth:Float = Texture.fromFrame("PopInMuseeArticleBg.png").width;
	private var articleInterline:Float = 0.08;
	private var friendBakcWidth:Float = Texture.fromFrame("PopInMuseeFriendBg.png").width;
	private var friendBackInterline:Float = -0.001;
	private var headerMyAretefactsX:Float = 0.58;
	private var headerMyAretefactsY:Float = 0.05;
	private var headerFriendsAretefactsX:Float = 0.38;
	private var headerFriendsAretefactsY:Float = 0.05;
	private var backFillBarX:Float = 0.13;
	private var backFillBarY:Float = 0.15;
	private var loadbarStartX:Float = 0.319;
	private var loadbarStartY:Float = 0.168;
	private var completionInfoX:Float = 0.80;
	private var completionInfoY:Float = 0.16;
	private var scrollBackroundX:Float = 0.11;
	private var scrollBackroundY:Float = 0.56;
	private var scrollBarX:Float = 0.82;
	private var scrollBarY:Float = 0.84;
	private var scrollIndicOffsetX:Float = -0.415;
	private var scrollIndicOffsetY:Float = 0.025;
	private var artefactTxtX:Float = 0.13;
	private var artefactTxtY:Float = 0.5;

	private var articleBaseX:Float = 0.149;
	private var articleBaseY:Float = 0.599;
	private var friendBaseX:Float = 0.09;
	private var friendBaseY:Float = 0.28;
	private var friendImgX:Float = 0.008;
	private var friendImgY:Float = 0.04;
	private var friendTextX:Float = 0.01;
	private var friendTextY:Float = 0.01;
	private var actionButtonX:Float = 0.214;
	private var actionButtonY:Float = 0.8;
	private var articleImageX:Float = 0.158;
	private var articleImageY:Float = 0.61;
	private var articleNbX:Float = 0.171;
	private var articleNbY:Float = 0.815;

	private var planetTabX:Float = 0.93;
	private var planetTabY:Float = 0.13;
	private var planetTabInterval:Float = 0.128;


	private function new(?startX:Float,?startY:Float,?optParams:Map<String,Dynamic>) 
	{
		GameInfo.can_map_update = false;
		super(startX,startY, "PopInBackground.png");
		articleWidth /= background.height; // background is defiened in MyPopin
		friendBakcWidth /= background.height; // background is defiened in MyPopin
		addBasePopin();
		changeTab();
		//debugGUI();
	}

	private function addBasePopin() : Void {
		headerTextures = [ 
			'homeTab'=>Texture.fromFrame('PopInHeaderAccueilMusee.png'),
			'myArtefactsTab'=>Texture.fromFrame('PopInHeaderMonMusee.png'),
			'amisArtefactsTab'=>Texture.fromFrame('PopInHeaderMuseeAmis.png'),
		];
		addHeader(headerX,headerY,headerTextures[currentTab]);
		addContainer('main', this);
		addIcon(-0.02,0.17,'PopInOngletHomeNormal.png',"homeTab",this,true,'PopInOngletHomeActive.png',true);
		addIcon(-0.02,0.29,'PopInOngletArtefactNormal.png',"myArtefactsTab",this,true,'PopInOngletArtefactActive.png',true);
		addIcon(-0.02,0.41,'PopInOngletArtefactAmisNormal.png',"amisArtefactsTab",this,true,'PopInOngletArtefactAmisActive.png',true);

		addIcon(0.95, 0,'closeButtonNormal.png',"closeButton",this,true,'closeButtonActive.png',true);
		addIcon(-0.15,-0.15,'PopInMuseeTitle.png',"popInTitle",this,false);
		addIcon(-0.55,0.5,'assets/Dogs/DogMusee.png',"dog",this,false);
	}

	private function addHomeTab() : Void {
		header.position.set(Std.int(headerX*background.width-background.width/2),Std.int(headerY*background.height-background.height/2));
		addIcon(backTextX,backTextY,'PopInMuseeTextBG.png',"PopInMuseeTextBG",containers['main'],false);
		addText(infoTextX,infoTextY,'FuturaStdHeavy','15px','Une visite par clic !','aideText',containers['main'],'white');
		addText(museeInfoX,museeInfoY,'FuturaStdHeavy','16px','','museeInfo',containers['main'],'white');

		for(i in 0...clickImageTexturesNb){
			clickImageTextures.push(Texture.fromFrame("PopinMuseeClick_"+i+".png"));
		}
		clickImage = new MovieClip(clickImageTextures);
		clickImage.position.set(Std.int(clickImageX*background.width-background.width/2),Std.int(clickImageY*background.height-background.height/2));
		clickImage.animationSpeed = clickImageAnimationSpeed;
		clickImage.play();
		clickImage.interactive = true;
		clickImage.mousedown = visit;
		containers['main'].addChild(clickImage);

		particleSystem = new ParticleSystem("PopInMuseeParticule.png");
		addChild(particleSystem);
		
		update();
	}
	private function addMyArtefactsTab() : Void {
		addContainer('verticalScroller', this);
		header.position.set(Std.int(headerMyAretefactsX*background.width-background.width/2),Std.int(headerMyAretefactsY*background.height-background.height/2));
		addIcon(backFillBarX,backFillBarY,'PopInMuseeCompletionFillBar.png',"completionFillBar",containers['main'],false);

		addIcon(loadbarStartX,loadbarStartY,'PopInMuseeCompletionFill1.png',"fillLeft",containers['main'],false);
		completionBar = new TilingSprite(Texture.fromFrame('PopInMuseeCompletionFill2.png'), 1, icons["fillLeft"].height);
		completionBar.anchor.set(0,0);
		completionBar.position.set(icons["fillLeft"].position.x+icons["fillLeft"].width,icons["fillLeft"].position.y);
		containers['main'].addChild(completionBar);
		addIcon(0,loadbarStartY,'PopInMuseeCompletionFill3.png',"fillRight",containers['main'],false);
		icons['fillRight'].position.x = completionBar.position.x+completionBar.width;
		addText(completionInfoX,completionInfoY,'FuturaStdHeavy','15px','','completionInfo',containers['main'],'white');

		for(i in 0...6){
			addIcon(planetTabX,planetTabY+i*planetTabInterval,'PopInMuseeBoutonNormal_'+i+'.png',"planetTab"+i,containers['main'],true,'PopInMuseeBoutonActive_'+i+'.png',true);
		}

		addText(artefactTxtX,artefactTxtY,'FuturaStdHeavy','25px',"ARTEFACTS :",'ressourceTxt',containers["main"]);
		addIcon(scrollBackroundX,scrollBackroundY,'PopInMuseeScrollBackground.png',"contentBackground",containers['main'],false);
		//addMask(icons["contentBackground"].x+3, icons["contentBackground"].y, icons["contentBackground"].width-6, icons["contentBackground"].height,containers["verticalScroller"]);
		addIcon(icons["contentBackground"].x,icons["contentBackground"].y,'PopInScrollOverlay.png',"scrollOverlay",containers['main'],false);
		icons["planetTab0"].setTextureToActive();
		lastPlanetIcon = icons["planetTab0"];
		addArtefactPlanet(GameInfo.artefacts[planetsNames[0]]);
	}
	private function addAmisArtefactsTab() : Void {
		getFriendArtefacts();
		addMyArtefactsTab();
		header.position.set(Std.int(headerFriendsAretefactsX*background.width-background.width/2),Std.int(headerFriendsAretefactsY*background.height-background.height/2));
		
		for(i in 0...GameInfo.friendsList.length) {
			var friend = GameInfo.friendsList[i];
			var x:Float = i*(friendBakcWidth+friendBackInterline);
			addIcon(friendBaseX+x,friendBaseY,'PopInMuseeFriendBg.png',"friend"+i,containers['verticalScroller'],true,'PopInMuseeFriendBgActive.png',true);
			addText(friendBaseX+x+friendTextX,friendBaseY+friendTextY,'FuturaStdHeavy','13px',friend.name,'friendName',containers["verticalScroller"],'black');
			addIcon(friendBaseX+x+friendImgX,friendBaseY+friendImgY, friend.img,"friendImg",containers['verticalScroller'],false);
			addIcon(friendBaseX+x+friendImgX,friendBaseY+friendImgY, "PopInMuseelPhotoBorders.png","friendImg",containers['verticalScroller'],false);
		}

		icons["friend0"].setTextureToActive();

	}
	private function addArtefactPlanet(itemsConfig:Map<String,Dynamic>){
		var cpt:Int = 0;
		var itemOwnedNb:Int = 0;
		var actionButton:String = currentTab == "amisArtefactsTab" ?  'PopInMuseeBoutonDemander' : 'PopInMuseeBoutonDonner';
		var actionName:String = currentTab == "amisArtefactsTab" ?  'actionAsk' : 'actionGive';
		if(hasVerticalScrollBar){
			removeVerticalScrollBar();
			hasVerticalScrollBar = false;
		}
		for(i in itemsConfig.keys()){
			var possesionNb:Int = currentTab == "amisArtefactsTab" ? itemsConfig[i].currentFriendPossesion : itemsConfig[i].userPossesion;
			var x:Float = cpt*(articleWidth+articleInterline);

			addIcon(articleBaseX+x,articleBaseY,'PopInMuseeArticleBg.png',"articleBase",containers["verticalScroller"],false);
			addIcon(articleImageX+x,articleImageY,itemsConfig[i].img,"articleImage",containers["verticalScroller"],false);
			addText(articleNbX+x,articleNbY,'FuturaStdHeavy','15px','x'+possesionNb,'articleNb',containers["verticalScroller"],'white');
			if(Std.parseInt(possesionNb+'') > 0){
				itemOwnedNb++;
			}
			if(Std.parseInt(possesionNb+'') > 1 ){
				addIcon(actionButtonX+x,actionButtonY, actionButton+'Normal.png',actionName+i,containers["verticalScroller"],true, actionButton+'Active.png',true);
			}
			if( (cpt*(articleWidth+articleInterline)+articleWidth)*background.width > icons["contentBackground"].width && !hasVerticalScrollBar){
				addScrollBar(false,scrollBarX,scrollBarY,scrollIndicOffsetX,scrollIndicOffsetY,containers["main"]);
				hasVerticalScrollBar = true;
			}
			cpt++;
		}
		completionBar.width = itemOwnedNb/cpt* (completionBarMaxWidth*(background.width-background.width/2));
		icons['fillRight'].position.x = completionBar.position.x+completionBar.width;
		var percent:String = Std.string(itemOwnedNb/cpt *100);
		percent  = percent.indexOf('.') != -1 ? percent.substr(0, percent.indexOf('.')+2) : percent;
		texts['completionInfo'].setText(percent + "%");
	}

	private function visit(pEvent:Dynamic) : Void {
		GameInfo.museumClicks++;
		GameInfo.ressources['fric'].userPossesion += GameInfo.musseVisiteGain;
		hud.HudManager.getInstance().updateChilds();
		particleSystem.setParticlesNb(Std.int(Math.min(GameInfo.musseVisiteGain*minParticlesNb,maxParticlesNb)));
		particleSystem.startParticlesEmission(pEvent.originalEvent.clientX,pEvent.originalEvent.clientY);
		update();
	}

	private function changeTab() : Void {
		//GameInfo.musseVisiteGain = cheatDogeClick;
		containers['main'].children = [];
		containers.exists('verticalScroller') ? containers['verticalScroller'].children = [] : null;
		currentTab == 'homeTab' ? icons['homeTab'].setTextureToActive() : icons['homeTab'].setTextureToNormal();
		currentTab == 'myArtefactsTab' ? icons['myArtefactsTab'].setTextureToActive() : icons['myArtefactsTab'].setTextureToNormal();
		currentTab == 'amisArtefactsTab' ? icons['amisArtefactsTab'].setTextureToActive() : icons['amisArtefactsTab'].setTextureToNormal();
		header.setTexture(headerTextures[currentTab]);
		currentTab == 'homeTab' ? addHomeTab() : currentTab == 'myArtefactsTab' ? addMyArtefactsTab() : addAmisArtefactsTab();
	}
	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic) : Void {
		if(pEvent.target._name == "closeButton"){
			GameInfo.can_map_update = true;
			if(gui != null) gui.destroy();
			PopinManager.getInstance().closePopin("PopinMusee");
		}
		else if(pEvent.target._name == "homeTab" && currentTab != "homeTab"){
			currentTab = "homeTab";
			changeTab();
		}
		else if(pEvent.target._name == "myArtefactsTab" && currentTab != "myArtefactsTab"){
			currentTab = "myArtefactsTab";
			changeTab();
		}
		else if(pEvent.target._name == "amisArtefactsTab" && currentTab != "amisArtefactsTab"){
			currentTab = "amisArtefactsTab";
			changeTab();
		}
		else if(pEvent.target._name.indexOf("planetTab") != -1){
			currentPlanetIndex = Std.parseInt(pEvent.target._name.split('planetTab')[1]);
			lastPlanetIcon != null ? lastPlanetIcon.setTextureToNormal() : null;
			lastPlanetIcon = pEvent.target;
			addArtefactPlanet(GameInfo.artefacts[planetsNames[currentPlanetIndex]]);
		}			
		else if(pEvent.target._name.indexOf("friend") != -1){
			icons["friend"+currentFriendIndex].setTextureToNormal();
			currentFriendIndex = Std.parseInt(pEvent.target._name.split('friend')[1]);
			getFriendArtefacts();
		}		
		else if(pEvent.target._name.indexOf("actionGive") != -1){
			pEvent.target.setTextureToNormal();
			artefactToGive = pEvent.target._name.split('actionGive')[1];

			utils.server.MyFbHelper.getInstance().artefactRequest('SEND', artefactToGive, finishFbSendArtefact);
		}		
		else if(pEvent.target._name.indexOf("actionAsk") != -1){
			pEvent.target.setTextureToNormal();
			artefactToGive = pEvent.target._name.split('actionAsk')[1];

			utils.server.MyFbHelper.getInstance().artefactRequest('ASKFOR', artefactToGive, function(){}, GameInfo.artefacts[planetsNames[currentPlanetIndex]][artefactToGive].name);
		}
	}

	override private function childUpOutside(pEvent:Dynamic) : Void {
		if(pEvent.target._name == "closeButton"){
			icons["closeButton"].setTextureToNormal();
		}
		else if(pEvent.target._name.indexOf("planetTab") != -1){
			pEvent.target.setTextureToNormal();
		}
	}
	private function getFriendArtefacts(){
		isChekingWithServer = true;
		var artefactsID:Array<String> = [];
		for(i in GameInfo.artefacts[planetsNames[currentPlanetIndex]].keys()) {
			artefactsID.push(i);
		}
		var params:Map<String,String> = [
			"event_name"  => 'get_friend_artefacts',
			"artefactsID" => haxe.Json.stringify(artefactsID),
			"friendID" => GameInfo.friendsList[currentFriendIndex].id,

		];
		utils.server.MyAjax.call("data.php", params, finishGetFriendsArtefacts);		
	}
	private function finishGetFriendsArtefacts(data:String) {
		isChekingWithServer = false;
		var artefacts:Dynamic = haxe.Json.parse(data);
		for(i in GameInfo.artefacts[planetsNames[currentPlanetIndex]].keys()) {
			var index:Int = Std.parseInt(i);
			GameInfo.artefacts[planetsNames[currentPlanetIndex]][i].currentFriendPossesion =  artefacts[index] != null ? artefacts[index] : 0;
		}
		if(currentTab == "amisArtefactsTab") {
			addArtefactPlanet(GameInfo.artefacts[planetsNames[currentPlanetIndex]]);
		}
	}
	private function finishFbSendArtefact(data:Dynamic) {
		if(data.to != null){
			var params:Map<String,String> = [
				"event_name"  => 'give_artefact',
				"friendID" => data.to[0],
				"artefactFbID" => artefactToGive,
			];
			utils.server.MyAjax.call("data.php", params, finishGiveArtefact);
		}
	}
	private function finishGiveArtefact(data:String) {
		GameInfo.artefacts[planetsNames[currentPlanetIndex]][artefactToGive].userPossesion = Std.parseInt(GameInfo.artefacts[planetsNames[currentPlanetIndex]][artefactToGive].userPossesion)-1;
	}
	private function debugGUI() : Void {
		gui = new GUI();
		//gui.remember(this);
		for(i in guiValuesListArtefacts){
			gui.add(this, i,-1,1).onChange(function(newValue) {
				changeTab();
			});			
		}
		gui.add(this, "maxParticlesNb",0,100).onChange(function(newValue) {
			changeTab();
		});			
		gui.add(this, "minParticlesNb",0,100).onChange(function(newValue) {
			changeTab();
		});			
		gui.add(this, "cheatDogeClick",0,100).onChange(function(newValue) {
			changeTab();
		});
	}

	override public function destroy() : Void {
		super.destroy();
		if(particleSystem != null){
			removeChild(particleSystem);
			particleSystem.destroy();
			particleSystem = null;
		}
	}
}
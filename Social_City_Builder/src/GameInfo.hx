package;

// class that store informations of the game in statics var so that it can be acces anywhere
// the player stats will most likely be here
class GameInfo
{
	public static var preloadAssets:Array<String> = [
		"assets/preload.png",
		"assets/preload_bg.png",
		"assets/LoaderScene.png",
	];
 	public static var loadAsstes:Array<String> = [
	 	"assets/TitleCard.png",
	 	"assets/HudBuild.png",
	 	"assets/Screen0.png",
	 	"assets/Screen1.png",
	 	"assets/Popin0.png",
	 	"assets/Popin1.png",
	 	"assets/PopinOkCancel.png",
	 	"assets/alpha_bg.png",
	 	"assets/black_bg.png",
	 	"assets/game.png",
	 	"assets/Hud_TL.png",
	 	"assets/Hud_TR.png",
	 	"assets/Hud_B.png",
	 	"assets/closeButton.png",
	 	"assets/ambulance.json"
 	];
 	public static var userWidth=1920;
 	public static var userHeight=1000;
}
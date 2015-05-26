package;

import popin.PopinManager;
import utils.events.Event;
import buildings.Building;
//Script that's in charge of updating the gameplay it's instanciated in GameScene
// It's like a cron but client side
// It also calls the server to prevent cheat
// It's not complete at all
class GameUpdate
{
	

	private static var instance: GameUpdate;
	private var mainInstance: Main;
	
	public static function getInstance (): GameUpdate {
		if (instance == null) instance = new GameUpdate();
		return instance;
	}
	
	private function new() {
		mainInstance = Main.getInstance();	
		Main.getInstance().addEventListener(Event.GAME_LOOP, update); 
	}
	
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 	it's possible that the code here will be placed in functions or in other classes but they'll still be called from here
	 */
	public function update (): Void {
		if(GameInfo.buildingsGameplay[Building.EGLISE | Building.LVL_1].userPossesion > 0 
		|| GameInfo.buildingsGameplay[Building.EGLISE | Building.LVL_2].userPossesion > 0
		|| GameInfo.buildingsGameplay[Building.EGLISE | Building.LVL_3].userPossesion > 0) {
			GameInfo.faithPercent = Math.max(GameInfo.faithPercent - GameInfo.faithLossSpeed * mainInstance.delta_time,0);
			PopinManager.getInstance().updatePopin("PopinChurch");
		}
		if(GameInfo.buildingsGameplay[Building.MUSEE | Building.LVL_1].userPossesion > 0 
		|| GameInfo.buildingsGameplay[Building.MUSEE | Building.LVL_2].userPossesion > 0
		|| GameInfo.buildingsGameplay[Building.MUSEE | Building.LVL_3].userPossesion > 0) {
			GameInfo.ressources['fric'].userPossesion += GameInfo.museeSoftSpeed * mainInstance.delta_time;
		}

		var doges:Float =   GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].userPossesion * GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].dogesPerSecond
						  + GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_2].userPossesion * GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].dogesPerSecond
						  + GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_3].userPossesion * GameInfo.buildingsGameplay[Building.NICHE | Building.LVL_1].dogesPerSecond;
		GameInfo.ressources['doges'].userPossesion = Math.min(GameInfo.ressources['doges'].userPossesion + doges * mainInstance.delta_time,GameInfo.dogeMaxNumber);


		// TO BE PUT IN QUEST UPDATE ?
		for( i in 0...GameInfo.questsArticles["current"].length){
			var quest:Dynamic = GameInfo.questsArticles["current"][i];
			var questAcomplished:Bool = false;
			if(quest.condition.building && GameInfo.buildingsGameplay[quest.condition.building].userPossesion >= quest.condition.numberToHave){
				questAcomplished = true;
			}
			else if(quest.condition.rocketsConstructedNb && GameInfo.rockets.rocketsConstructedNb >= quest.condition.rocketsConstructedNb){
				questAcomplished = true;
			}
			else if(quest.condition.rocketsLaunchedNb && GameInfo.rockets.rocketsLaunchedNb >= quest.condition.rocketsLaunchedNb){
				questAcomplished = true;
			}
			if(questAcomplished){
				var rewards:Array<Dynamic> = quest.rewards; 
				for(j in rewards){
					GameInfo.ressources[j.name].userPossesion += Std.int(j.quantity);
				}		
				hud.HudManager.getInstance().updateChilds();
				PopinManager.getInstance().updatePopin("PopinInventory");

				var data:Map<String,Dynamic> = ['quest' => quest];
				PopinManager.getInstance().addPopinToQueue("PopinQuestFinished",0.5,0.5, data);

				GameInfo.questsArticles["finished"].push(quest);
				GameInfo.questsArticles["current"].remove(quest);

				break;
			}
		}

		if(GameInfo.rockets.currentRocket != null && haxe.Timer.stamp() >= GameInfo.rockets.currentRocketLaunchTime + GameInfo.rocketsConfig[GameInfo.rockets.currentRocket].timeToDestination) {
			var data:Map<String,Dynamic> = ['destination' => GameInfo.rocketsConfig[GameInfo.rockets.currentRocket].destination];
			GameInfo.rockets.currentRocket = null;
			PopinManager.getInstance().addPopinToQueue("PopinSpaceShipReturn",0.5,0.5, data);
		}

	}
	
	public function destroy (): Void {
		Main.getInstance().removeEventListener(Event.GAME_LOOP,update);
		instance = null;
	}

}
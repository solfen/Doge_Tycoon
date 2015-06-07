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
	private var ftue1 : Bool = false;
	private var ftue2 : Bool = false;
	private var is_checking_with_server : Bool = false;
	private var ftueParam : Map<String,Dynamic>;
	private var quest:Dynamic;
	private var lastServerCheck:Float = 0;
	private var serverCheckInterval:Float = 60;
	
	public static function getInstance (): GameUpdate {
		if (instance == null) instance = new GameUpdate();
		return instance;
	}
	
	private function new() {
		trace(Building.CASINO | Building.LVL_1);
		mainInstance = Main.getInstance();	
		Main.getInstance().addEventListener(Event.GAME_LOOP, update); 
	}
	
	private function finishRocket(data:String) {
		is_checking_with_server = false;
		if(data.charAt(0) == "{"){
			var data:Dynamic = haxe.Json.parse(data);
			if(data.durationLeft) {
				GameInfo.rockets.currentRocketLaunchTime = Std.int(data.durationLeft) + haxe.Timer.stamp() - GameInfo.rocketsConfig[GameInfo.rockets.currentRocket].timeToDestination;
			}
			else {
				var data:Map<String,Dynamic> = ['destination' => GameInfo.rocketsConfig[GameInfo.rockets.currentRocket].destination];
				GameInfo.rockets.currentRocket = null;
				PopinManager.getInstance().addPopinToQueue("PopinSpaceShipReturn",0.5,0.5, data);
			}
		}
	}
	private function finishQuest(data:String) {
		is_checking_with_server = false;
		if(data.charAt(0) == "{") {
			var data:Dynamic = haxe.Json.parse(data);

			if(data.nbBuilding != null){
				GameInfo.buildingsGameplay[quest.condition.building].userPossesion = data.nbBuilding;
				quest.condition.numberToHave = data.nbToBuild;
			}
			else if(data.rocketBuilded != null){
				GameInfo.rockets.rocketsConstructedNb = data.rocketBuilded;
				quest.condition.rocketsConstructedNb = data.rocketToBuild;
			}
			else {
				GameInfo.rockets.rocketsLaunchedNb = data.rocketsLaunched;
				quest.condition.rocketsLaunchedNb = data.rocketsLaunchedNb;
				
			}
		}
		else if(data == "1"){
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
		}
		else if(data == "0=Quest already finished") {
			GameInfo.questsArticles["finished"].push(quest);
			GameInfo.questsArticles["current"].remove(quest);
		}
	}
	private function finishUpdateRessources(data:String) {
		if(data.charAt(0) != "0"){
			var data:Dynamic = haxe.Json.parse(data);
			GameInfo.ressources["fric"].userPossesion = data.softCurrency;
			GameInfo.ressources["hardMoney"].userPossesion = data.hardCurrency;
			GameInfo.ressources["doges"].userPossesion = data.population;
			GameInfo.faithPercent = data.faithPercent;
			GameInfo.dogeMaxNumber = data.populationMax;

			//canot do for because canot acces data with [] so data["ressource_"+i] is not possible >_<
			GameInfo.ressources["poudre0"].userPossesion = data.ressource_1;
			GameInfo.ressources["poudre1"].userPossesion = data.ressource_2;
			GameInfo.ressources["poudre2"].userPossesion = data.ressource_3;
			GameInfo.ressources["poudre3"].userPossesion = data.ressource_4;
			GameInfo.ressources["poudre4"].userPossesion = data.ressource_5;
			GameInfo.ressources["poudre5"].userPossesion = data.ressource_6;

			PopinManager.getInstance().updatePopin("PopinInventory");
		}
		else {
			trace("eror");
		}
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

		if(haxe.Timer.stamp() >= lastServerCheck + serverCheckInterval) {
			lastServerCheck = haxe.Timer.stamp();
			var params:Map<String,String> = [
				"facebookID"  => GameInfo.facebookID,
				"event_name"  => 'update_ressources',
				"churchClicks" => GameInfo.churchClicks+'',
				"museumClicks" => GameInfo.museumClicks+'',
			];
			utils.server.MyAjax.call("data.php", params, finishUpdateRessources);

			GameInfo.churchClicks = 0;
			GameInfo.museumClicks = 0;
		}

		// TO BE PUT IN QUEST UPDATE ?
		for( i in 0...GameInfo.questsArticles["current"].length){
			quest = GameInfo.questsArticles["current"][i];
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
				if(!is_checking_with_server)  {
					is_checking_with_server = true;
					var params:Map<String,String> = [
						"facebookID"  => GameInfo.facebookID,
						"event_name"  => 'check_quest_completion',
						"questID" => quest.bdd_id,
					];
					utils.server.MyAjax.call("data.php", params, finishQuest);
				}
				break;
			}
		}

		if(!is_checking_with_server && GameInfo.rockets.currentRocket != null && haxe.Timer.stamp() >= GameInfo.rockets.currentRocketLaunchTime + GameInfo.rocketsConfig[GameInfo.rockets.currentRocket].timeToDestination) {
			is_checking_with_server = true;
			var params:Map<String,String> = [
				"facebookID"  => GameInfo.facebookID,
				"event_name"  => 'check_rocket_travel_end',
				"rocket_builded_id" => GameInfo.rockets.currentRocketID,
			];
			utils.server.MyAjax.call("data.php", params, finishRocket);
		}

		if(!ftue1){
			ftueParam = ['ftueIndex' => 0];
			PopinManager.getInstance().openPopin("PopinFTUE",0.5,0.5,ftueParam);
			ftue1 = true;
		}
		else if(!ftue2 && GameInfo.buildingsGameplay[Building.PAS_DE_TIR | Building.LVL_1].userPossesion > 0){
			ftueParam = ['ftueIndex' => 1];
			PopinManager.getInstance().openPopin("PopinFTUE",0.5,0.5,ftueParam);
			ftue2 = true;
		}

	}
	
	public function destroy (): Void {
		Main.getInstance().removeEventListener(Event.GAME_LOOP,update);
		instance = null;
	}

}
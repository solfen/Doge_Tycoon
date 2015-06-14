package utils.game;

import buildings.Building;
//Loads the config from the server
class LoadConfig {
	
	private static function finishLoadBuildings(data:String) {
		GameInfo.buildingsToLoad = 0;
		var buildings:Array<Dynamic> = haxe.Json.parse(data);

		for(building in buildings){
			if(building.buildingEnd != "0000-00-00 00:00:00") {
				var cell:Int = utils.game.IsoTools.cell_index_from_cr(building.col/10, building.row/10, IsoMap.singleton.cols_nb); // /10 because saved in server in *10 to avoid using floats
				var type:Int = Building.get_building_type(building.buildingID);
				var level:Int = Building.get_building_lvl(building.buildingID);
				var time:Float = Date.fromString(building.buildingEnd).getTime()/1000;
				IsoMap.singleton.build_building(type, building.ID, cell, level, time, true);
				GameInfo.buildingsToLoad++;
			}
			else {
				GameInfo.building_2_build = Building.get_building_type(building.buildingID);
				GameInfo.building_2_build_bdd_id = building.ID;
			}
		}

		var params:Map<String,String> = [
			"event_name"  => 'get_all_rockets',
		];
		utils.server.MyAjax.call("data.php", params, finishLoadRockets);
	}
	private static function finishLoadArtefacts(data:String) {
		var artefacts:Dynamic = haxe.Json.parse(data);
		for(planet in GameInfo.artefacts){
			for(i in planet.keys()) {
				var index:Int = Std.parseInt(i);
				if(artefacts[index] != null){
					planet[i].userPossesion = artefacts[index];
				}
				else {
					planet[i].userPossesion = 0;
				}
			}
		}
	}
	private static function finishLoadRockets(data:String){
		var rockets:Array<Dynamic> = haxe.Json.parse(data);
		
		for(rocket in rockets) {
			var lvl:Int = Building.get_building_lvl(rocket.buildingType);
			GameInfo.workshopConfigs[rocket.buildingID] = {
				workshopType: Building.get_building_type(rocket.buildingType),
				level: lvl == Building.LVL_3 ? 3 : lvl == Building.LVL_2 ? 2 : 1,
				state: rocket.isBuilded == "1" ? 'launch' : 'build',
				spaceShip: rocket.ref,
				spaceShipID: rocket.ID,
				clickNb: rocket.clicksNb,
				buildTimeStart: Date.fromString(rocket.buildingEnd).getTime()/1000 - rocket.constructionDuration
			}
		}
	}

	public static function load() {
		var params:Map<String,String> = [
			"event_name"  => 'get_my_artefacts',
		];
		utils.server.MyAjax.call("data.php", params, finishLoadArtefacts);		
		
		var params:Map<String,String> = [
			"event_name"  => 'get_all_buildings',
		];
		utils.server.MyAjax.call("data.php", params, finishLoadBuildings);		
	}
}
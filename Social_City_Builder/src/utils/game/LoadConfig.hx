package utils.game;

//Loads the config from the server
class LoadConfig {
	
	private static function finishLoadBuildings(data:String) {
		var buildings:Array<Dynamic> = haxe.Json.parse(data);
		untyped console.log(buildings);
		for(building in buildings){
			//create buildings
		}
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
		untyped console.log(GameInfo.artefacts);
	}

	public static function load() {
		var params:Map<String,String> = [
			"facebookID"  => GameInfo.facebookID,
			"event_name"  => 'get_my_artefacts',
		];
		utils.server.MyAjax.call("data.php", params, finishLoadArtefacts);
	}
}
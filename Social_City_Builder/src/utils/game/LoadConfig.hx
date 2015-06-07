package utils.game;

class LoadConfig {
	
	private static function finishLoadBuildings(data:String) {
		var buildings:Array<Dynamic> = haxe.Json.parse(data);
		untyped console.log(buildings);
		for(building in buildings){
			//create buildings
		}
	}

	public static function load() {
		var params:Map<String,String> = [
			"facebookID"  => GameInfo.facebookID,
			"event_name"  => 'get_all_buildings',
		];
		utils.server.MyAjax.call("data.php", params, finishLoadBuildings);
	}
}
package utils.server;

import js.Browser;
//this class is used to make ajax calls
class MyAjax 
{
	public static function call(url:String, ?params:Map<String,String>, callback:Dynamic){
		var r = new haxe.Http("../php/api/" + url);
		r.async = true;
		r.onError = onEror;

		if(params != null){
			for(i in params.keys()){
				r.setParameter(i, params[i]);
			}
		}
		r.onData = callback;
		r.request(true);
	}

	public static function onEror(response:String) {
		if(response.indexOf("401") != -1 && !Main.isLocal) {
			Browser.window.alert("Vous êtes déconecté, vous allez être redirrigé vers l'acceuil");
			Browser.window.location.href = "../php/index.php";
		}
		else if(response.indexOf("406") != -1) {
			trace("No event name !");
		}
	}

	/* ex :

		var params:Map<String,String> = [
			"param1"=> value,
			"param2"=> value2,
		];
		utils.server.MyAjax.call("data.php", params, function(r){trace(r);} );

	*/

}
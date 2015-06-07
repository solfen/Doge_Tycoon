package utils.server;

//this class is used to make ajax calls
class MyAjax 
{
	public static function call(url:String, ?params:Map<String,String>, callback:Dynamic){
		var r = new haxe.Http("../php/api/" + url);
		r.async = true;
		r.onError = function (r) { trace(r); };

		if(params != null){
			for(i in params.keys()){
				r.setParameter(i, params[i]);
			}
		}
		r.onData = callback;
		r.request(true);
	}
	/* ex :

		var params:Map<String,String> = [
			"facebookID"=>GameInfo.facebookID,
			"event_name"=>'get_all_buildings',
		];
		utils.server.MyAjax.call("data.php", params, function(r){trace(r);} );

	*/

}
package utils.server;

import externs.FB;
// This class is going to have all method to comunicate with the FB API
//The methods will be static and permit an easy acces to FB API anywhere in code
// Right now the code is just some test with the FB API
// each function will need to do a FB functionality like share or invite friends
class MyFbHelper 
{
	private static var instance: MyFbHelper;

	public static function getInstance (?calback:Dynamic): MyFbHelper {
		if (instance == null) instance = new MyFbHelper(calback);
		return instance;
	}
	private function new (callback:Dynamic) {
		FB.getLoginStatus(callback);
	}

	public function shareGame () {
		FB.ui({method: 'apprequests',
		  message: 'Hé viens jouer à ce super jeu. Jeu 100% sans panda roux albinos !'
		}, emptyfunction);
	}	

	public function getFriendsList (callback:Dynamic) {
		FB.api("me/friends?fields=id,first_name,picture.width(63).height(64)", "GET", null, callback);
	}

	public function artefactRequest(pAction_type:String, artefactID:String, callback:Dynamic, ?objectName:String){
		var msg:String = objectName != null ? objectName : 'artefact';
		FB.ui({method: 'apprequests',
			message: 'Please give me this awesome ' + msg + ' !',
			action_type: pAction_type,
			max_recipients: '1',
			object_id: artefactID,
		}, callback);
	} 
	public function findArtefact(){
		FB.ui({
		  method: 'share_open_graph',
		  action_type: 'space_dogs_tycoon:find',
		  action_properties: haxe.Json.stringify({
		      'artefact':'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/FbObjects/boot.html'
		  })
		}, emptyfunction);
	}
	private function emptyfunction() {}
}
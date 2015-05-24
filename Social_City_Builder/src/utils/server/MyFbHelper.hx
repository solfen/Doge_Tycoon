package utils.server;


// This class is going to have all method to comunicate with the FB API
//The methods will be static and permit an easy acces to FB API anywhere in code
// Right now the code is just some test with the FB API
// each function will need to do a FB functionality like share or invite friends
class MyFbHelper 
{
	private static var instance: MyFbHelper;

	public static function getInstance (): MyFbHelper {
		if (instance == null) instance = new MyFbHelper();
		return instance;
	}

	private function new () {

	}

	private function onFacebookConnect(pResponse:Dynamic){
		trace(pResponse.status);
		if(pResponse.status == 'connected'){
			trace("awww yeah ! you're in ! Motherfucka !!");
			/*FB.api(
			  'me/space_dogs_tycoon:find',
			  'post',
			  {
			    artefact: "http://samples.ogp.me/884406454948358",
			    //fb:'explicitly_shared',
			  },
			  function(response) {
			  	trace(response);
			  }
			);*/
			/*FB.ui({method: 'apprequests',
			  message: 'Hé viens jouer à ce super jeu. Jeu 100% sans panda roux alibnos !'
			}, function(response){
			    trace(response);
			});*/
			/*FB.api(
			  'me/objects/space_dogs_tycoon:artefact',
			  'post',
			  {
			    'og:url': 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/php/fbObjects/boot.html',
			    'og:title': 'Awesome boot',
			    'og:type': 'space_dogs_tycoon:artefact',
			    'og:image': 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/bin/assets/UI/Icons/Artefacts/IconArtefactsTerre2.png',
			    'og:description': 'My boot is so awesome that it can cure cancer',
			    'fb:app_id': 855211017867902
			  },
			  function(response) {
			    trace(response);
			  }
			);*/
			FB.ui({method: 'apprequests',
				message: 'Hey noob ! you are up to this',
				action_type:'send',
				object_id: "706093629496403",
			}, function(response){
			    trace(response);
			});
			/*FB.ui({
			  method: 'share_open_graph',
			  action_type: 'space_dogs_tycoon:find',
			  action_properties: haxe.Json.stringify({
			      'artefact':'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/php/fbObjects/boot.html',
			  })
			}, function(response){});*/
		}
		else if(pResponse.status == 'not_authorized'){
			trace("Oh no ! you're not identified");
			FB.login(function(response){
				FB.getLoginStatus(onFacebookConnect);
			}, {scope: 'publish_actions,email'});
		}
	}
	private function test(){
		trace("succes");
	}
}
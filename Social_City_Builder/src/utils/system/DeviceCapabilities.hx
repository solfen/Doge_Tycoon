package utils.system;

import js.Browser;
	
/**
 * Classe Utilitaire donnant accès à des propriétés du périphérique cible
 * Tous les périphériques ne se comportant pas comme on l'attend, DeviceCapabilities permet de
 * masquer les comportement différents et présenter une facade unique au reste du code
 * @version 0.1.0
 * @author Mathieu ANTHOINE
 */
class DeviceCapabilities 
{		
	/**
	  * hauteur du Canvas (change avec l'orientation)
	  */
	public static var height (get, never) : UInt;
	
	private static function get_height () {
		return Browser.window.innerHeight;
	}
	
	/**
	  * largeur du Canvas (change avec l'orientation)
	  */
	public static var width (get, never) : UInt;
	
	private static function get_width () {
		return Browser.window.innerWidth;
	}
	

}
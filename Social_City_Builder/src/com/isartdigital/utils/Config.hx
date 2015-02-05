package com.isartdigital.utils ;
import haxe.Json;
import js.Browser;

	
/**
 * Classe utilitaire contenant les données de configuration du jeu
 * @author Mathieu ANTHOINE
 */
class Config 
{
		
	/**
	 * version de l'application
	 */
	public static var version (get,never):String;

	/** 
	 * chemin du dossier de langues
	 */
	public static var langPath (get,never): String;
	
	/**
	 * langue courante
	 */
	public static var language (get,never): String;
	
	/**
	 * langues disponibles
	 */
	public static var languages (get,never): Array<String>;
	
	/**
	 * défini si le jeu est en mode "debug" ou pas (si prévu dans le code du jeu)
	 */
	public static var debug (get,never): Bool;
		
	/**
	 * conteneur des données de configuration
	 */
	public static var data (get, never):Dynamic;
	private static var _data:Dynamic={};
	
	public static function init(pConfig:Json): Void {		
		for (i in Reflect.fields(pConfig)) Reflect.setField(_data, i, Reflect.field(pConfig, i));
		
		
		if (_data.version == null) _data.version = "0.0.0";
		if (_data.langPath == null) _data.langPath = "";
		if (_data.language == null) _data.language = Browser.window.navigator.language.substr(0, 2);
		if (_data.languages == []) _data.languages.push(_data.language);
		if (_data.debug == []) _data.debug = false;
		
	}
	
	private static function get_data ():Dynamic {
		return _data;
	}
	
	private static function get_version ():String {
		return _data.version;
	}
	
	private static function get_langPath ():String {
		return _data.langPath;
	}
	
	private static function get_language ():String {
		return data.language;
	}
	
	private static function get_languages ():Array<String> {
		return data.languages;
	}
	
	private static function get_debug ():Bool {
		return data.debug;
	}

}
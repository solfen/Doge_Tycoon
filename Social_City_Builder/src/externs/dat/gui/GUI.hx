package externs.dat.gui;
import externs.dat.controllers.ColorController;
import externs.dat.controllers.Controller;
import haxe.Json;

/**
 * dat-gui JavaScript Controller Library
 * http://code.google.com/p/dat-gui
 *
 * Copyright 2011 Data Arts Team, Google Creative Lab
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 */

/**
 * @author Haxe externs: Mathieu Anthoine <anthoine.mathieu@gmail.com>
 */

@:native("dat.gui.GUI")
extern class GUI
{	
	
	/**
	 * A lightweight controller library for JavaScript. It allows you to easily
	 * manipulate variables and fire functions on the fly.
	 * @class GUI
	 * @param {GUIOptions} [options]
	 * @param {String} [options.name] The name of this GUI.
	 * @param {JSON} [options.load] JSON object representing the saved state of this GUI
	 * @param {String} [options.preset] name of the settings preset
	 * @param {Bool} [options.autoPlace=true] automatic position of this GUI 
	 * 
	 * @param {Bool} [options.auto] ???
	 * @param {parent} [params.parent] parent of this GUI
	 * @param {Boolean} [params.closed=false] GUI stars closed
	 */
	function new(?options:GUIOptions);	
	
	/**
	 * switch between visible and invisible mode
	 */
	static function toggleHide ():Void;
	
	/**
	 * Add a controller in this GUI
	 *
	 * @method add
	 * @param {Dynamic} object The object to be manipulated
	 * @param {string} property The name of the property to be manipulated
	 * @returns {Controller} The new controller that was added.
	 */	
	@:overload(function(object:Dynamic, property:String,min:Float,max:Float):Controller{})
	@:overload(function(object:Dynamic, property:String,values:Array<String>):Controller{})
	@:overload(function(object:Dynamic, property:String,values:Dynamic):Controller{})
	function add(object:Dynamic, property:String) : Controller;
	
	/**
	 * Remove a controller in this GUI
	 * 
	 * @param controller
	 */
	function remove (controller:Controller):Void;
	 
	/**
	 * Add folder in this GUI
	 * 
	 * @param name
	 * @returns {GUI} The new folder.
	 * @throws {Error} if this GUI already has a folder by the specified name
	 */
	function addFolder(name:String):GUI;
	
	/**
	 * Set a colorpicker to a controller
	 * 
	 * @param object
	 * @param property
	 * @returns {ColorController} The new ColorController that was added.
	 */
	function addColor(object:Dynamic, property:String) : ColorController;	
	
	/**
	 * Mark objects for saving. The order of these objects cannot change as
	 * the GUI grows. When remembering new objects, append them to the end
	 * of the list.
	 *
	 * @param {Dynamic} object to remember
	 * @throws {Error} if not called on a top level GUI.e
	 */
	function remember (object:Dynamic):Void;
	
	/**
	 * open this GUI
	 */
	function open():Void;
	
	/**
	 * close this GUI
	 */
	function close():Void;
	
	/**
	 * destroy this GUI
	 */
	function destroy ():Void;
	
}


typedef GUIOptions = {
	@:optional var load:Json;
	@:optional var preset:String;
	@:optional var autoPlace:Bool;
}
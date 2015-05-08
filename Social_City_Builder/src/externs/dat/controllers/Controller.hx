package externs.dat.controllers;
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

@:native("dat.controllers.Controller")
extern class Controller
{		
	/**
	 * @class An "abstract" class that represents a given property of an object.
	 *
	 * @param {Dynamic} object The object to be manipulated
	 * @param {string} property The name of the property to be manipulated
	 *
	 */
	function new(object:Dynamic, property:String);	
	
	/**
	 * 
	 * @param value minimum value
	 * @return the Controller instance
	 */
	function min(value:Float) : Controller;

	/**
	 * 
	 * @param value maximum value
	 * @return the Controller instance
	 */	
	function max(value:Float) : Controller;
	
	/**
	 * 
	 * @param value increment amount
	 * @return the Controller instance
	 */
	function step(value:Float) : Controller;
	
	/**
	 * Fires on every change, drag, keypress, etc.
	 * @param {Dynamic} Function to execute
	 */
	function onChange(callBack:Dynamic) : Void;
	
	/**
	 * Fires when a controller loses focus.
	 * @param {Dynamic} Function to execute
	 */
	function onFinishChange(callBack:Dynamic) : Void;
	
	/**
	 * listen to a Controller to react to changes made outside of the GUI
	 */
	function listen() : Void;
	
}
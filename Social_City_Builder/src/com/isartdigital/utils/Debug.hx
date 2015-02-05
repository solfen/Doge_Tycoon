package com.isartdigital.utils;

/**
 * Classe de Debug
 * @author Mathieu ANTHOINE
 */
class Debug
{

	private function new() 
	{
		
	}
	
	public static function error (pArg:Dynamic): Void {
		untyped console.error (pArg);
	}
	
	public static function warn (pArg:Dynamic): Void {
		untyped console.warn (pArg);
	}

	public static function table (pArg:Dynamic): Void {
		untyped console.table (pArg);
	}

	public static function info (pArg:Dynamic): Void {
		untyped console.info (pArg);
	}

}
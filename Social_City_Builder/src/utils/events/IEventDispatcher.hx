package utils.events;
import utils.events.Event;
/**
 * @author Mathieu Anthoine
 */

interface IEventDispatcher 
{
	function hasEventListener (pType:String, pListener:Dynamic):Int;
	function addEventListener(pType: String, pListener:Dynamic): Void;
	function removeEventListener(pType: String, pListener:Dynamic): Void;
	function dispatchEvent(pEvent: Event): Void;
	
}
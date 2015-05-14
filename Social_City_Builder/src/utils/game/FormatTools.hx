
package utils.game;

import DateTools;
import Date;
import haxe.Timer;

class FormatTools 
{
	public static function formatSeconds(secondsNb:Float) : String {
		var days:String = secondsNb >= 86400 ? Std.int(secondsNb/86400) + " jours " : "";
		var hours:String = secondsNb >= 3600 ? Std.int(secondsNb/3600) % 24 + " heures " : "";
		var minutes:String = secondsNb >= 60 ? Std.int(secondsNb/60) % 60 + " minutes " : "";
		var sec:String = secondsNb % 60 + " secondes";
		return days+hours+minutes+sec;
	}
	public static function formatNumbers(number:Float) : String {
		return '';
	}

}
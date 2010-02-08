package com.firebug.logger
{
	import flash.external.ExternalInterface;
	
	public class Logger
	{
		public static var debug:Boolean = true;
		
		public static function log(... arg:*):void {
			if (debug) {
				ExternalInterface.call("console.log", arg);
			}	
		}

		public static function info(... arg:*):void {
			if (debug) {
				ExternalInterface.call("console.info", arg);
			}
		}
		
		public static function error(... arg:*):void {
			if (debug) {
				ExternalInterface.call("console.error", arg);
			}
		}
	}
}
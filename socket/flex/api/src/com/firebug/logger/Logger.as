package com.firebug.logger
{
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class Logger
	{
		public static function get debug():Boolean {
			if ( Application.application.parameters["debug"] == "true" ) {
				return true;
			} else {
				return false;
			}
		}
		
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
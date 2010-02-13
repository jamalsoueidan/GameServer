package com.game.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerLite
	{
		public static function onComplete(func:Function, delay:Number, repeatCount:Number=1, object:Object=null):void {
			add(func, delay, repeatCount, TimerEvent.TIMER_COMPLETE, object);	
		}
		
		public static function onRepeat(func:Function, delay:Number, repeatCount:Number=1, object:Object=null):void {
			add(func, delay, repeatCount, TimerEvent.TIMER, object);
		}
		
		private static function add(func:Function, delay:Number, repeatCount:Number, event:String, object:Object):void {
			var timer:Timer = new Timer(delay, repeatCount);
			timer.addEventListener(event, function():void {
				if ( object ) {
					if ( object["parameter"] == "self" ) func(timer);
					else if ( object["parameter"] ) func(object["parameter"]);
				} else {
					func();
				}
				
			});
			timer.start();
		}
	}
}
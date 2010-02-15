package com.game.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerLite
	{
		public static function onComplete(func:Function, delay:Number, repeatCount:Number=1, object:Object=null):Timer {
			return add(func, delay, repeatCount, TimerEvent.TIMER_COMPLETE, object);	
		}
		
		public static function onRepeat(func:Function, delay:Number, repeatCount:Number=1, object:Object=null):Timer {
			return add(func, delay, repeatCount, TimerEvent.TIMER, object);
		}
		
		public static function onBoth(repeat:Function, complete:Function, delay:Number, repeatCount:Number=1, object:Object=null):Timer {
			var timer:Timer = new Timer(delay, repeatCount);
			timer.addEventListener(TimerEvent.TIMER, function():void {
				if ( object ) {
					if ( object["parameter"] == "self" ) repeat(timer);
					else if ( object["parameter"] ) repeat(object["parameter"]);
				} else {
					repeat();
				}
				
			});
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
				complete();
				
			});
			timer.start();
			return timer;
		}
		
		private static function add(func:Function, delay:Number, repeatCount:Number, event:String, object:Object):Timer {
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
			return timer;
		}
	}
}
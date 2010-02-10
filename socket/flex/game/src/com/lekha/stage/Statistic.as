package com.lekha.stage
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Statistic extends EventDispatcher
	{
		private var _count:Number = 0;

		public function addCount(value:Number):void {
			_count += value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get total():Number {
			return _count;
		}
		
		
	}
}
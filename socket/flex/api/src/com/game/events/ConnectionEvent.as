package com.game.events
{
	import flash.events.Event;

	public class ConnectionEvent extends Event
	{
		public static const ON_DATA:String = "update";
		
		private var _object:Object;
		
		public function get object():Object {
			return _object;	
		}
		
		public function ConnectionEvent(type:String, object:Object)
		{
			_object = object;
			super(type);
		}
		
	}
}
package com.game.events
{
	import com.game.core.Player;
	
	import flash.events.Event;

	public class RequestEvent extends Event
	{
		protected var _object:Object;
		
		public function get object():Object {
			return _object;
		}
		
		public function get player():Player {
			return new Player(_object["player"]);
		}
		
		public function RequestEvent(type:String, object:Object)
		{
			_object = object;
			super(type);
		}
		
	}
}
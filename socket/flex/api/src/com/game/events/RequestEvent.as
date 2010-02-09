package com.game.events
{
	import com.game.core.Player;
	
	import flash.events.Event;
	
	import mx.utils.ObjectUtil;

	public class RequestEvent extends Event implements IRequestEvent
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
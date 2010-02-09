package com.game.events
{
	public class GameObjectEvent extends RequestEvent
	{
		public static const RESPONSE:String = "GameObjectEventResponse";
		
		public function GameObjectEvent(type:String, object:Object)
		{
			super(type, object);
		}
		
		public function get classDispatcher():String {
			return _object["classDispatcher"];
		}
		
		public function get eventDispatcher():String {
			return _object["eventDispatcher"];
		}
	}
}
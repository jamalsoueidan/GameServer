package com.game.events
{
	public class PublicMessageEvent extends RequestEvent
	{
		public static const RESPONSE:String = "PublicMessageEventResponse";
		
		public function PublicMessageEvent(type:String, object:Object)
		{
			super(type, object);
		}
		
		public function get text():String {
			return _object["text"];	
		}
		
	}
}
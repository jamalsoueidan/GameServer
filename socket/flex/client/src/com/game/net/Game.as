package com.game.net
{
	import com.game.events.*;
	import com.game.requests.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	public class Game extends EventDispatcher
	{
		private var _connection:Connection;
		
		public function Game()
		{
			_connection = new Connection();
			_connection.addEventListener(Event.CONNECT, connected);
			_connection.addEventListener(ConnectionEvent.UPDATE, update);
			_connection.connect();
		}
		
		private function connected(evt:Event):void {
			var joinRoomRequest:JoinRoomRequest = new JoinRoomRequest();
			joinRoomRequest.salt = "jamal"
			joinRoomRequest.name = "Jamal"
			
			_connection.send(joinRoomRequest.object);
		}
		
		public function send(request:Request):void {
			//_game.send(request);
		}
		
		private function update(evt:ConnectionEvent):void {
			var object:Object = evt.object;
			
			var className:String = object["className"];
			className = className.replace("Request", "Event");
			
			var eventName:String = String(object["eventName"]);
			if ( eventName == "undefined" ) {
				eventName = className + "Response";
			}
			
			PlayerListEvent
			JoinRoomEvent
			
			
			trace("className:", "com.game.events." + className);
			trace("eventName:", eventName);
			 
			var classObject:Object = getDefinitionByName("com.game.events." + className);
			var event:RequestEvent = new classObject(eventName, object) as RequestEvent;
			dispatchEvent(event);
		}

	}
}
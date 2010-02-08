package com.game.net
{
	import com.game.events.*;
	import com.game.requests.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	[Event(name="close", type="flash.event.Event")]
	[Event(name="connect", type="flash.event.Event")]
	
	public class Game extends EventDispatcher
	{
		private var _connection:Connection;
		private static var _instance:Game;
		
		public static function getInstance():Game {
			if ( !_instance ) {
				new Game();
			}
			
			return _instance;
		}
		
		public function Game():void {
			if ( _instance ) {
				throw new Error("Only one instance of game");
			}
			
			_instance = this;
		}
		
		public function connect(host:String, port:Number):void {
			if ( !_connection ) {
				_connection = new Connection();
				_connection.addEventListener(Event.CONNECT, connected);
				_connection.addEventListener(ConnectionEvent.UPDATE, update); 
				_connection.connect(host, port);
			}
		}
		
		public function close():void {
			_connection.close();
		}
		
		private function connected(evt:Event):void {
			dispatchEvent(evt);
			
			/*var joinRoomRequest:JoinRoomRequest = new JoinRoomRequest();
			joinRoomRequest.salt = "jamal"
			joinRoomRequest.name = "Jamal"
			
			_connection.send(joinRoomRequest.object);*/
		}
		
		public function send(request:Request):void {
			_connection.send(request.object);
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
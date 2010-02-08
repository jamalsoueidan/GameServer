package com.game.net
{
	import com.game.requests.JoinRoomRequest;
	import com.game.requests.Request;
	
	import flash.events.Event;
	
	public class Game
	{
		private var _connection:Connection;
		
		public function Game()
		{
			_connection = new Connection();
			_connection.addEventListener(Event.CONNECT, connected);
			_connection.addEventListener(Event.CLOSE, closed);
			_connection.connect();
		}
		
		private function connected(evt:Event):void {
			var joinRoomRequest:JoinRoomRequest = new JoinRoomRequest();
			joinRoomRequest.salt = "jamal"
			joinRoomRequest.name = "Jamal"
			_connection.send(joinRoomRequest.object);
		}
		
		private function closed(evt:Event):void {
			
		}
		
		public function send(request:Request):void {
			//_game.send(request);
		}
		
		private function updated():void {
			/*var object:Object = evt.object["object"];
			
			var className:String = object["class_name"];
			var eventName:String = String(object["event_name"]);
			
			var words:Array = className.split("_");
			var realClassName:String = "";
			for each( var word:String in words) {
				realClassName += word.charAt(0).toUpperCase() + word.substr(1);
			}
						
			trace("LekhaGame => ", realClassName, eventName);
			var classObject:Object = getDefinitionByName("lekha.events." + realClassName + "Event");
			var eventObject:IGameEvent = new classObject(eventName);			
			eventObject.data = evt.object;
			dispatchEvent(eventObject as Event);*/
		}


	}
}
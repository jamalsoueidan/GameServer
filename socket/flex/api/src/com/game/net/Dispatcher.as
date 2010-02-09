package com.game.net
{
	import com.game.events.*;
	import com.game.requests.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	[Event(name="close", type="flash.event.Event")]
	[Event(name="connect", type="flash.event.Event")]
	
	public class Dispatcher extends EventDispatcher
	{
		private var _connection:Connection;
		
		public function connect():void {
			if ( !_connection ) {
				_connection = new Connection();
				_connection.addEventListener(Event.CONNECT, connected);
				_connection.addEventListener(ConnectionEvent.ON_DATA, update); 
				_connection.connect();
			}
		}
		
		public function close():void {
			_connection.close();
		}
		
		private function connected(evt:Event):void {
			dispatchEvent(evt);
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
			
			trace("className:", "com.game.events." + className);
			trace("eventName:", eventName);
			 
			var classObject:Object = getDefinitionByName("com.game.events." + className);
			// check if this is gameObjectEvent with custom event class
			if ( className == "GameObjectEvent" ) {
				if ( object["classDispatcher"] ) {
					
					trace(" - className changed:", object["classDispatcher"]);
					trace(" - eventName changed:", object["eventDispatcher"]);
					
					eventName = object["eventDispatcher"];
					classObject = getDefinitionByName(object["classDispatcher"]);
				}	
			}
			
			var event:IRequestEvent = new classObject(eventName, object);			
			dispatchEvent(event as Event);
		}

	}
}
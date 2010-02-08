package com.game.net
{
	import com.adobe.serialization.json.JSON;
	import com.firebug.logger.Logger;
	import com.game.events.ConnectionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
			
	[Event(name="close", type="flash.event.Event")]
	[Event(name="connect", type="flash.event.Event")]
	[Event(name="update", type="com.game.events.ConnectionEvent")]
	
	public class Connection extends EventDispatcher
	{
		private var socket:Socket;
			
		public function get connected():Boolean {
			return socket.connected;
		}
		
		public function Connection():void {
			socket = new Socket();
			
			Security.allowDomain("*");
			
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		public function connect(host:String="localhost", port:Number=15000):void {
			socket.connect(host, port);
		}
		
		public function close():void {
			socket.close();
		}
		
		private function connectHandler(evt:Event):void {
			Logger.log(evt.type);
			
			dispatchEvent(evt);
		}
		
		private function closeHandler(evt:Event):void {
			Logger.log(evt.type);
			
			dispatchEvent(evt);
		}
		
		private function socketDataHandler(evt:ProgressEvent):void {
			Logger.log(evt.type);
			var str:String = socket.readUTFBytes(socket.bytesAvailable);
			var array:Array = str.split("][");
			while(array.length>0) dispatchCustom(array.shift());
		}
		
		private function dispatchCustom(value:String):void {
			if ( value.substring(0, 1) == "{" ) value = "[" + value;
			if ( value.substr(-1) == "}" ) value += "]";

			Logger.log(value);
			var array:Array = JSON.decode(value);
			
			dispatchEvent(new ConnectionEvent(ConnectionEvent.UPDATE, array.pop()));
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			Logger.error(evt.type, evt.text);
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void {
			Logger.error(evt.type, evt.text);
		}
		
		public function send(object:Object):void {
			if ( socket.connected ) {
				var byta:ByteArray = new ByteArray();
				byta.writeObject(object);
				byta.position = 0;
				var result:Object = byta.readObject();
				var send_obj_str:String = JSON.encode(result);
				socket.writeUTFBytes(send_obj_str);
				socket.flush();
			}	
		}
	}
}
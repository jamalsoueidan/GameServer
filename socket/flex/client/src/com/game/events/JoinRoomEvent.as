package com.game.events
{
	public class JoinRoomEvent extends RequestEvent
	{
		public static var RESPONSE:String = "JoinRoomEventResponse";
		
		public function get isFull():Boolean {
			if ( _object["success"] ) {
				return false;
			} else {
				return true;
			}
		}
		
		public function JoinRoomEvent(type:String, object:Object) {
			super(type, object);
		}
		
		public function get maxPlayers():Number {
			return _object["max_players"];
		}
		
		public function get joinedPlayers():Number {
			return _object["joined_players"];
		}
	}
}
package com.game.events
{
	import com.game.core.Player;
	import com.game.manager.ObjectConveter;
	
	public class PlayerListEvent extends RequestEvent
	{
		public static var RESPONSE:String = "PlayerListEventResponse";
		
		public function PlayerListEvent(type:String, object:Object)
		{
			super(type, object);
		}
		
		public function get players():Array {
			return ObjectConveter.toPlayers(_object["users"]);
		}
		
	}
}
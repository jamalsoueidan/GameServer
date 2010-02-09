package com.game.events
{
	public class StartGameEvent extends RequestEvent
	{
		public static const ALL_PLAYERS_JOINED:String = "StartGameEventAllPlayersJoined";
		
		public function StartGameEvent(type:String, object:Object)
		{
			super(type, object);
		}
		
	}
}
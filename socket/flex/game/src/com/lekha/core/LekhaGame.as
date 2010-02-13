package com.lekha.core
{
	import com.firebug.logger.Logger;
	import com.game.core.Game;
	import com.game.events.JoinRoomEvent;
	import com.game.events.StartGameEvent;
	import com.game.requests.GameObjectRequest;
	import com.lekha.events.TableEvent;
	
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	public class LekhaGame extends Game
	{
		private static var instance:LekhaGame;
	    private static var allowInstantiation:Boolean;

		private var _isOwner:Boolean;
		
		public function get isOwner():Boolean {
			return _isOwner;
		}
		
		public static function getInstance():LekhaGame {
         	if (instance == null) {
            	allowInstantiation = true;
            	instance = new LekhaGame();
            	allowInstantiation = false;
          	}
          	
			return instance;
       	}
		
		public function LekhaGame()
		{	
			CursorManager.setBusyCursor();
			addEventListener(Event.CONNECT, connected);
			addEventListener(JoinRoomEvent.RESPONSE, joinedRoom);
			
			instance = this;
		}
		
		private function joinedRoom(evt:JoinRoomEvent):void {
			if ( evt.joinedPlayers == 1 ) {
				Logger.log("owner => ", currentPlayer.name);
				_isOwner = true;
			}	
		}
		
		private function connected(evt:Event):void {
			CursorManager.removeAllCursors();
			
			Application.application.enabled = true;
		}

	}
}
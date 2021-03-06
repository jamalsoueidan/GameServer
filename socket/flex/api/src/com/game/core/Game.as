package com.game.core
{
	import com.game.events.GameObjectEvent;
	import com.game.events.JoinRoomEvent;
	import com.game.events.PlayerListEvent;
	import com.game.events.StartGameEvent;
	import com.game.net.Dispatcher;
	
	[Event(name="response", type="com.game.events.JoinRoomEvent")]
	[Event(name="response", type="com.game.events.PlayerListEvent")]
	[Event(name="response", type="com.game.events.GameObjectEvent")]
	[Event(name="response", type="com.game.events.PublicMessageEvent")]
	
	public class Game extends Dispatcher
	{
		private static var _instance:Game;
		private var _dispatcher:Game;
		
		private var _room:Room;
		private var _player:Player;
		private var _allPlayers:Array;
		
		public function get currentPlayer():Player {
			return _player;
		}
		
		public function get currentRoom():Room {
			return _room;
		}
		
		public function get allPlayers():Array {
			return _allPlayers;
		}
		
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
			
			addEventListener(JoinRoomEvent.RESPONSE, joinedRoom);
			addEventListener(PlayerListEvent.RESPONSE, playerList);
			_instance = this;
		}
		
		private function joinedRoom(evt:JoinRoomEvent):void {
			removeEventListener(JoinRoomEvent.RESPONSE, joinedRoom);
			if ( !_room ) {
				_room = evt.room;
			}
			
			_player = evt.player;
		}
		
		private function playerList(evt:PlayerListEvent):void {
			_allPlayers = evt.players;
			
			if ( allPlayers.length >= _room.maxPlayers ) {
				dispatchEvent(new StartGameEvent(StartGameEvent.ALL_PLAYERS_JOINED, {}));
			}
		}
	}
}
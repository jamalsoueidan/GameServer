package com.game.core
{
	public class Room
	{
		private var _object:Object;
		/* private var _players:Array;
		
		public function set players(value:Array):void {
			_players = value;
		}
		
		public function get players():Array {
			return _players;
		}
		 */
		 
		public function get maxPlayers():Number {
			return Number(_object["max_players"]);
		}
		
		public function get joinedPlayers():Number {
			return Number(_object["joined_players"]);
		}
		
		public function Room(object:Object) {
			_object = object;
		}

	}
}
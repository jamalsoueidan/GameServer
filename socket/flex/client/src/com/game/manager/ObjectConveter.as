package com.game.manager
{
	import com.game.core.Player;
	
	public class ObjectConveter
	{
		public static function toPlayers(array:Array):Array {
			var players:Array = [];
			for each( var object:Object in array) {
				players.push(new Player(object));
			}
			return players;
		}

	}
}
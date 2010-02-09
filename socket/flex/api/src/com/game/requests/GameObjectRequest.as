package com.game.requests
{
	import com.game.core.Player;
	
	public class GameObjectRequest extends Request
	{
		public function addKeyValue(key:String, value:String):void {			
			_object[key] = value;
		}
		
		public function toPlayer(player:Player):void {
			_object["to"] = player.id;
		}
		
	}
}
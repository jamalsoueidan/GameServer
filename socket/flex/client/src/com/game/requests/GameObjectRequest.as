package com.game.requests
{
	public class GameObjectRequest extends Request
	{
		public function addKeyValue(key:String, value:String):void {			
			_object[key] = value;
		}
		
		public function toPlayer(player):void {
			_object["to"] = player.id;
		}
		
	}
}
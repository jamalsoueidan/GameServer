package com.game.requests
{
	import com.game.core.Player;
	
	public class GameObjectRequest extends Request
	{
		public function addKeyValue(key:String, value:String):void {
			validateKey(key);			
			_object[key] = value;
		}
		
		public function toPlayer(player:Player):void {
			_object["to"] = player.id;
		}
		
		public function set object(object:Object):void {
			for each(var key:String in object ) {
				validateKey(key);
				_object[key] = object[key];
			}
		}
		
	}
}
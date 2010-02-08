package com.game.core
{
	public class Player
	{
		private var _object:Object;
		
		public function get id():Number {
			return Number(_object["id"]);
		}
		
		public function get name():String {
			return _object["name"];	
		}
		
		public function Player(object:Object) {
			_object = object;
		}

	}
}
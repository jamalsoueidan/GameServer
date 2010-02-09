package com.game.requests
{
	public class JoinRoomRequest extends Request
	{
		public function set salt(value:String):void {
			_object["salt"] = value;
		}
		
		public function set name(value:String):void {
			_object["name"] = value;
		}
	}
}
package com.game.requests
{
	public class PublicMessageRequest extends Request
	{
		public function set text(value:String):void {
			_object["text"] = value;
		}
	}
}
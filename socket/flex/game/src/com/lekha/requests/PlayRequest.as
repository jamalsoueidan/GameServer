package com.lekha.requests
{
	import com.game.requests.GameObjectRequest;
	import com.lekha.events.PlayEvent;

	public class PlayRequest extends GameObjectRequest
	{
		public function PlayRequest(eventDispatcher:String, filter:Object=null):void {
			this.classDispatcher = PlayEvent;
			this.eventDispatcher = eventDispatcher;
			
			filterObject(filter);
		}	
		
	}
}
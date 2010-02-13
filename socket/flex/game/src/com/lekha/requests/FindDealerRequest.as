package com.lekha.requests
{
	import com.firebug.logger.Logger;
	import com.game.requests.GameObjectRequest;
	import com.lekha.events.FindDealerEvent;

	public class FindDealerRequest extends GameObjectRequest
	{
		public function FindDealerRequest(eventDispatcher:String, filter:Object=null):void {
			this.classDispatcher = FindDealerEvent;
			this.eventDispatcher = eventDispatcher;
			
			filterObject(filter);
		}	
	}
}
package com.lekha.requests
{
	import com.game.requests.GameObjectRequest;
	import com.lekha.events.TableEvent;

	public class TableRequest extends GameObjectRequest
	{
		public function TableRequest(eventDispatcher:String, filter:Object=null):void {
			this.classDispatcher = TableEvent;
			this.eventDispatcher = eventDispatcher;
			
			filterObject(filter);
		}
	}
}
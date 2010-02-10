package com.lekha.requests
{
	import com.game.requests.GameObjectRequest;
	import com.lekha.events.ExchangeCardsEvent;

	public class ExchangeCardsRequest extends GameObjectRequest
	{
		public function ExchangeCardsRequest(eventDispatcher:String):void {
			this.classDispatcher = ExchangeCardsEvent;
			this.eventDispatcher = eventDispatcher;
		}	
	}
}
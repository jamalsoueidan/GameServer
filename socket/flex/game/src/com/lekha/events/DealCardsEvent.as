package com.lekha.events
{
	import com.game.events.GameObjectEvent;
	import com.lekha.managers.CardManager;

	public class DealCardsEvent extends GameObjectEvent
	{
		public static const RECEIVED:String = "dealCards_RECEIVED";
		public static const COMPLETE:String = "dealCards_COMPLETE";
		public static const IM_DONE:String = "dealCards_IM_DONE";

		public function DealCardsEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get cards():Array {
			return CardManager.arrayToCards(_object["cards"]);
		}
		
	}
}
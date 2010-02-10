package com.lekha.events
{
	import com.game.events.GameObjectEvent;
	import com.lekha.managers.*;

	public class ExchangeCardsEvent extends GameObjectEvent
	{
		public static const IM_READY:String = "exchangeCards_IM_READY"; // when all players have changed cards, after animation is done.
		public static const ALLOW_SELECT_CARDS:String = "exchangeCards_SELECT_CARDS"; //allow to change cards
		public static const COMPLETE:String = "exchangeCards_COMPLETE"; //allow to change cards
		public static const RECEIVE_CARDS:String = "exchangeCards_RECEIVE_CARDS"; //when i send card to other player
		public static const ALLOW_EXCHANGE_CARDS:String = "exchangeCards_ALLOW_EXCHANGE_CARDS"; // used in exchange component
		public static const SENT_MY_CARDS:String = "exchangeCards_I_HAVE_RECIEVED_CARDS"; // when user sent his cards, he dispatch this event, this one only sents 1 to 1 message private.

		private var _total:Number;
		
		public function ExchangeCardsEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get total():Number {
			if ( _total > -1 ) {
				return _total;
			} else {
				return Number(_object["total"]);
			}
		}
		
		public function get cards():Array {
			return CardManager.arrayToCards(_object["cards"]);
		}
		
		public function set total(value:Number):void {
			_total = value;
		}
	}
}
package com.lekha.events
{
	import com.game.events.GameObjectEvent;
	import com.lekha.managers.CardManager;

	public class FindDealerEvent extends GameObjectEvent
	{
		// when the isOwner have created the deck and the cards is ready !
		public static const READY:String = "findDealerEvent_READY";
		
		// when player choose a card
		public static const CHOOSEN:String = "findDealerEvent_CHOOSEN";
		
		// when players is allowed to choose card again
		public static const RECHOOSE:String = "findDealerEvent_RECHOOSE";
		
		// when we are done with choose card to determine dealer.
		public static const COMPLETE:String = "findDealerEvent_COMPLETE";
		
		// when we are done with previous animation on chair, tell other so I can receive cards again.
		public static const RESEND:String = "findDealerEvent_RESEND";
		
		public function get cardString():String {
			return _object["card"];
		}
		
		public function FindDealerEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get cards():Array {
			return CardManager.arrayToCards(_object["cards"]);
		}
		
		public function get players():Array {
			return _object["players"];
		}
		
	}
}
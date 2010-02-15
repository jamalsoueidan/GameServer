package com.lekha.events 
{
	import com.game.events.GameObjectEvent;
	import com.lekha.display.CardImage;
	import com.lekha.managers.CardManager;

	public class PlayEvent extends GameObjectEvent
	{
		public static const READY_FOR_NEW_ROUND:String = "playerEvent_READY_FOR_NEW_ROUND";
		public static const READY_FOR_REPLAY:String = "playerEvent_READY_FOR_REPLAY";
		
		public static const NEW_ROUND:String = "playerEvents_NEW_ROUND";
		public static const PLAYED_CARD:String = "playerEvents_PLAYED_CARD";
		public static const COMPLETE:String = "playerEvent_COMPLETE";
		
		public function PlayEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get cardImage():CardImage {
			return CardManager.cardToImage(CardManager.stringToCard(_object["card"]));	
		}
		
		public function get card():String {
			return _object["card"];
		}

	}
}
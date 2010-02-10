package com.lekha.events
{
	import com.game.events.GameObjectEvent;
	import com.lekha.display.CardImage;
	import com.lekha.managers.CardManager;
	
	public class SomebodyLikeEvent extends GameObjectEvent
	{
		public static const SHOW_CARD:String = "somebodyLikesEvent_SHOW_CARD";
		public static const IM_READY:String = "somebodyLikesEvent_IMREADY";
		public static const COMPLETE:String = "somebodyLikesEvent_COMPLETE"; //allow to change cards	
			
		public function SomebodyLikeEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get card():CardImage {
			return CardManager.cardToImage(CardManager.stringToCard(_object["card"]));	
		}
	}
}
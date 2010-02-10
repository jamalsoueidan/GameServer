package com.lekha.events
{
	import com.lekha.display.CardImage;
	
	import flash.events.Event;

	public class CardEvent extends Event
	{
		public static const HIDDEN:String = "cardEvent_HIDDEN";
		public static const VISIBLE:String = "cardEvent_VISIBLE";
		
		public var cardImage:CardImage;
		
		public function CardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
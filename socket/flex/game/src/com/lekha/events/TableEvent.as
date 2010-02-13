package com.lekha.events
{
	import com.game.events.GameObjectEvent;

	public class TableEvent extends GameObjectEvent
	{	
		// when player choose chair
		public static const CHOOSEN:String = "chairEvent_CHOOSEN";
		
		// when player doesn't have chair position
		public static const REMOVED:String = "chairEvent_REMOVED";
		
		// when player click on ready button
		public static const READY:String = "chairEvent_READY";
		
		// when all players animation is done.
		public static const ANIMATION_DONE:String = "chairEvent_ANIMATION_DONE";
		
		// when all players have clicked on ready button
		public static const COMPLETE:String = "chairEvent_COMPLETE";
		
		public function TableEvent(type:String=null, object:Object=null) {
			super(type, object);
		}
		
		public function get position():Number {
			return Number(_object["position"]);
		}
	}
}
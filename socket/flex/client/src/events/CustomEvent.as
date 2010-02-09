package events
{
	import com.game.events.GameObjectEvent;

	public class CustomEvent extends GameObjectEvent
	{
		public static const RESPONSE:String = "CustomEventResponse";
		
		public function CustomEvent(type:String, object:Object)
		{
			super(type, object);
		}
		
	}
}
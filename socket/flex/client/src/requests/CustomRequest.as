package requests
{
	import com.game.requests.GameObjectRequest;
	
	import events.CustomEvent;

	public class CustomRequest extends GameObjectRequest
	{
		public function CustomRequest()
		{
			classDispatcher = CustomEvent;
			eventDispatcher = CustomEvent.RESPONSE;
		}
		
	}
}
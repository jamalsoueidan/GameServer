package com.lekha.display
{
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;

	public class ChairChild extends Canvas
	{
		private static var instance:ChairChild;
		
		public static function getInstance():ChairChild {
			if ( !instance ) {
				instance = new ChairChild();
			}
			
			return instance;
		}
		
		public function ChairChild()
		{	
			super();
			
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			
			percentWidth = 95;
			percentHeight = 95;
			
			y = x = 20;
			
			
			name = "ChairChild";
		}
		
	}
}
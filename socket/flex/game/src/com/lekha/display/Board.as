package com.lekha.display
{
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;

	public class Board extends Canvas
	{
		private static var instance:Board;
		
		public static function getInstance():Board {
			if ( !instance ) {
				instance = new Board();
			}
			
			return instance;
		}
		
		public function Board()
		{	
			super();
			
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			
			addEventListener(ResizeEvent.RESIZE, function():void {
				percentWidth = 100;
				percentHeight = 100;
			});
			
			percentWidth = 100;
			percentHeight = 100;
			
			name = "board";
		}
		
	}
}
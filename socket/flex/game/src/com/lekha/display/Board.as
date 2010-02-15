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
			
			percentWidth = 95;
			percentHeight = 95;
			
			y = x = 20;
			
			
			name = "board";
		}
		
	}
}
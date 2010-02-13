package com.lekha.commands
{
	import com.lekha.core.LekhaGame;
	import com.lekha.display.Board;
	import com.lekha.display.Chair;
	import com.lekha.display.ChairChild;
	
	import stages.visual.*;
	
	public class Command
	{
		protected static var _board:Board;
		protected static var _chairChild:ChairChild;
		protected static var _game:LekhaGame;
		protected static var _myChair:Chair;
		
		public function Command() {
			_board = Board.getInstance();
			_game = LekhaGame.getInstance();
			_chairChild = ChairChild.getInstance();
		}
		
		protected function get allChairs():Array {
			return Chair.getAllChairs();
		}
	}
}
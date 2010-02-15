package com.lekha.commands
{
	import com.lekha.core.LekhaGame;
	import com.lekha.display.Board;
	import com.lekha.display.Chair;
	import com.lekha.display.ChairChild;
	import com.lekha.display.RoundDisplay;
	import com.lekha.display.StatsDisplay;
	
	import stages.visual.*;
	
	public class Command
	{
		protected static var _board:Board;
		protected static var _chairChild:ChairChild;
		protected static var _game:LekhaGame;
		protected static var _myChair:Chair;
		protected static var _stats:StatsDisplay;
		protected static var _round:RoundDisplay;
		
		public function Command() {
			_board = Board.getInstance();
			_game = LekhaGame.getInstance();
			_chairChild = ChairChild.getInstance();
		}
		
		protected function get allChairs():Array {
			return Chair.getAllChairs();
		}
		
		protected function get stats():StatsDisplay {
			return StatsDisplay.getInstance();
		}
		
		protected function get round():RoundDisplay {
			return RoundDisplay.getInstance();
		}
	}
}
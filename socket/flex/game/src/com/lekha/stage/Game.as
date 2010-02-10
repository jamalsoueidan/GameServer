package com.lekha.stage
{
	import com.lekha.core.LekhaGame;
	import com.lekha.display.Board;
	import com.lekha.display.Chair;
	
	import stages.visual.*;
	
	public class Game
	{
		protected static var _board:Board;
		protected static var _game:LekhaGame;
		protected static var _chairs:Array = [];
		protected static var _myChair:Chair;
		
		public function Game() {
			_board = Board.getInstance();
			_game = LekhaGame.getInstance();
			_chairs = Chair.getAllChairs();
		}
	}
}
package com.lekha.engine
{
	// spades(♠), hearts(♥), diamonds(♦) and clubs(♣).
	
	public class Suit
	{		
		public static const DIAMONDS:Suit = new Suit("Diamonds", "d");
		public static const SPADES:Suit = new Suit("Spades", "s");
		public static const CLUBS:Suit = new Suit("Clubs", "c");
		public static const HEARTS:Suit = new Suit("Hearts", "h");
		
		private var _name:String;
		private var _symbol:String;
			
		public static function get types():Array {
			return [DIAMONDS, SPADES, CLUBS, HEARTS];
		} 
		
		public function Suit(name:String, symbol:String)
		{
			_name = name;
			_symbol = symbol;	
		}
		
		public function get name():String {
			return _name;
		}

		public function get symbol():String {
			return _symbol;
		}
		
		public function toString():String {
			return _symbol;
		}
	}
}
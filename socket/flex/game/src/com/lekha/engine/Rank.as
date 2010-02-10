package com.lekha.engine
{
	public class Rank
	{
	   public static const ACE:Rank = new Rank( "Ace", "14" );
	   public static const TWO:Rank = new Rank( "Two", "2" );
	   public static const THREE:Rank = new Rank( "Three", "3" );
	   public static const FOUR:Rank = new Rank( "Four", "4" );
	   public static const FIVE:Rank = new Rank( "Five", "5" );
	   public static const SIX:Rank = new Rank( "Six", "6" );
	   public static const SEVEN:Rank = new Rank( "Seven", "7" );
	   public static const EIGHT:Rank = new Rank( "Eight", "8" );
	   public static const NINE:Rank = new Rank( "Nine", "9" );
	   public static const TEN:Rank= new Rank( "Ten", "10" );
	   public static const JACK:Rank = new Rank( "Jack", "11" );
	   public static const QUEEN:Rank = new Rank( "Queen", "12" );
	   public static const KING:Rank = new Rank( "King", "13" );
		
		private var _name:String;
		private var _symbol:String;
		
		public static function get types():Array {
			return [ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING];
		}
		
		public function Rank(name:String, symbol:String) {
			_name = name;
			_symbol = symbol;
		}

		public function get name():String {
			return _name;
		}
		
		public function get symbol():String {
			return _symbol;
		}
		
		public function toNumber():Number {
			return Number(_symbol);
		}
		
		public function toString():String {
			return _symbol;
		}
	}
}
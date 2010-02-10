package com.lekha.engine
{
	import mx.controls.Image;
	
	public class Card
	{
		private var _suit:Suit;
		private var _rank:Rank;
		
		public function Card( suit:Suit, rank:Rank ) {
			_suit = suit;
			_rank = rank;
		}
		
		public function get suit():Suit {
			return _suit;
		}
		
		public function get rank():Rank {
			return _rank;
		}
		
		public function toString():String {
			return _suit.toString() + " " + _rank.toString();
		}
		
		public function toPath():String {
			return _suit.toString() + _rank.toString();
		}
		
		public function toInteger():Number {
			return Number(_rank.symbol);
		}
	}
}
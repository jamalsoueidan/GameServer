package com.lekha.engine
{
	import mx.collections.ArrayCollection;
	
	public class Deck
	{
		protected var _cards:Array;
		protected var _index:Number;
		
		public function Deck()
		{
			_cards = [];
			_index = 0;
		}

		public function addCard( card:Card ):void {
			_cards.push(card);
		}
		
		public function get cards():Array {
			return _cards;
		}
		
		public function getNextCard():Card {
			return nextCard();
		}
		
		public function nextCard():Card {
			if ( _index >= _cards.length ) {
				return null;
			} else {
				_index++;
				return _cards[_index];
			}
		}
		
		public function get numAllCards():Number {
			return _cards.length;
		}
		
		public function get numCardsRemaining():Number {
			return _cards.length - _index;
		}
		
		public function shuffle():void {
			var length:Number = _cards.length;
			for (var i:Number = 0; i<length; i++) {
			    var rand:Number = Math.floor(Math.random()*length);
			    var temp:Card = _cards[i];
			    _cards[i] = _cards[rand];
			    _cards[rand] = temp;
			}

		}	
	}
}
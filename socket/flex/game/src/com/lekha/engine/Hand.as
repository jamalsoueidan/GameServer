package com.lekha.engine
{
	import mx.utils.Base64Encoder;
	
	public class Hand
	{
		private var _cards:Array;
		
		public function Hand() {
			_cards = [];
		}
		
		public function isEmpty():Boolean {
			if ( numCards > 0 ) {
				return true;
			}	
			return false;
		}
		
		public function clear():void {
			_cards = [];
		}
		
		public function addCard( card:Card ):void {
			_cards.push(card);
		}
		
		public function addCards( newCards:Array ):void {
			if ( newCards.length > 0 ) {
				for(var i:int=0;i<newCards.length;i++){
					addCard(newCards[i]);
				}
			}	
		}
		
		public function getCard( index:Number ):Card {
			return _cards[index];
		}
		
		public function removeCard( card:Card ):Card {
			var index:Number = _cards.indexOf(card);
			if ( index < 0 ) {
				return null;
			} else {
				return removeCardAtIndex(index);
			}
		}
		
		public function removeCardAtIndex( index:Number ):Card {
			var length:Number = numCards;
			var card:Card = _cards[index];
			for(;index<length;index++) {
				_cards[index] = _cards[index+1];
			}
				
			_cards.pop();
			
			return card;
		}
		
		public function get numCards():Number {
			return _cards.length;
		}
		
		public function toXML():String {
			var xml:String = "<cards>"
			for(var i:Number=0;i<_cards.length;i++) {
				xml += "<card><rank>"+ _cards[i].rank.toString() +"</rank><suit>" + _cards[i].suit.toString()+"</suit></card>";
			}
			xml += "</cards>";
			return xml;
		}
	}
}
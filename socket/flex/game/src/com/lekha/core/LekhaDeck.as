package com.lekha.core
{
	import com.lekha.engine.*;
	
	public class LekhaDeck extends Deck
	{
		public function LekhaDeck()
		{
			var card:Card;
			for each( var suit:Suit in Suit.types ) {
				for each( var rank:Rank in Rank.types ) {
					addCard(new Card(suit, rank));
				}
			}
		}
		
		public function getCards(num:Number):Array {
			var cards:Array = [];
			for(var i:int=0;i<num;i++){
				cards[i] = getNextCard();
			}
			
			return cards;
		}
		
	}
}
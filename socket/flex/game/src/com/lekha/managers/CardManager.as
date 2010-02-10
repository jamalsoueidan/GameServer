package com.lekha.managers
{
	import com.lekha.display.CardImage;
	import com.lekha.engine.Card;
	import com.lekha.engine.Rank;
	import com.lekha.engine.Suit;
	
	public class CardManager
	{
		public static function stringToCard(cardString:String):Card {
			var both:Array = cardString.split(" ");
			
			for each(var suit:Suit in Suit.types) {
				if ( both[0] == suit ) {
					break;
				}
			} 
			
			for each( var rank:Rank in Rank.types ) {
				if ( both[1] == rank ) {
					break;
				}	
			}
			
			var card:Card = new Card(suit, rank);
			return card;
		}
		
		public static function arrayToCards(cardsArray:Array):Array {
			var cards:Array = new Array();
			
			for each( var cardString:String in cardsArray ) {
				cards.push(stringToCard(cardString));
			}
			
			return cards;
		}
		
		public static function cardToImage(card:Card):CardImage 
		{
			var img:CardImage = new CardImage();
			img.card = card;
			return img; 
		}

	}
}
package com.lekha.managers
{
	import com.lekha.commands.*;
	import com.lekha.display.*;
	import com.lekha.engine.Suit;
	
	import mx.core.UIComponent;
	
	public class DealManager extends Command
	{
		private static var _cardSpace:Number = 16;
		
		public static function get cardSpace():Number {
			return _cardSpace;
		}
		
		public static function deckPosition(chair:Chair):Object {
			var toRotation:Number = 0;		
			var toX:Number = 0;
			var toY:Number = 0;	
			
			if ( chair.placement == Chair.TOP || chair.placement == Chair.BOTTOM) {
				toX = _board.width/2;
				if ( chair.placement == Chair.TOP ) {
					toY = _cardSpace*2 + _myChair.height;
				} else {
					toY = (_myChair.y - CardImage.HEIGHT*2) + _cardSpace;
				}
			} else {
				toY = _board.height/2;
				toRotation = 90; 
				if ( chair.placement == Chair.LEFT ) {
					toX = _myChair.width*2;
				} else {
					toX = (_board.width) - CardImage.HEIGHT/2 - _myChair.width;
				}
			} 
			
			return {x:toX, y:toY, rotation:toRotation};
		}
		
		public static function orderCards(chair:Chair):void {
			var cards:Array = chair.hand.cards;
			var countCards:Number = 0;
			var cardImage:CardImage
			
			for each( cardImage in cards ) {
				if ( !cardImage.liked ) countCards++; 
			}

			//Logger.log("ordreCards", chair.player.name, countCards);
			
			var startFromHolder:Number = (countCards * _cardSpace) / 2;
			// we use it again later
			countCards = 0;
			
			var positionX:Number;
			var positionY:Number;
			var rotation:Number;
			
			var parent:UIComponent = Board.getInstance();
			var position:Object; 
			var likedCards:Number = 3;
			
			for each( cardImage in cards ) {
				if ( !cardImage.liked ) { 
					position = cardPosition(chair, startFromHolder, countCards);
					countCards++;
				} else {
					position = cardPosition(chair, startFromHolder, (cards.length+likedCards));
					likedCards++;
				}

				parent.addChild(cardImage);

				cardImage.x = position.x;
				cardImage.y = position.y;
				cardImage.rotation = position.rotation;
			}
		}
		
		private static function cardPosition(chair:Chair, startFromHolder:Number, countCards:Number):Object {
			var position:Object = {};
			if ( chair.placement == Chair.TOP || chair.placement == Chair.BOTTOM ) {
				// X position for TOP and BOTTOM is the same to calculate for both of them
				position.x = ((chair.x + (chair.width/2)) - startFromHolder) - ((CardImage.WIDTH/2)/2);
				if ( countCards > 0 ) {
					position.x += (_cardSpace * countCards);
				}
				
				// now for Y position they are different
				if ( chair.placement == Chair.TOP ) {
					position.y = chair.height + _cardSpace;	
				} else {
					position.y = (chair.y - _cardSpace) - CardImage.HEIGHT;
				}
				
				position.rotation = 0;
			} else {
				// Y position is the same for LEFT AND RIGHT so we calculate them also together
				position.y = ((chair.y + (chair.height/2))  - startFromHolder) - ((CardImage.WIDTH/2)/2);
				if ( countCards > 0) {
					position.y += (_cardSpace * countCards);
				} 
				// now for X position they are different
				if ( chair.placement == Chair.LEFT) {
					position.x = chair.width + _cardSpace + CardImage.HEIGHT;
				} else {
					position.x = (chair.x - _cardSpace);
				}
				
				position.rotation = 90;
			}
			return position; 
		}
		
		// spades(♠), hearts(♥), diamonds(♦) and clubs(♣).
		
		public static function sortCards(chair:Chair):void {
			var cards:Array = chair.hand.cards;
			
			// order by suit first
			var types:Array = [[], [], [], []];
			var suit:String;
			for each( var cardImage:CardImage in cards ) {
				suit = cardImage.card.suit.symbol;
				if ( suit  == Suit.HEARTS.symbol ) 
					types[0].push(cardImage);
				else if ( suit == Suit.CLUBS.symbol ) 
					types[1].push(cardImage);
				else if ( suit == Suit.DIAMONDS.symbol )
					types[2].push(cardImage);
				else
					types[3].push(cardImage);
			}
			
			types[0].sort(sortOnRank);
			types[1].sort(sortOnRank);
			types[2].sort(sortOnRank);
			types[3].sort(sortOnRank);
			
			var hand:Hand = chair.hand;
			hand.clear();
			
			for each( var type:Array in types ) {
				for each( cardImage in type ) {
					hand.addCard(cardImage);
				}
			}
			function sortOnRank(a:CardImage, b:CardImage):Number {
				var aRank:Number = a.card.toInteger();
				var bRank:Number = b.card.toInteger();
				
				if(aRank > bRank) {
				    return 1;
				} else if(aRank < bRank) {
				    return -1;
				} else  {
				    return 0;
				}
			}
			
			//orderCards(chair);
		}
		
		public static function dealingCardPosition(chair:Chair, playerTurn:Number, cardTotal:Number=13):Object {
			var startFromHolder:Number = (cardTotal * _cardSpace) / 2;
	
			var positionX:Number;
			var positionY:Number;
			var rotation:Number = 0;
			
			if ( chair.placement == Chair.TOP || chair.placement == Chair.BOTTOM ) {
				// X position for TOP and BOTTOM is the same to calculate for both of them
				positionX = ((chair.x + (chair.width/2)) - startFromHolder) - ((CardImage.WIDTH/2)/2);
				if ( playerTurn > 0 ) {
					positionX += (_cardSpace * playerTurn);
				}
				
				// now for Y position they are different
				if ( chair.placement == Chair.TOP ) {
					positionY = chair.height + _cardSpace;	
				} else {
					positionY = (chair.y - _cardSpace) - CardImage.HEIGHT;
				}
			} else {
				// Y position is the same for LEFT AND RIGHT so we calculate them also together
				positionY = ((chair.y + (chair.height/2))  - startFromHolder) - ((CardImage.WIDTH/2)/2);
				if ( playerTurn > 0 ) {
					positionY += (_cardSpace * playerTurn);
				} 
				// now for X position they are different
				if ( chair.placement == Chair.LEFT) {
					positionX = chair.width + _cardSpace + CardImage.HEIGHT;
				} else {
					positionX = (chair.x - _cardSpace);
				}
				
				rotation = 90;
			} 
			
			return {x:positionX, y:positionY, rotation:rotation};
		}
	}
}
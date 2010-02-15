package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.greensock.TweenLite;
	import com.lekha.display.CardImage;
	
	public class Hand extends Holder
	{
		private var _cards:Array;
		private var _likedQueen:Boolean;
		private var _likedDiamond:Boolean;
		
		public function get cards():Array {
			return _cards;
		}
		
		public function set likedQueen(value:Boolean):void {
			_likedQueen = value;
		}
		
		public function get likedQueen():Boolean {
			return _likedQueen;
		}
		
		public function getQueen():CardImage {
			for each( var findCard:CardImage in cards ) {
				if ( findCard.card.toString() == "s 12" ) {
					break;
				}
			}
			return findCard;
		}
		
		public function set likedDiamond(value:Boolean):void {
			_likedDiamond = value;
		}
		
		public function get likedDiamond():Boolean {
			return _likedDiamond;
		}
		
		public function getDiamond():CardImage {
			for each( var findCard:CardImage in cards ) {
				if ( findCard.card.toString() == "d 10" ) {
					break;
				}
			}
			return findCard;
		}
		
		public function Hand() {
			_cards = [];
		}
		
		override public function isEmpty():Boolean {
			if ( numCards <= 0 ) {
				return true;
			}	
			return false;
		}
		
		override public function clear():void {
			super.clear();
			
			_cards = [];
		}
		
		public function findCard(cardImage:CardImage):CardImage {
			for each( var findCard:CardImage in cards ) {
				if ( findCard.card.toString() == cardImage.card.toString() ) {
					break;
				}
			}
			return findCard;
		}
		
		/* ONLY FOR TESTING */
		public function searchCard(suit:String):CardImage {
			for each( var findCard:CardImage in cards ) {
				if ( findCard.card.suit.symbol == suit ) {
					break;
				}
			}
			return findCard;
		}
		/*-----------------------------*/
		
		public function addCard( cardImage:CardImage ):void {
			_cards.push(cardImage);
			
			add(cardImage);
		}
		
		public function addCards( newCards:Array ):void {
			if ( newCards.length > 0 ) {
				for(var i:int=0;i<newCards.length;i++){
					addCard(newCards[i]);
				}
			}	
		}
		
		public function getCard( index:Number ):CardImage {
			return _cards[index];
		}
		
		public function getRandomCard():CardImage {
			var random:Number = Math.round(Math.random()*(_cards.length-1));
			return _cards[random];
		}
		
		public function removeCard( cardImage:CardImage ):CardImage {
			var newCards:Array = [];
			for each( var findCardImage:CardImage in _cards ) {
				if ( findCardImage.card.toString() != cardImage.card.toString() ) {
					newCards.push(findCardImage);
				} else {
					//Logger.log("remove card from hand", cardImage.card.toString());
				}
			}
			remove(cardImage);
			_cards = newCards;
			return cardImage;
		}
		
		public function removeCardAtIndex( index:Number ):CardImage {
			var length:Number = numCards;
			var card:CardImage = _cards[index];
			for(;index<length;index++) {
				_cards[index] = _cards[index+1];
			}
				
			_cards.pop();
			
			remove(_cards[index]);
			return card;
		}
		
		public function get numCards():Number {
			return _cards.length;
		}
		
		public function centerObjects():void {
			var foundChildren:Number = Math.ceil(_children/2);
			var totalChildren:Number = Math.ceil(_indexs/2);
			
			var startIndex:Number = totalChildren - foundChildren;
			var currentIndex:Number = startIndex;
			for( var i:int = 0;i < _indexs; i++) {
				if ( _list[i] ) {
					TweenLite.to(_list[i], 1,  position(currentIndex));
					currentIndex++
				}
			}
			
			//Logger.log("found", foundChildren, totalChildren, startIndex);
		}
	}
}
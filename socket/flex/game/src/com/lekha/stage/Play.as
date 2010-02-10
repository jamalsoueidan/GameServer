package com.lekha.stage
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.game.requests.GameObjectRequest;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.engine.*;
	import com.lekha.events.PlayEvent;
	import com.lekha.managers.ChairManager;
	import com.lekha.managers.DealManager;
	
	import custom.WaitingForPlayersBox;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.core.Application;
	
	public class Play extends Game implements IStage
	{
		private var _myTurn:Boolean = false; // when my turn comes this will be set to true
		private var _allowSuit:String; // which suit is played FIRST
		private var _cardImagePlayed:Array = []; 
		
		private var _ownerPlayerSession:Number; // who is owner now
		private var _waitingForPlayersBox:WaitingForPlayersBox;
		
		private var _animation:TimelineLite;
		private var _animationObject:Array = [];
		private var _winnerChair:Chair;
		
		private var _timer:Timer = new Timer(2000, 10000);
		
		public function execute():void {
			_game.addEventListener(PlayEvent.PLAYED_CARD, playedCard);
			
			_waitingForPlayersBox = new WaitingForPlayersBox();
			
			addEventsOnCards();
			startRound();
			
			_timer.addEventListener(TimerEvent.TIMER, function():void {
				var cardImage:CardImage;
				if ( _allowSuit ) {
					cardImage = _myChair.hand.searchCard(_allowSuit);
				} else {
					cardImage = _myChair.hand.getRandomCard();
				}
				
				sendCard(cardImage);
			});
			_timer.start(); 
		}
		
		public function terminate():void {
			_game.removeEventListener(PlayEvent.PLAYED_CARD, playedCard);
			_timer.stop();
			_timer = null;
		}
		
		private function checkIfWeAreLastPlayerToPlayCard():void {			
			if ( _cardImagePlayed.length >= 4 ) {
				// determine winner
				var lastObject:Object;
				var count:Number = 0;
				var card:Card;
				var suit:Suit;
				var rank:Rank;
				var queen:Boolean = false;
				for each( var object:Object in _cardImagePlayed ) {
					card = object.cardImage.card;
					suit = card.suit;
					rank = card.rank;
					
					//Logger.log(" - Player ", object.player.name, " played", card.toString(), "suit", suit.symbol);
					 
					if ( lastObject ) {
						 if ( rank.toNumber() > lastObject.cardImage.card.rank.toNumber() && _allowSuit == suit.symbol ) {
						 	lastObject = object;
						 }
					} else {
						lastObject = object;
					}
					
					if ( suit.symbol == "h" ) {
						count += 1;
					} else if ( card.toString() == "d 10" ) {
						if ( object.cardImage.liked ) count += 20;
						else count += 10;
					} else if ( card.toString() == "s 12") {
						queen = true;
						if ( object.cardImage.liked ) count += 26;
						else count += 13;
					}
				}
				
				Logger.log("The winner is", lastObject.player.name, "Played", lastObject.cardImage.card.toString());
				if ( queen ) {
					DealCards.dealerSession = lastObject.player.id;
				}
				
				moveCardsToWinner(lastObject, count);
			}
		}
		
		private function moveCardsToWinner(winner:Object, count:Number):void {
			_winnerChair = ChairManager.getByPlayerSession(winner.player.id);
			_winnerChair.statistic.addCount(count);
			
			// please move to the chair who is winning.
			for each( var object:Object in _cardImagePlayed ) {
				_animationObject.push(object.cardImage);
			}
			
			_cardImagePlayed = [];
			Logger.log("Move cards to", _winnerChair.player.name);
			
			_animation = new TimelineLite({delay:1.5, onComplete:animationComplete});
			_animation.appendMultiple( TweenMax.allTo(_animationObject, 1.5, {y:_winnerChair.y, x:_winnerChair.x, alpha:0}) );
		}
		
		private function animationComplete():void {
			_animation.stop();
			_animation = null;
			
			if ( _winnerChair.hand.isEmpty() ) {
				Logger.log("new round");
				for each( var chair:Chair in _chairs ) chair.reset();
				_game.dispatchEvent(new PlayEvent(PlayEvent.NEW_ROUND));
			} else {
				Logger.log("lets play again!");
				turnOnFirstPlayer(_winnerChair);
			}
			
			for each( var cardImage:CardImage in _animationObject ) {
				_board.removeChild(cardImage);
			}
			
			_animationObject = [];
		}
		
		private function removeWaitingForPlayersBox():void {
			if ( _waitingForPlayersBox ) {
				_board.removeChild(_waitingForPlayersBox);
				_waitingForPlayersBox = null;
			}
		}
		
		public function playedCard(evt:PlayEvent):void {
			
			removeWaitingForPlayersBox();
			
			//Logger.log(" * Card Played by", evt.from.name, "cards: ", _cardImagePlayed.length);
			
			//Logger.log(_cardImagePlayed);
			
			var player:Player = evt.player;
			if ( player.id != _game.currentPlayer.id ) {
				var chair:Chair = ChairManager.getByPlayerSession(player.id);
				
				//Logger.log("Chair player", chair.player.name, chair.placement);
				var cardImagePlayed:CardImage = evt.card;
				var cardString:String = cardImagePlayed.card.toString();
				var cardImageRandom:CardImage = chair.hand.getRandomCard();
				
				if ( cardString == "s 12") {
					if ( chair.hand.likedQueen ) {
						cardImageRandom = chair.hand.getQueen();
					}	
				} else if ( cardString == "d 10" ) {	
					if ( chair.hand.likedDiamond ) {
						cardImageRandom = chair.hand.getDiamond();
					}
				}
				
				cardImageRandom.card = cardImagePlayed.card;
			
				chair.hand.removeCard(cardImageRandom);
				var point:Point = getPosition(chair);
				
				_cardImagePlayed.push({player:player, cardImage:cardImageRandom});
				TweenLite.to(cardImageRandom, .5, {x:point.x, y:point.y});
			
				cardImageRandom.show();
				
				//DealManager.sortCards(chair);
			
				var nextChair:Chair = chair.nextChair();
				
				//Logger.log(" * Next player", nextChair.player.name);
				
				if ( _cardImagePlayed.length > 0 ) {
					if ( !_allowSuit ) {
						//Logger.log("suit allowed only", _allowSuit);
						_allowSuit = cardImagePlayed.card.suit.symbol;
					}
				}
				
				if ( _cardImagePlayed.length <= 3 ) {	
					if ( nextChair.player.id == _game.currentPlayer.id ) {
						_myTurn = true;
					}
				}
			}
			
			checkIfWeAreLastPlayerToPlayCard();
		}
		
		public function newRound(evt:PlayEvent):void {
			
		}
		
		private function startRound():void {
			var chair:Chair = ChairManager.getDealerChair();
			chair = chair.nextChair();
			
			if ( chair.player.id == _game.currentPlayer.id ) {
				_waitingForPlayersBox.text = "You turn to start!";
			} else {
				_waitingForPlayersBox.text = chair.player.name + " play the first card!";
			}
			_board.addChild(_waitingForPlayersBox);
			
			turnOnFirstPlayer(chair)
		}	
		
		private function turnOnFirstPlayer(chair:Chair):void {
			_allowSuit = null;
			_cardImagePlayed = [];
			
			Logger.log("Turn on first player", chair.player.name, "my name is:", _game.currentPlayer.name); 
				
			if ( chair.player.id == _game.currentPlayer.id ) {
				_ownerPlayerSession = chair.player.id;
				_myTurn = true;
			}
		}
		
		private function addEventsOnCards():void {
			for each( var cardImage:CardImage in _myChair.hand.cards ) {
				cardImage.addEventListener(MouseEvent.CLICK, clicked);
			}
		}
		
		private function clicked(evt:MouseEvent):void {
			if ( !_myTurn ) return;
				
			var cardImage:CardImage = evt.target as CardImage;
			sendCard(cardImage);
		}
		
		private function sendCard(cardImage:CardImage):void {
			
			if ( !_myTurn ) return;
			
			if ( _allowSuit ) {
				//Logger.log("suit is determine");
				if ( cardImage.card.suit.symbol != _allowSuit ) {
					//Logger.log("played card NOT THE SAME suit");
					if ( haveTheSameSuit() ) {
						//Alert.show("You must play the same suit");
						return;
					}
				}
			} else {
				_allowSuit = cardImage.card.suit.symbol;
			}
			
			_cardImagePlayed.push({player:_game.currentPlayer, cardImage:cardImage});
			_myChair.hand.removeCard(cardImage);
			
			cardImage.lock();
			
			var point:Point = getPosition(_myChair);
			TweenLite.to(cardImage, .5, {x:point.x, y:point.y});
			
			var request:GameObjectRequest = new GameObjectRequest(PlayEvent, PlayEvent.PLAYED_CARD);	
			request.addKeyValue("card", cardImage.card.toString());
			_game.send(request);
			
			//DealManager.sortCards(_myChair);
			
			_myTurn = false;
		}
		
		private function haveTheSameSuit():Boolean {
			for each( var cardImage:CardImage in _myChair.hand.cards ) {
				if ( cardImage.card.suit.symbol == _allowSuit ) {
					return true;
				}
			}
			return false;
		}
		private function getPosition(chair:Chair):Point {
			var point:Point = new Point();
			if ( chair.placement == Chair.BOTTOM ) {
				point.x = (Application.application.width/2) - (CardImage.WIDTH/2);
				point.y = (Application.application.height/2);
			} else if ( chair.placement == Chair.RIGHT ) {
				point.x = (Application.application.width/2) + CardImage.HEIGHT;
				point.y = (Application.application.height/2) - (CardImage.WIDTH/2);
			} else if ( chair.placement == Chair.LEFT ) {
				point.x = (Application.application.width/2);
				point.y = (Application.application.height/2) - (CardImage.WIDTH/2)
			} else {
				point.x = (Application.application.width/2) - (CardImage.WIDTH/2);
				point.y = (Application.application.height/2) - CardImage.HEIGHT;
			}
			
			return point;
		}
		
	}
}
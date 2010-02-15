package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.engine.*;
	import com.lekha.events.PlayEvent;
	import com.lekha.managers.ChairManager;
	import com.lekha.requests.PlayRequest;
	
	import custom.WaitingForPlayersBox;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	public class Play extends Command implements ICommand
	{
		private var _myTurn:Boolean = false; // when my turn comes this will be set to true
		private var _allowSuit:String; // which suit is played FIRST
		private var _cardImagePlayed:Array = []; 
		
		private var _ownerPlayerSession:Number; // who is owner now
		private var _waitingForPlayersBox:WaitingForPlayersBox;
		
		private var _animation:TimelineLite;
		private var _animationObject:Array = [];
		private var _winnerChair:Chair;
		
		private var _playersReadyForNewRound:Number = 0;
		private var _timer:Timer = new Timer(3000, 10000);
		
		public function execute():void {
			_game.addEventListener(PlayEvent.PLAYED_CARD, playedCard);
			_game.addEventListener(PlayEvent.READY_FOR_NEW_ROUND, readyForNewRound);
			_game.addEventListener(PlayEvent.READY_FOR_REPLAY, readyForReplay);
			
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
			_game.removeEventListener(PlayEvent.READY_FOR_NEW_ROUND, readyForNewRound);
			_game.removeEventListener(PlayEvent.READY_FOR_REPLAY, readyForReplay);
			
			_timer.stop();
			_timer = null;
			
			_board.removeAllChildren();
		}
		
		private function readyForNewRound(evt:PlayEvent):void {
			_playersReadyForNewRound++;
			
			Logger.log("readyForNewRound", _playersReadyForNewRound);
			
			if ( _game.allPlayers.length == _playersReadyForNewRound ) {
				_game.dispatchEvent(new PlayEvent(PlayEvent.NEW_ROUND));
			}
		}
		
		private function readyForReplay(evt:PlayEvent):void {
			_playersReadyForNewRound++;
			
			Logger.log("readyForReplay", _playersReadyForNewRound);
			
			if ( _game.allPlayers.length == _playersReadyForNewRound ) {
				turnOnFirstPlayer(_winnerChair);
			}
		}
		
		private function checkIfWeAreLastPlayerToPlayCard():void {
			Logger.log("checkIfWeAreLastPlayerToPlayCard", _cardImagePlayed.length);			
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
			_winnerChair = ChairManager.getByPlayer(winner.player.id);
			//_winnerChair.statistic.addCount(count);
			
			stats.addCount(_winnerChair, count);
			
			var tweens:Array = [];
			var rotation:Number;
			var x:Number;
			var y:Number;
			
			// please move to the chair who is winning.
			for each( var object:Object in _cardImagePlayed ) {
				if ( _winnerChair.placement == Chair.LEFT || _winnerChair.placement == Chair.RIGHT ) {
					rotation = 90;	
					y = _winnerChair.y + _winnerChair.height/2;
					x = 0;
					if ( _winnerChair.placement == Chair.RIGHT ) x = _board.width;
				} else {
					rotation = 0;
					x = _winnerChair.x + _winnerChair.width/2;
					y = 0;
					if ( _winnerChair.placement == Chair.BOTTOM ) y = _board.height;
				}
				
				//Logger.log("Move cards to", _winnerChair.player.name, _winnerChair.placement, x, y);
				
				tweens.push(new TweenLite(object.cardImage, .5, {rotation:rotation, x:x, y:y, alpha:0}));
			}
			
			_animation = new TimelineLite({tweens:tweens, align:TweenAlign.START, delay:1.5, onComplete:animationComplete});
			
			_cardImagePlayed = [];
		}
		
		private function animationComplete():void {
			_animation.stop();
			_animation = null;
			
			if ( _winnerChair.hand.isEmpty() ) {
				newRound();
			} else {
				_game.send(new PlayRequest(PlayEvent.READY_FOR_REPLAY));
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
			
			Logger.log("Current player", evt.player.name, "played card", evt.card, "cards played: ", _cardImagePlayed.length);
			
			//Logger.log(_cardImagePlayed);
			
			var player:Player = evt.player;
			if ( player.id != _game.currentPlayer.id ) {
				var chair:Chair = ChairManager.getByPlayer(player.id);
				
				//Logger.log("Chair player", chair.player.name, chair.placement);
				var cardImagePlayed:CardImage = evt.cardImage;
				var cardString:String = evt.card;
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
				chair.hand.centerObjects();
								
				_cardImagePlayed.push({player:player, cardImage:cardImageRandom});
				TweenLite.to(cardImageRandom, .5, getPosition(chair));
				
				cardImageRandom.show();
			
				var nextChair:Chair = chair.nextChair();
				
				if ( _cardImagePlayed.length > 0 ) {
					if ( !_allowSuit ) {
						//Logger.log("suit allowed only", _allowSuit);
						_allowSuit = cardImagePlayed.card.suit.symbol;
					}
				}
				
				if ( _cardImagePlayed.length < 4 ) {
					Logger.log(" +> Next player", nextChair.player.name);	
					if ( nextChair.player.id == _game.currentPlayer.id ) {
						_myTurn = true;
					}
				}
			}
		}
		
		public function newRound():void {
			Logger.log(" new round");
			round.newRound();
			stats.update();
			
			for each( var chair:Chair in allChairs ) {
				chair.reset();
			}
			
			Logger.log(" - reseting chairs");
			
			_waitingForPlayersBox = new WaitingForPlayersBox();
			_waitingForPlayersBox.text = "Wait a moment to start new round";
			_board.addChild(_waitingForPlayersBox);
			
			
			Logger.log(" - adding wait box");
			
			
			if ( stats.doWeHaveLoser ) {
				chair = stats.getLoserChair();
				Alert.show("The loser is " + chair.player.name);
				
			} else {
				_game.send(new PlayRequest(PlayEvent.READY_FOR_NEW_ROUND));
			}
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
			_playersReadyForNewRound = 0;
			
			_allowSuit = null;
			_cardImagePlayed = [];
			
			Logger.log("---------------  Turn on first player", chair.player.name, "my name is:", _game.currentPlayer.name); 
				
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
			
			_myChair.hand.centerObjects();
			
			TweenLite.to(cardImage, .5, getPosition(_myChair));
			
			_game.send(new PlayRequest(PlayEvent.PLAYED_CARD, {card:cardImage.card.toString()}));
			
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
		
		private function getPosition(chair:Chair):Object {
			var object:Object = {scaleX:1, scaleY:1};
			if ( chair.placement == Chair.BOTTOM ) {
				object.x = chair.x + chair.width/2;
				object.y = (_board.height/2) + CardImage.HEIGHT/2 - 25;
				object.rotation = 10;
			} else if ( chair.placement == Chair.RIGHT ) {
				object.x = (_board.width/2) + CardImage.HEIGHT/2;
				object.y = chair.y + chair.height/2  - 25;
				object.rotation = 120;
			} else if ( chair.placement == Chair.LEFT ) {
				object.x = (_board.width/2) - CardImage.HEIGHT/2;
				object.y = chair.y + chair.height/2 - 25;
				object.rotation = 40;
			} else {
				object.x = chair.x + chair.width/2;
				object.y = (_board.height/2) - CardImage.HEIGHT/2 - 25;
				object.rotation = -10;
			}
			
			object.onComplete = checkIfWeAreLastPlayerToPlayCard;
			return object;
		}
		
	}
}
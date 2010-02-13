package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.events.ExchangeCardsEvent;
	import com.lekha.managers.ChairManager;
	import com.lekha.managers.DealManager;
	import com.lekha.requests.ExchangeCardsRequest;
	
	import custom.CountDownWithCommentBox;
	import custom.ExchangeCardsBox;
	import custom.WaitingForPlayersBox;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ExchangeCards extends Command implements ICommand
	{
		private var _playersDoneWithAnimation:Number = 0;
		private var _timer:Timer;
		private var _cardsChoosen:Array = []; // the cards which will be sent to previous player
		private var _totalCardsToChoose:Number = 0; //Comes from the event evt.total
		
		private var _didIRecieveCards:Boolean; // did I receive the choosen cards
		private var _recievedCards:ExchangeCardsEvent;
		private var _animationComplete:Number = 0;
		private var _didWeExchangeCards:Boolean;
		
		private var _didISendCards:Boolean; // did I send the choosen cards
		private var _exchangeCardsEvent:ExchangeCardsEvent;	
		
		private var _exchangeCardsBox:ExchangeCardsBox;
		private var _countDownWithCommentBox:CountDownWithCommentBox;
		private var _waitingForPlayers:WaitingForPlayersBox;
		
		private var _cardsOnTableOldPositions:Array = []; // save old cards position.

		
		public function execute():void {
			_game.addEventListener(ExchangeCardsEvent.ALLOW_SELECT_CARDS, selectCards);
			_game.addEventListener(ExchangeCardsEvent.RECEIVE_CARDS, receivedCards);
			//_game.addEventListener(ExchangeCardsEvent.IM_READY, imReady);
			_game.addEventListener(ExchangeCardsEvent.SENT_MY_CARDS, sentCards);

			_exchangeCardsBox = new ExchangeCardsBox();
			_exchangeCardsBox.addEventListener(ExchangeCardsEvent.ALLOW_EXCHANGE_CARDS, playerMadeChoice);
			
			_countDownWithCommentBox = new CountDownWithCommentBox();
			_countDownWithCommentBox.addEventListener(MouseEvent.CLICK, playerIsFinished);
			
			_waitingForPlayers = new WaitingForPlayersBox();

			playerNextToDealerAllowToChooseExchangeCards();
		}
		
		public function terminate():void {
			_game.removeEventListener(ExchangeCardsEvent.ALLOW_SELECT_CARDS, selectCards);
			_game.removeEventListener(ExchangeCardsEvent.RECEIVE_CARDS, receivedCards);
			//_game.removeEventListener(ExchangeCardsEvent.IM_READY, imReady);
			_game.removeEventListener(ExchangeCardsEvent.SENT_MY_CARDS, sentCards);
			
			if ( _exchangeCardsBox ) {
				_exchangeCardsBox.removeEventListener(ExchangeCardsEvent.IM_READY, playerMadeChoice);
				if ( _board.contains(_exchangeCardsBox)) {
					_board.removeChild(_exchangeCardsBox);
				}
			}
			
			if ( _countDownWithCommentBox ) {
				_countDownWithCommentBox.removeEventListener(ExchangeCardsEvent.IM_READY, playerIsFinished);
				if ( _board.contains(_countDownWithCommentBox)) {
					_board.removeChild(_countDownWithCommentBox);
				}
			}
			
			if ( _waitingForPlayers ) {
				if ( _board.contains(_waitingForPlayers)) {
					_board.removeChild(_waitingForPlayers);	
				}
			}
			
			DealManager.sortCards(_myChair);
		}
		
		private function sentCards(evt:ExchangeCardsEvent):void {			
			// get chair and cards from the other player we are exchanging cards with.
			var player:Player = evt.player;
			var playerChair:Chair = ChairManager.getByPlayerSession(player.id);
			var playerHand:Hand = playerChair.hand;
			var playerCards:Array = playerHand.cards;
			
			Logger.log("player is ready", playerChair.player.name, " cards", _totalCardsToChoose);
			
			var cards:Array = [];
			
			if ( player.id != _myChair.player.id ) {
				for( var i:int = 0; i<_totalCardsToChoose; i++ ) {
					while(addChoosenCard(playerHand.getRandomCard(), cards)!=false);
				}
			} else {
				cards = _cardsChoosen;	
			}
			
			var animation:TimelineMax = new TimelineMax({paused:true, onComplete:moveCardsToMiddleAnimationComplete});
			var coordinates:Object = getCoordinates(playerChair);
			var space:Number = coordinates.x;
			
			if ( playerChair.placement == Chair.LEFT || playerChair.placement == Chair.RIGHT ) {
				space = coordinates.y;
			}
			
			cards.sortOn("sort", Array.NUMERIC);
			 				
			for(i=0; i<_totalCardsToChoose; i++ ) {
				if ( i != 0 ) {
					if ( playerChair.placement == Chair.LEFT || playerChair.placement == Chair.RIGHT ) {
						space = (DealManager.cardSpace*i) + coordinates.y;
					} else {
						space = (DealManager.cardSpace*i) + coordinates.x;
					}
				}
				
				if ( playerChair.placement == Chair.LEFT || playerChair.placement == Chair.RIGHT ) {
					animation.append(new TweenLite(cards[i], 1, {x:coordinates.x, y:space}));
				} else {
					animation.append(new TweenLite(cards[i], 1, {x:space, y:coordinates.y}));
				}
			}
			
			_cardsOnTableOldPositions.push({chair:playerChair, cards:cards}); //positions:oldPositions});
			
			animation.play();
		}
		
		private function moveCardsToMiddleAnimationComplete():void {
			_playersDoneWithAnimation++;
			
			if ( _game.allPlayers.length == _playersDoneWithAnimation ) {
				_playersDoneWithAnimation = 0;
				exchangeCards();	
			}
		}
		
		private function exchangeCards():void {
			if ( _didWeExchangeCards ) return;
			_didWeExchangeCards = true;
			
			_countDownWithCommentBox.visible = _waitingForPlayers.visible = false;
			
			for each( var object:Object in _cardsOnTableOldPositions ) {
				for each( var card:CardImage in object.cards ) {
					object.chair.hand.removeCard(card);
				}
			}
			var chair:Chair;
			var cards:Array;			
			var beforeChair:Chair;

			for each( object in _cardsOnTableOldPositions ) {
				chair = object.chair;
				cards = object.cards;				
				beforeChair = chair.beforeChair();

				for(var j:int=0; j<cards.length; j++) {				
					if ( beforeChair.player.id == _myChair.player.id ) {
						cards[j].card = _recievedCards.cards[j];
						cards[j].show();
					} else {
						cards[j].hide();
						cards[j].lock();
					}
						
					beforeChair.hand.addCard(cards[j]);
				}
			}
			
			_game.dispatchEvent(new ExchangeCardsEvent(ExchangeCardsEvent.COMPLETE));
		}
		
		private function receivedCards(evt:ExchangeCardsEvent):void {				
			_recievedCards = evt;
		}
		
		// add exchangecardsbox to the player next to dealer to choose how many cards to exchange.
		private function playerNextToDealerAllowToChooseExchangeCards():void {
			var chair:Chair = ChairManager.getByPlayerSession(DealCards.dealerSession).nextChair();
			if ( _game.currentPlayer.id == chair.player.id) {
				_board.addChild(_exchangeCardsBox);
			} else {
				_waitingForPlayers.text = "Waiting on " + chair.player.name + " to determine how many cards to exchange!";
				_board.addChild(_waitingForPlayers);
			}
		}
		
		// add events to cards
		private function pleaseChooseExchangingCards():void {
			for each(var card:CardImage in _myChair.hand.cards ) {
				card.movement = true;
				card.clickable = false;
				card.addEventListener(MouseEvent.CLICK, chooseExchangingCards);
			}
		}
		
		// remove events from cards.
		private function stopChooseExchangingCards():void {
			for each(var card:CardImage in _myChair.hand.cards ) {
				card.removeEventListener(MouseEvent.CLICK, chooseExchangingCards);
			}
		}
		
		private function chooseExchangingCards(evt:MouseEvent):void {
			var cardImage:CardImage = evt.target as CardImage;
			
			if ( cardImage.selected ) {
				removeChooseCard(cardImage);
				cardImage.selected = false;
				cardImage.movement = true;
			} else {
				addChoosenCard(cardImage);
				cardImage.selected = true;
				cardImage.movement = false;
			}
			
			leftToChoose();
		}
		
		private function removeChooseCard(findCardImage:CardImage):void {
			var newChooseCards:Array = [];
			for each( var cardImage:CardImage in _cardsChoosen ) {
				if ( findCardImage.card.toString() != cardImage.card.toString() ) {
					newChooseCards.push(cardImage);
				}
			}
			
			
			_cardsChoosen = newChooseCards;
		}
		
		private function addChoosenCard(addCardImage:CardImage, cardsChoose:Array=null):Boolean {
			var found:Boolean = false;
			if ( !cardsChoose ) {
				cardsChoose = _cardsChoosen;
			} 
			
			for each( var cardImage:CardImage in cardsChoose ) {
				if ( addCardImage.card.toString() == cardImage.card.toString() ) {
					found = true;
					break;
				}
			}
			
			if ( !found ) {
				cardsChoose.push(addCardImage);
			}
			return found;
		}
		
		private function playerMadeChoice(evt:ExchangeCardsEvent):void {
			
			var sendObject:ExchangeCardsRequest;
			if ( evt.total > 0 ) {
				sendObject = new ExchangeCardsRequest(ExchangeCardsEvent.ALLOW_SELECT_CARDS);
				sendObject.addKeyValue("total", evt.total);
			} else {
				sendObject = new ExchangeCardsRequest(ExchangeCardsEvent.COMPLETE);
			}
			
			Logger.log("player made choice", evt.total);
			
			_game.send(sendObject);
			
			_exchangeCardsBox.visible = false;
		}
		
		// the other player have made choice how many cards to exchange.
		private function selectCards(evt:ExchangeCardsEvent):void {
			_totalCardsToChoose = evt.total;
			
			if ( _board.contains(_waitingForPlayers)) {
				_board.removeChild(_waitingForPlayers);
			}
			
			_board.addChild(_countDownWithCommentBox);
			_countDownWithCommentBox.comment = 	"Please choose " + evt.total.toString() + " cards";
			pleaseChooseExchangingCards();
			
			startTimer();
		}
		
		private function startTimer():void {
			var sec:Number = _totalCardsToChoose*5;
			if ( _totalCardsToChoose == 1 ) {
				// if only one card allow 10 sec to choose
				sec = _totalCardsToChoose*10;
			}
			_timer = new Timer(1000, sec);
			
			// write out how many sec back to choose cards
			_timer.addEventListener(TimerEvent.TIMER, function():void {
				_countDownWithCommentBox.timer = (sec-_timer.currentCount).toString();
			}, false,0,true);
			
			// timer is finished, choose automatic cards.
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
				if ( _cardsChoosen.length != _totalCardsToChoose ) {
					// choose cards automatic
					while(_totalCardsToChoose>_cardsChoosen.length) {
						addChoosenCard(_myChair.hand.getRandomCard());
					}
					
					playerIsFinished();
				}
			}, false,0,true);
			
			_timer.start();
		}
		
		private function leftToChoose():void {
			var left:Number = _totalCardsToChoose - _cardsChoosen.length;
			_countDownWithCommentBox.error = left.toString() + " left to choose!"
		}
		
		// player clicked on finish button
		private function playerIsFinished(evt:MouseEvent=null):void {
			if ( _didISendCards ) return;
			
			if ( _totalCardsToChoose != _cardsChoosen.length ) {
				leftToChoose();
			} else {
				_didISendCards = true;
				
				stopChooseExchangingCards();
				
				var beforeChair:Chair = _myChair.beforeChair(); 
				
				var cardsString:Array = [];
				_cardsChoosen.sortOn("sort", Array.NUMERIC);
				for each( var cardImage:CardImage in _cardsChoosen) {
					cardsString.push(cardImage.card.toString());
				}
				
				var sendObject:ExchangeCardsRequest = new ExchangeCardsRequest(ExchangeCardsEvent.RECEIVE_CARDS);
				sendObject.addKeyValue("cards", cardsString);
				sendObject.toPlayer(beforeChair.player);
				_game.send(sendObject);

				_game.send(new ExchangeCardsRequest(ExchangeCardsEvent.SENT_MY_CARDS));
					
				_exchangeCardsBox.visible = _countDownWithCommentBox.visible = false;
				
				_waitingForPlayers.text = "Waiting on other players to exchange cards";
				_board.addChild(_waitingForPlayers);
			}
		}
		
		private function getCoordinates(chair:Chair):Object {
			var point:Object = new Object();
			var cardImage:CardImage = chair.hand.getRandomCard();
			var startPosition:Number = (DealManager.cardSpace*_totalCardsToChoose);
			
			if ( chair.placement == Chair.BOTTOM ) {
				Logger.log("bottom");
				point.x = (_board.width/2) - startPosition;
				point.y = cardImage.y - cardImage.height - DealManager.cardSpace;
			} else if ( chair.placement == Chair.RIGHT ) {
				Logger.log("right");
				point.x = chair.x - CardImage.HEIGHT - (DealManager.cardSpace*2);
				point.y = (_board.height/2) - startPosition;
			} else if ( chair.placement == Chair.LEFT ) {
				Logger.log("left");
				point.x = cardImage.x + CardImage.HEIGHT + (DealManager.cardSpace*2);
				point.y = (_board.height/2)  - startPosition;
			} else {
				Logger.log("top");
				point.x = (_board.width/2) - startPosition;
				point.y = cardImage.y + cardImage.height + DealManager.cardSpace;
			}
			
			return point;
		}
	}
}
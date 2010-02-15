package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.requests.GameObjectRequest;
	import com.game.utils.TimerLite;
	import com.greensock.*;
	import com.lekha.core.LekhaDeck;
	import com.lekha.display.*;
	import com.lekha.engine.Card;
	import com.lekha.engine.Deck;
	import com.lekha.events.DealCardsEvent;
	import com.lekha.managers.*;
	
	import custom.WaitingForPlayersBox;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import stages.visual.*;
	
	public class DealCards extends Command implements ICommand
	{
		private static var _cardImages:Array = [];
		private var _cardNumber:Number = 0; // cardNumber hold which cardImage to animate next, so we dont keeping animating the same cardImage
		private var _cardPositions:Array = [0,0,0,0,0]; // includes x,y positions for cards
		private var _chairTurn:Chair;
		
		private static var _dealerSession:Number; // which player to deal the cards
		private var _totalPlayerOfPlayerAnimationFinish:Number = 0;
		
		private var _waitingBox:WaitingForPlayersBox;
		
		public static function set dealerSession(value:Number):void {
			_dealerSession = value;
		} 
		
		public static function get dealerSession():Number {
			return _dealerSession;
		}
		
		public static function get myCards():Array {
			return _cardImages;
		}
		
		public function set dealerSession(value:Number):void {
			_dealerSession = value;			
		}
		
		public function execute():void {
			_game.addEventListener(DealCardsEvent.IM_DONE, newPlayerDoneWithAnimation);
			_game.addEventListener(DealCardsEvent.RECEIVED, receivedMyCards);
			
			createDeckAndSendCards();
			
			_waitingBox = new WaitingForPlayersBox();
			_waitingBox.text = "Wait a sec...";
		}
		
		public function terminate():void {
			_game.removeEventListener(DealCardsEvent.IM_DONE, newPlayerDoneWithAnimation);
			_game.removeEventListener(DealCardsEvent.RECEIVED, receivedMyCards);
				
			_cardImages = [];
			
			if ( _board.contains(_waitingBox)) {
				_board.removeChild(_waitingBox);
			}
		}
		
		private function newPlayerDoneWithAnimation(evt:DealCardsEvent):void {
			_totalPlayerOfPlayerAnimationFinish++;
			
			if ( _game.isOwner ) {
				if ( _totalPlayerOfPlayerAnimationFinish == _game.allPlayers.length ) {
					_game.send(new GameObjectRequest(DealCardsEvent, DealCardsEvent.COMPLETE)); 
				}
			}
		}
		
		private function createDeckAndSendCards():void {
			if ( _game.isOwner ) {
				var _deck:Deck = new LekhaDeck();
				_deck.shuffle();
				
				var players:Array = [[], [], [], []];
				var playerTurn:Number = 0;
				var cards:Array = [];
				for each( var card:Card in _deck.cards) {
					if ( playerTurn > 3 ) {
						playerTurn = 0;
					}
					players[playerTurn].push(card.toString());
					playerTurn++;
				}
				
				for(var i:int = 0; i<_game.allPlayers.length;i++) {
					var request:GameObjectRequest = new GameObjectRequest(DealCardsEvent, DealCardsEvent.RECEIVED);	
					request.toPlayer(_game.allPlayers[i]);
					request.addKeyValue("cards", players[i])
					_game.send(request);
				}
				
			}
		}
		
		private function receivedMyCards(evt:DealCardsEvent):void {
			
			for each(var chair:Chair in allChairs ) {
				if ( chair.player.id == _dealerSession ) {
					break;
				}
			}
			
			_myChair.hand.owner = true;
			
			var positionXY:Object = DealManager.deckPosition(chair);
			var cardImage:CardImage;
			
			Logger.log("cards received", evt.cards.length);
			
			// copy my cards and give them to other player.
			for each(var card:Card in evt.cards ) {
				for(var i:int = 0;i<4; i++) {
					cardImage = CardManager.cardToImage(card);
					cardImage.cacheAsBitmap = true;						
					_cardImages.push(cardImage);
					cardImage.x = positionXY.x;
					cardImage.y = positionXY.y;
					cardImage.lock();
					cardImage.rotation = positionXY.rotation;
					Board.getInstance().addChild(cardImage);
				}
			}
			
			Logger.log("dealer: ", chair.player.name);
			_chairTurn = chair.nextChair(true);
			startAnimation();
		}
		
		private function startAnimation():void {
			var timer:Timer = new Timer(50, _cardImages.length);
			timer.addEventListener(TimerEvent.TIMER, animationSteps, false,0,true);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, animationComplete, false,0,true);
			timer.start();
		}
		
		private function animationComplete(evt:TimerEvent):void {
			_board.addChild(_waitingBox);
			
			Logger.log("finish animation", _myChair.player.name);
			
			_game.send(new GameObjectRequest(DealCardsEvent, DealCardsEvent.IM_DONE)); 
			
			for each( var cardImage:CardImage in _myChair.hand.cards ) cardImage.show();
			
			TimerLite.onComplete(ImDone, 1000, 1);
		}
		
		private function ImDone():void {
			DealManager.sortCards(_myChair);
		}
		
		private function animationSteps(evt:TimerEvent):void {
			var timer:Timer = evt.target as Timer;
			var index:Number = timer.currentCount - 1;
			var card:CardImage = _cardImages[index];
			_chairTurn.hand.addCard(card);
		
			if ( _chairTurn.player.id == _game.currentPlayer.id) {
				card.clickable = false;
				//card.show();
			}
			

			_chairTurn = _chairTurn.nextChair(true);
		}
	}
}
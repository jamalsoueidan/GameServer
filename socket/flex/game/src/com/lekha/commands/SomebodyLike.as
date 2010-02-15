package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.requests.GameObjectRequest;
	import com.game.utils.TimerLite;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.events.ExchangeCardsEvent;
	import com.lekha.events.SomebodyLikeEvent;
	import com.lekha.managers.ChairManager;
	import com.lekha.managers.DealManager;
	
	import custom.*;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import stages.visual.*;

	public class SomebodyLike extends Command implements ICommand
	{
		public static var WAIT_TIME:Number = 8;
		
		private var _timer:Timer;
		
		private var _exchangeCardsEvent:ExchangeCardsEvent;	
		private var _playersReady:Number = 0; // or diamond 10
		
		private var _countDownWithCommentBox:CountDownWithCommentBox;
		private var _waitingForPlayersBox:WaitingForPlayersBox;
		
		public function execute():void {
			_game.addEventListener(SomebodyLikeEvent.SHOW_CARD, showCard);
			_game.addEventListener(SomebodyLikeEvent.IM_READY, imReady);
			
			_countDownWithCommentBox = new CountDownWithCommentBox();
			_countDownWithCommentBox.addEventListener(MouseEvent.CLICK, userIsDone);
			
			_waitingForPlayersBox = new WaitingForPlayersBox();
			_waitingForPlayersBox.text = "Waiting on the other players...";
			
			_board.addChild(_countDownWithCommentBox);
			
			if ( Logger.debug ) WAIT_TIME = 5;
			
			somebodyLikes();
		}
		
		public function terminate():void {
			_game.removeEventListener(SomebodyLikeEvent.SHOW_CARD, showCard);
			
			_countDownWithCommentBox.removeEventListener(MouseEvent.CLICK, userIsDone);
			
			if ( _board.contains(_countDownWithCommentBox )) {
				_board.removeChild(_countDownWithCommentBox);
			}
			
			if ( _board.contains(_waitingForPlayersBox)) {
				_board.removeChild(_waitingForPlayersBox);
			}
		}
		
		private function imReady(evt:SomebodyLikeEvent):void {
			if ( _game.isOwner ) {
				_playersReady++;
				
				if ( _playersReady == _game.allPlayers.length ) {
					_game.send(new GameObjectRequest(SomebodyLikeEvent, SomebodyLikeEvent.COMPLETE));
				}
			}
		}

		private function somebodyLikes():void {
			_countDownWithCommentBox.comment = "Somebody likes?";
			
			for each(var card:CardImage in _myChair.hand.cards ) {
				if ( card.isShown ) {
					card.movement = true;
					card.addEventListener(MouseEvent.CLICK, chooseQueenOrDiamond);
				}
			}
			
			round.setTimeLeft(WAIT_TIME);
			TimerLite.onComplete(done, 1000, WAIT_TIME);
		}
		
		private function chooseQueenOrDiamond(evt:MouseEvent):void {
			var cardImage:CardImage = evt.target as CardImage
			var chair:Chair = ChairManager.getByPlayer(_game.currentPlayer.id);
			var cardString:String = cardImage.card.toString();
			
			if ( cardString == "d 10" || cardString == "s 12") {
				if ( !cardImage.liked ) {
					cardImage.movement = false; 
					cardImage.liked = true;
				
					var sendObject:GameObjectRequest = new GameObjectRequest(SomebodyLikeEvent, SomebodyLikeEvent.SHOW_CARD);
					sendObject.addKeyValue("card", cardString);
					_game.send(sendObject);
				}
			} 
		}
		
		private function userIsDone(evt:MouseEvent):void {
			done();
		}
		
		private function done():void {
			killEvents();
		
			_countDownWithCommentBox.visible = false;
			
			var sendObject:GameObjectRequest = new GameObjectRequest(SomebodyLikeEvent, SomebodyLikeEvent.IM_READY);
			_game.send(sendObject);
			
			_board.addChild(_waitingForPlayersBox);
		}
		
		private function killEvents():void {
			for each(var card:CardImage in _myChair.hand.cards ) {
				if ( card.isShown ) {
					card.removeEventListener(MouseEvent.CLICK, chooseQueenOrDiamond);
				}
			}
		}
		
		private function showCard(evt:SomebodyLikeEvent):void {
			if ( evt.player.id != _game.currentPlayer.id ) {
				var OtherPlayerCardImage:CardImage = evt.card;
				var chair:Chair = ChairManager.getByPlayer(evt.player.id);
				var cardImage:CardImage = chair.hand.getRandomCard();
				cardImage.card = OtherPlayerCardImage.card;	
				cardImage.liked = true;
				cardImage.show();
			}
		}
	}
}
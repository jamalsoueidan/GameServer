package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.requests.GameObjectRequest;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.events.ExchangeCardsEvent;
	import com.lekha.events.SomebodyLikeEvent;
	import com.lekha.managers.ChairManager;
	import com.lekha.managers.DealManager;
	
	import custom.*;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import stages.visual.*;

	public class SomebodyLike extends Command implements ICommand
	{
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
			
			_timer = new Timer(1000, 5);
			_timer.addEventListener(TimerEvent.TIMER, timerUpdate, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteChooseQueenOrDiamond, false, 0, true);
			_timer.start();
		}
		
		private function timerUpdate(evt:TimerEvent):void {
			_countDownWithCommentBox.timer = (5 - _timer.currentCount).toString() + " sec"; 
		}
		
		private function timerCompleteChooseQueenOrDiamond(evt:TimerEvent):void {			
			done();
		}
		
		private function chooseQueenOrDiamond(evt:MouseEvent):void {
			var cardImage:CardImage = evt.target as CardImage
			var chair:Chair = ChairManager.getByPlayerSession(_game.currentPlayer.id);
			var cardString:String = cardImage.card.toString();
			
			if ( cardString == "d 10" || cardString == "s 12") {
				cardImage.movement = false; 
				cardImage.liked = true;
				
				/*var point:Point = getPosition(_myChair);
				cardImage.x = point.x;
				cardImage.y = point.y;*/
				
				DealManager.sortCards(chair);
				
				var sendObject:GameObjectRequest = new GameObjectRequest(SomebodyLikeEvent, SomebodyLikeEvent.SHOW_CARD);
				sendObject.addKeyValue("card", cardString);
				_game.send(sendObject);
			} 
		}
		
		private function userIsDone(evt:MouseEvent):void {
			done();
		}
		
		private function done():void {
			if ( _timer ) {			
				removeTimer();
				killEvents();
			
				_countDownWithCommentBox.visible = false;
				
				var sendObject:GameObjectRequest = new GameObjectRequest(SomebodyLikeEvent, SomebodyLikeEvent.IM_READY);
				_game.send(sendObject);
				
				_board.addChild(_waitingForPlayersBox);
			}
		}
		
		private function removeTimer():void {
			if ( _timer ) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerUpdate);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteChooseQueenOrDiamond);
				_timer = null;
			}
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
				var chair:Chair = ChairManager.getByPlayerSession(evt.player.id);
				var cardImage:CardImage = chair.hand.getRandomCard();
				cardImage.card = OtherPlayerCardImage.card;
				//var point:Point = getPosition(chair);	
				cardImage.liked = true;
				
				if ( cardImage.card.toString() == "d 10" ) chair.hand.likedDiamond = true;
				if ( cardImage.card.toString() == "s 12" ) chair.hand.likedQueen = true;
				
				/*cardImage.x = point.x;
				cardImage.y = point.y;*/
				cardImage.show();
				DealManager.sortCards(chair);
			}
		}
		
		private function getPosition(chair:Chair):Point {
			var point:Point = new Point();
			if ( chair.placement == Chair.BOTTOM ) {
				Logger.log("bottom");
				point.x = chair.x + chair.width + DealManager.cardSpace;
				point.y = _board.height - CardImage.HEIGHT - DealManager.cardSpace - 7;
			} else if ( chair.placement == Chair.RIGHT ) {
				Logger.log("right");
				point.x = _board.width - DealManager.cardSpace;
				point.y = chair.y - chair.height - DealManager.cardSpace - 7;
			} else if ( chair.placement == Chair.LEFT ) {
				Logger.log("left");
				point.x = CardImage.HEIGHT + DealManager.cardSpace;
				point.y = chair.y + chair.height + DealManager.cardSpace;
			} else {
				Logger.log("top");
				point.x = chair.x - DealManager.cardSpace - CardImage.WIDTH;
				point.y = DealManager.cardSpace;
			}
			
			return point;
		}
	}
}
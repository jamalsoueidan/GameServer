package com.lekha.stage
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.game.requests.GameObjectRequest;
	import com.greensock.TweenLite;
	import com.lekha.core.LekhaDeck;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.events.CardEvent;
	import com.lekha.events.FindDealerEvent;
	import com.lekha.managers.*;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class FindDealer extends Game implements IStage
	{
		private var _deck:LekhaDeck;
		private var _cards:Array = []; // holds cards on table (CardImages)
		private var _playerChoosenCard:Array = [];
		private var _alreadyChoosenCard:Boolean;
		private var _totalPlayersChoosingCardsOnTable:Number; // can change later if two players or  more have same cards
		
		private var _playerAlreadyChoosedCards:Array = [];
		private var _timerToCheckForChairAnimationDone:Timer;
		
		public function execute():void {
			_game.addEventListener(FindDealerEvent.READY, chooseCards);
			_game.addEventListener(FindDealerEvent.CHOOSEN, showWhichCardPlayerHasChoosen);
			_game.addEventListener(FindDealerEvent.RECHOOSE, allowPlayerRechoose);
			
			_totalPlayersChoosingCardsOnTable = _game.allPlayers.length;
			
			putCardsOnTable();	
		}
		
		public function terminate():void {
			_game.removeEventListener(FindDealerEvent.READY, chooseCards);
			_game.removeEventListener(FindDealerEvent.CHOOSEN, showWhichCardPlayerHasChoosen);
			_game.removeEventListener(FindDealerEvent.RECHOOSE, allowPlayerRechoose);
			
			for each(var cardImage:CardImage in _cards ) {
				cardImage.removeEventListener(CardEvent.VISIBLE, sendCardToOtherPlayers);
				_board.removeChild(cardImage);
			}
			
			_board.mouseChildren = true;
			_cards = null;
			_timerToCheckForChairAnimationDone = null;
		}
		
		private function allowPlayerRechoose(evt:FindDealerEvent):void {
			var object:Object = evt.object;
			var players:Array = object["players"];
			for each(var session:Number in players ) {
				if ( session == _game.currentPlayer.id ) {
					Alert.show("Please choose a new card, since you had the same card as another player");
					_alreadyChoosenCard = false;	
					_board.mouseChildren = true;
				}
			}
			
			_totalPlayersChoosingCardsOnTable = players.length;
		}
		
		private function chooseCards(evt:FindDealerEvent):void {
			var cardImage:CardImage;
			var cardsToChooseFrom:Number = 30;
			var positionX:Number = ((Application.application.width/2) - ((17*cardsToChooseFrom)/2)) - 30; // 17 is space and 40 is cards on table to choose from and 30 is half of the card size
			//for each(var card:Card in evt.cards ) {
			
			for(var i:int = 0; i<cardsToChooseFrom; i++ ) {
				cardImage = CardManager.cardToImage(evt.cards[i]);
				cardImage.x = positionX;
				cardImage.y = (Application.application.height/2) - (96/2);
				positionX += 17;
				cardImage.addEventListener(CardEvent.VISIBLE, sendCardToOtherPlayers);
				_cards.push(cardImage);
				_board.addChild(cardImage);	
			}
		}
		
		private function startTimer():void {
			_timerToCheckForChairAnimationDone = new Timer(1000, 5);
			_timerToCheckForChairAnimationDone.addEventListener(TimerEvent.TIMER, function():void {
				var chair:Chair = ChairManager.getByPlayerSession(_playerAlreadyChoosedCards[0].player.id);
				Logger.log("Start animation as we just recieved a card!");
				if ( !chair.isAllowedMovement() ) {
					_timerToCheckForChairAnimationDone.stop();
					for each( var evt:FindDealerEvent in _playerAlreadyChoosedCards ) {
						showWhichCardPlayerHasChoosen(evt);
					}
				}		
			}, false, 0, true);
			_timerToCheckForChairAnimationDone.start();
		}
			
		private function showWhichCardPlayerHasChoosen(evt:FindDealerEvent):void {
			
			var chair:Chair = ChairManager.getByPlayerSession(evt.player.id);
			if ( chair.isAllowedMovement() ) {
				Logger.log("Received to early card, animation is NOT complete");
				_playerAlreadyChoosedCards.push(evt);
				startTimer();
				return;
			}
			var cardImage:CardImage = findCardInHolder(evt.cardString);
			cardImage.show();
			cardImage.lock();
			
			var point:Object = getPosition(chair);
			_board.addChild(cardImage); // DONT REMOVE THIS!
			/*cardImage.x = point.x;
			cardImage.y = point.y;
			cardImage.rotation = point.rotation;*/
			cardImage.cacheAsBitmap = true;
			TweenLite.to(cardImage, 1, {x:point.x, y:point.y, rotation:point.rotation});
			
			if ( !_game.isOwner ) {
				return;
			} 
			
			var player:Player = evt.player;
			player.addAttribute("cardImage", cardImage);
			_playerChoosenCard.push(player);
			
			checkAllPlayersChoosenCards();
		}
		
		private function getPosition(chair:Chair):Object {
			var point:Object = new Object();
			if ( chair.placement == Chair.BOTTOM ) {
				//Logger.log("bottom");
				point.x = chair.x + chair.width + DealManager.cardSpace;
				point.y = _board.height - CardImage.HEIGHT - DealManager.cardSpace - 7;
			} else if ( chair.placement == Chair.RIGHT ) {
				//Logger.log("right");
				point.x = _board.width - DealManager.cardSpace;
				point.y = chair.y - CardImage.WIDTH - DealManager.cardSpace;
				point.rotation = 90;
			} else if ( chair.placement == Chair.LEFT ) {
				//Logger.log("left");
				point.x = CardImage.HEIGHT + DealManager.cardSpace;
				point.y = chair.y + chair.height + DealManager.cardSpace;
				point.rotation = 90;
			} else {
				//Logger.log("top");
				point.x = chair.x - DealManager.cardSpace - CardImage.WIDTH;
				point.y = DealManager.cardSpace;
			}
			
			return point;
		}
		
		private function checkAllPlayersChoosenCards():void {
			if ( !_game.isOwner ) {
				return;
			} 
			
			Logger.log("checkAllPlayersChoosenCards", _playerChoosenCard.length, _totalPlayersChoosingCardsOnTable);
			
			if ( _playerChoosenCard.length == _totalPlayersChoosingCardsOnTable ) {
				var playersHaveSameCards:Array = [];
				var highestNum:Number;
				var toNum:Number; 
				for each(var player:Player in _playerChoosenCard ) {
					if ( !highestNum ) {
						highestNum = player.getAttribute("cardImage").card.rank.toNumber();
						playersHaveSameCards.push(player);
					} else {
						toNum = player.getAttribute("cardImage").card.rank.toNumber();
						if ( highestNum ==  toNum ){
							playersHaveSameCards.push(player);
							
							highestNum = toNum;
						} else if ( toNum > highestNum ) {
							highestNum = toNum;
							playersHaveSameCards = [];
							playersHaveSameCards.push(player);
						}
					}
				}
				
				_playerChoosenCard = [];
				
				//Logger.log("checkAllPlayersChoosenCards", playersHaveSameCards.length);
				
				if ( playersHaveSameCards.length > 1 ) {
					_totalPlayersChoosingCardsOnTable = playersHaveSameCards.length;
					allowPlayersWithSameCardsToRechooseCards(playersHaveSameCards);
				} else {
					done(playersHaveSameCards[0]);
				}
			}
		}
		
		private function done(playerDealer:Object):void {
			Logger.log("Dealer is found " + playerDealer.name);
			
			_timerToCheckForChairAnimationDone = new Timer(2000, 1);
			_timerToCheckForChairAnimationDone.addEventListener(TimerEvent.TIMER, function():void {
				Logger.log("Send findDealerEvent Complete");
				_timerToCheckForChairAnimationDone.stop();
				var send:GameObjectRequest = new GameObjectRequest(FindDealerEvent, FindDealerEvent.COMPLETE);
				send.addKeyValue("player_id", playerDealer.id);
				_game.send(send);
				});
			_timerToCheckForChairAnimationDone.start();
		}
		
		// send message to the players who have duplicated cards THAt they can now rechoose cards.
		private function allowPlayersWithSameCardsToRechooseCards(players:Array):void {
			var sessions:Array = [];
			
			for each( var player:Player in players ) {
				sessions.push(player.id);
			}
			
			var send:GameObjectRequest = new GameObjectRequest(FindDealerEvent, FindDealerEvent.RECHOOSE);
			send.addKeyValue("players", sessions);
			_game.send(send);
		}
		
		private function findCardInHolder(cardString:String):CardImage {
			for each(var cardImage:CardImage in _cards ) {
				if ( cardImage.card.toString() == cardString ) {
					return cardImage;
					break;
				}
			}
			return null;
		}
		
		// when player choose cards
		private function sendCardToOtherPlayers(evt:CardEvent):void {
			/*if ( _alreadyChoosenCard ) {
				Alert.show("You have already choosen a card, please wait for other to choose card!");
				return;
			}*/
			
			evt.cardImage.lock();
			_board.mouseChildren = false;
			_alreadyChoosenCard = true;
			var sendObject:GameObjectRequest = new GameObjectRequest(FindDealerEvent, FindDealerEvent.CHOOSEN);
			sendObject.addKeyValue("card", evt.cardImage.card.toString());
			_game.send(sendObject);
		}
		
		private function putCardsOnTable():void {
			if ( !_game.isOwner ) {
				return;
			}
			
			_deck = new LekhaDeck();
			_deck.shuffle();
			var request:GameObjectRequest = new GameObjectRequest(FindDealerEvent, FindDealerEvent.READY);
				
			var cards:Array = [];
			for(var i:int = 0;i<_deck.cards.length; i++) {
				cards[i] = _deck.cards[i].toString();
			}
			
			request.addKeyValue("cards", cards);
			_game.send(request);
		}

	}
}
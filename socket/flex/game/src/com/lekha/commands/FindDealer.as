package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.game.utils.TimerLite;
	import com.greensock.TweenLite;
	import com.lekha.core.LekhaDeck;
	import com.lekha.display.CardImage;
	import com.lekha.display.Chair;
	import com.lekha.events.CardEvent;
	import com.lekha.events.FindDealerEvent;
	import com.lekha.managers.*;
	import com.lekha.requests.FindDealerRequest;
	
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	public class FindDealer extends Command implements ICommand
	{
		private static const CARDS_ON_TABLE:Number = 30;
		
		private var _deck:LekhaDeck;
		private var _allCardsOnTable:Array = []; // holds cards on table (CardImages)
		private var _allPlayersChoosenCard:Array = [];
		
		private var _choosenCardObject:FindDealerRequest;
		
		private var _totalPlayersChoosingCardsOnTable:Number; // can be changed later if two players or more have same cards
		
		private var _playerAlreadyChoosedCards:Array = [];
		
		public function execute():void {
			_game.addEventListener(FindDealerEvent.READY, drawAllCardsOnTable);
			_game.addEventListener(FindDealerEvent.CHOOSEN, showWhichCardPlayerHasChoosen);
			_game.addEventListener(FindDealerEvent.RECHOOSE, allowPlayerRechoose);
			
			_totalPlayersChoosingCardsOnTable = _game.allPlayers.length;
			
			ownerCreateDeckAndSendToAllPlayers();	
		}
		
		public function terminate():void {
			_game.removeEventListener(FindDealerEvent.READY, drawAllCardsOnTable);
			_game.removeEventListener(FindDealerEvent.CHOOSEN, showWhichCardPlayerHasChoosen);
			_game.removeEventListener(FindDealerEvent.RECHOOSE, allowPlayerRechoose);
			
			for each(var cardImage:CardImage in _allCardsOnTable ) {
				cardImage.removeEventListener(CardEvent.VISIBLE, sendCardToOtherPlayers);
			}
			
			_board.removeAllChildren();
			_board.mouseChildren = true;
			_allCardsOnTable = null;
		}
		
		private function resendChoosenCard(evt:FindDealerEvent):void {
			if ( _choosenCardObject ) {
				_game.send(_choosenCardObject);
			}
		}
		
		private function allowPlayerRechoose(evt:FindDealerEvent):void {
			var players:Array = evt.players;
			for each(var id:Number in players ) {
				if ( id == _game.currentPlayer.id ) {
					Alert.show("Please choose a new card, since you had the same card as another player");
					
					_choosenCardObject = null;	
					_board.mouseChildren = true;
				}
			}
			
			_totalPlayersChoosingCardsOnTable = players.length;
		}
		
		private function drawAllCardsOnTable(evt:FindDealerEvent):void {
			 Logger.log("allow player to choose cards from table", evt.cards.length);
			 
			var cardImage:CardImage;
			var positionX:Number = ((_board.width/2) - ((17*CARDS_ON_TABLE)/2)); // 17 is space and 40 is cards on table to choose from and 30 is half of the card size

			for(var i:int = 0; i<CARDS_ON_TABLE; i++ ) {
				cardImage = CardManager.cardToImage(evt.cards[i]);
				cardImage.x = positionX;
				cardImage.y = _board.height/2;
				positionX += 17;
				cardImage.addEventListener(CardEvent.VISIBLE, sendCardToOtherPlayers);
				_allCardsOnTable.push(cardImage);
				_board.addChild(cardImage);	
			}
		
		}
			
		private function showWhichCardPlayerHasChoosen(evt:FindDealerEvent):void {
			
			var chair:Chair = ChairManager.getByPlayerSession(evt.player.id);
			var cardImage:CardImage = findCardInHolder(evt.cardString);
			if ( !cardImage ) return;
			
			cardImage.show();
			cardImage.lock();
			
			var point:Object = getPosition(chair);
			_board.addChild(cardImage); // DONT REMOVE THIS!
			cardImage.cacheAsBitmap = true;
			TweenLite.to(cardImage, 1, {x:point.x, y:point.y, rotation:point.rotation});
			
			if ( !_game.isOwner ) {
				return;
			} 
			
			var player:Player = evt.player;
			player.addAttribute("cardImage", cardImage);
			_allPlayersChoosenCard.push(player);
			
			checkAllPlayersChoosenCards();
		}
		
		private function getPosition(chair:Chair):Object {
			var point:Object = new Object();
			if ( chair.placement == Chair.BOTTOM ) {
				point.x = chair.x + chair.width + DealManager.cardSpace + CardImage.HEIGHT/2;
				point.y = _board.height - CardImage.HEIGHT/2 - DealManager.cardSpace - 7;
			} else if ( chair.placement == Chair.RIGHT ) {
				point.x = _board.width - DealManager.cardSpace - CardImage.WIDTH/2;
				point.y = chair.y - CardImage.HEIGHT/2 - DealManager.cardSpace;
			} else if ( chair.placement == Chair.LEFT ) {
				point.x = DealManager.cardSpace + CardImage.WIDTH/2;
				point.y = chair.y + chair.height + DealManager.cardSpace + CardImage.HEIGHT/2;
			} else {
				point.x = chair.x - DealManager.cardSpace - CardImage.WIDTH/2;
				point.y = DealManager.cardSpace + CardImage.HEIGHT/2;
			}
			
			return point;
		}
		
		private function checkAllPlayersChoosenCards():void {
			if ( !_game.isOwner ) {
				return;
			} 
			
			Logger.log("checkAllPlayersChoosenCards", _allPlayersChoosenCard.length, _totalPlayersChoosingCardsOnTable);
			
			if ( _allPlayersChoosenCard.length == _totalPlayersChoosingCardsOnTable ) {
				var playersHaveSameCards:Array = [];
				var highestNum:Number;
				var toNum:Number; 
				for each(var player:Player in _allPlayersChoosenCard ) {
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
				
				_allPlayersChoosenCard = [];
				
				//Logger.log("checkAllPlayersChoosenCards", playersHaveSameCards.length);
				
				if ( playersHaveSameCards.length > 1 ) {
					_totalPlayersChoosingCardsOnTable = playersHaveSameCards.length;
					allowPlayersWithSameCardsToRechooseCards(playersHaveSameCards);
				} else {
					TimerLite.onComplete(done, 2000, 1, {parameter: playersHaveSameCards[0]});
				}
			}
		}
		
		private function done(playerDealer:Object):void {
			Logger.log("Dealer is found " + playerDealer.name);
			_game.send(new FindDealerRequest(FindDealerEvent.COMPLETE, {player_id: playerDealer.id}));
		}
		
		// send message to the players who have duplicated cards THAt they can now rechoose cards.
		private function allowPlayersWithSameCardsToRechooseCards(players:Array):void {
			var sessions:Array = [];
			for each( var player:Player in players ) {
				sessions.push(player.id);
			}
			_game.send(new FindDealerRequest(FindDealerEvent.RECHOOSE, {players: sessions}));
		}
		
		private function findCardInHolder(cardString:String):CardImage {
			for each(var cardImage:CardImage in _allCardsOnTable ) {
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
			
			Logger.log("player choosed this card", evt.cardImage.card.toString());
			evt.cardImage.lock();
			_board.mouseChildren = false;
			_choosenCardObject = new FindDealerRequest(FindDealerEvent.CHOOSEN, {card: evt.cardImage.card.toString()});
			_game.send(_choosenCardObject);
		}
		
		private function ownerCreateDeckAndSendToAllPlayers():void {
			if ( !_game.isOwner ) {
				return;
			}
			
			_deck = new LekhaDeck();
			_deck.shuffle();
				
			var cards:Array = [];
			for(var i:int = 0;i<CARDS_ON_TABLE; i++) {
				cards[i] = _deck.cards[i].toString();
			}
			
			_game.send(new FindDealerRequest(FindDealerEvent.READY, {cards: cards}));
		}

	}
}

package com.lekha.commands
{
	/**
  	* This class handles the chair positions.
  	* <p>Second paragraph of the description.</p>
  	* @author "Jamal Soueidan"
  	*/
  	
	import com.game.requests.*;
	import com.game.utils.TimerLite;
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.lekha.core.*;
	import com.lekha.display.*;
	import com.lekha.engine.*;
	import com.lekha.events.*;
	import com.lekha.requests.TableRequest;
	
	import custom.WaitingForPlayersBox;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.Application;

	public class Table extends Command implements ICommand
	{
		private var _circleChairTimes:Number = 0;
		private var _playersReady:Number = 0;
		private var _waiting:WaitingForPlayersBox;
		
		private static var _instance:Table;
				
		public function execute():void {
			_instance = this;
			
			_game = LekhaGame.getInstance();
			_game.addEventListener(TableEvent.CHOOSEN, chairIsChoosen);
			_game.addEventListener(TableEvent.REMOVED, chairIsChoosen);
			_game.addEventListener(TableEvent.READY, chairPositionReady);
			
			_board.addEventListener(MouseEvent.CLICK, removeMyPosition);
			
			createChairInstancesAndAddEvent();
			
			TimerLite.onComplete(autoChair, 1500, 1);
		}
		
		public function terminate():void {
			_game.removeEventListener(TableEvent.CHOOSEN, chairIsChoosen);
			_game.removeEventListener(TableEvent.REMOVED, chairIsChoosen);
			_game.removeEventListener(TableEvent.READY, chairPositionReady);
			
			_board.removeChild(_waiting);
			
			destroyChairMouseEvent();
		}
		
		private function destroyChairMouseEvent():void {
			for each( var chair:Chair in allChairs ) {
				chair.removeEventListener(MouseEvent.CLICK, clickedOnChair);
			}
		}
		
		
		private function autoChair():void {
			var autoChair:Boolean = Application.application.parameters["auto_chair"];
			if ( autoChair ) {
				_game.send(new TableRequest(TableEvent.CHOOSEN, {position: _game.currentRoom.joinedPlayers}));
			}	
		}


		private function createChairInstancesAndAddEvent():void {
			var chair:Chair;			
			for each( var placement:String in Chair.PLACEMENTS ) {
				chair = new Chair();
				chair.addEventListener(MouseEvent.CLICK, clickedOnChair);
				chair.placement = placement;
				_chairChild.addChild(chair);
			}
		}	
		
		private function clickedOnChair(evt:MouseEvent):void {
			var currentChair:Chair = evt.target as Chair;
			if ( currentChair.player.id == _game.currentPlayer.id ) {
				return;
			}
			
			if ( currentChair.player.id > 0 ) {
				Alert.show("Chair is already taken, choose another one");
				return;
			}
			
			_game.send(new TableRequest(TableEvent.CHOOSEN, {position: currentChair.position}));
		}
		
		private function chairPositionReady(evt:TableEvent):void {	
			_playersReady++;
			
			if ( _playersReady == _game.allPlayers.length ) {
				_game.dispatchEvent(new TableEvent(TableEvent.COMPLETE));		
			}
		}
		
		private function removeMyPosition(evt:MouseEvent):void {
			if ( evt.target is Board ) {
				_game.send(new TableRequest(TableEvent.REMOVED, {position: 0}));
			}
		}
		
		private function chairIsChoosen(evt:TableEvent):void {
			removeOldPlayerPositionIfAny(evt.player);
			
			var chair:Chair = allChairs[evt.position-1];
			chair.player = evt.player;
			
			if ( evt.player.id == _game.currentPlayer.id ) {
				_myChair = chair;
				_myChair.hand.owner = true;
			}
			
			var playerReady:Number = howManyPlayersIsReady();
			if ( playerReady == _game.allPlayers.length ) {
				addWaitASecMessage();
				moveMyChairToBottom();
			}
		}
		
		private function addWaitASecMessage():void {
			_board.removeEventListener(MouseEvent.CLICK, removeMyPosition);
			_board.removeAllChildren();
				
			_waiting = new WaitingForPlayersBox();
			_waiting.text = "Waiting a sec...";
			_board.addChild(_waiting);
		}
		
		private function howManyPlayersIsReady():Number {
			var playerReady:Number = 0;
			for each( var chair:Chair in allChairs ) {
				if ( chair.player.id > -1) {
					playerReady++;
				}
			}
			return playerReady;
		}
		
		private function removeOldPlayerPositionIfAny(player:Object):void {
			for each( var chair:Chair in allChairs ) {
				if ( chair.player.id == player.id ) {
					chair.player = null;
				}
			}
		}
		
		private function moveMyChairToBottom():void {
			if ( _myChair.position != 1 ) {
				_circleChairTimes = 5 - _myChair.position; 
			}
			
			moveChairs();
		}
		
		private function moveChairs():void {			
			if ( _circleChairTimes < 1 ) {
				lockChairMovements();
				_game.send(new TableRequest(TableEvent.READY));
				return;
			}	
			
			_circleChairTimes--;
			moveChairPlacements();
				
			new TimelineLite({tweens:[new TweenLite(allChairs[0], 1, {x:allChairs[1].x, y:allChairs[1].y}), new TweenLite(allChairs[1], 1, {x:allChairs[2].x, y:allChairs[2].y}), new TweenLite(allChairs[2], 1, {x:allChairs[3].x, y:allChairs[3].y}), new TweenLite(allChairs[3], 1, {x:allChairs[0].x, y:allChairs[0].y})], align:TweenAlign.START, onComplete:moveChairs});
		}
		
		private function lockChairMovements():void {
			for each( var chair:Chair in allChairs ) {
				chair.lockPosition();
			}	
		}
		
		private function moveChairPlacements():void {
			for each( var chair:Chair in allChairs ) {
				chair.movePlacement();
			}
		}
	}
}
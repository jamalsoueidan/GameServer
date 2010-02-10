package com.lekha.stage
{
	/**
  	* This class handles the chair positions.
  	* <p>Second paragraph of the description.</p>
  	* @author "Jamal Soueidan"
  	*/
  	
	import com.firebug.logger.Logger;
	import com.game.requests.*;
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.lekha.core.*;
	import com.lekha.display.*;
	import com.lekha.engine.*;
	import com.lekha.events.*;
	
	import flash.events.MouseEvent;

	public class Table extends Game implements IStage
	{
		private var _game:LekhaGame;
		private var _circleChairTimes:Number = 0;
		
		private static var _instance:Table;
		
		public function execute():void {
			_instance = this;
			
			_game = LekhaGame.getInstance();
			_game.addEventListener(ChairEvent.CHOOSEN, chairIsChoosen);
			_game.addEventListener(ChairEvent.REMOVED, chairIsChoosen);
			_game.addEventListener(ChairEvent.READY, chairPositionReady);
			
			_board.addEventListener(MouseEvent.CLICK, clickedTable);
			
			var chair:Chair;			
			for each( var placement:String in Chair.PLACEMENTS ) {
				chair = new Chair();
				chair.placement = placement;
				_board.addChild(chair);
			}
		}
		
		public function terminate():void {

		}
		
		
		private function chairPositionReady(evt:ChairEvent):void {
			
			setChairToGreenReady(evt);
			
			//var fromPlayer:Player = evt.player;
			
			var positionTaken:Number = 0;
			for each( var chair:Chair in _chairs ) {
				if ( chair.player.getAttribute("ready") == true) {
					positionTaken++;
				}
			}
			
			if ( positionTaken == _game.allPlayers.length ) {
				_game.removeEventListener(ChairEvent.CHOOSEN, chairIsChoosen);
				_game.removeEventListener(ChairEvent.REMOVED, chairIsChoosen);
				_game.removeEventListener(ChairEvent.READY, chairPositionReady);
				
				_board.removeEventListener(MouseEvent.CLICK, clickedTable);
				
				_game.dispatchEvent(new ChairEvent(ChairEvent.COMPLETE));
				
				reOrderChairs();
			}
		}
		
		private function setChairToGreenReady(evt:ChairEvent):void { 
			for each( var chair:Chair in _chairs ) {
				if ( chair.player.id == evt.player.id ) {
					chair.setStyle("backgroundColor", "#0BF231");
					chair.player.addAttribute("ready", true);
				}
			}
		}
		
		private function clickedTable(evt:MouseEvent):void {
			if ( evt.target is Board ) {
				var sendObject:GameObjectRequest = new GameObjectRequest(ChairEvent, ChairEvent.REMOVED);
				sendObject.addKeyValue("position", 0);
				_game.send(sendObject);
			}
		}
		
		private function chairIsChoosen(evt:ChairEvent):void {
			if ( evt.position == 0 ) {
				removePlayerPositions(evt.player);
				return;
			}
			
			var chair:Chair = _chairs[evt.position-1];
			chair.player = evt.player;
			
			if ( evt.player.id == _game.currentPlayer.id ) {
				_myChair = chair;
			}
			
			var currentPosition:Number = chair.position;
			var currentPlayerSession:Number = chair.player.id;
			
			// remove old chair position the player had, if he had any?
			for each( chair in _chairs ) {
				if ( chair.position != currentPosition ) {
					if ( chair.player.id == currentPlayerSession ) {
						chair.player = null;
					}
				}
			}
		}
		
		private function removePlayerPositions(player:Object):void {
			for each( var chair:Chair in _chairs ) {
				if ( chair.player.id == player.id ) {
					chair.player = null;
				}
			}
		}
		
		private function reOrderChairs():void {
			var chair:Chair;
			for each(chair in _chairs ) {
				if ( chair.player ) {
					if ( chair.player.id == _game.currentPlayer.id ) {
						break;
					}
				}
			}
			
			//Logger.log("player position", chair.position);
			
			if ( chair.position != 1 ) {
				_circleChairTimes = 5 - chair.position; 
			}
			
			//Logger.log("move player", _circleChairTimes);
			
			removeStyleFromChairs();
			moveChairs();
		}
		
		private function moveChairs():void {			
			if ( _circleChairTimes <= 0 ) {
				lockChairMovements();
				return;
			}	
			
			_circleChairTimes--;
			moveChairPlacements();
				
			var myTimeline:TimelineLite = new TimelineLite({tweens:[
			new TweenLite(_chairs[0], 1, {x:_chairs[1].x, y:_chairs[1].y}),
			new TweenLite(_chairs[1], 1, {x:_chairs[2].x, y:_chairs[2].y}),
			new TweenLite(_chairs[2], 1, {x:_chairs[3].x, y:_chairs[3].y}),
			new TweenLite(_chairs[3], 1, {x:_chairs[0].x, y:_chairs[0].y})
			], align:TweenAlign.START, onComplete:completedMovingChairs});
		}
		
		private function lockChairMovements():void {
			for each( var chair:Chair in _chairs ) {
				chair.lockMovement();
			}	
		}
		
		private function moveChairPlacements():void {
			for each( var chair:Chair in _chairs ) {
				/*if ( chair.player.session == _game.currentPlayer.session ) {
					Logger.log("before", chair.placement);
				}*/
				chair.movePlacement();
				
				/*if ( chair.player.session == _game.currentPlayer.session ) {
					Logger.log("after", chair.placement);
				}*/
			}
		}
		
		private function removeStyleFromChairs():void {
			for each( var chair:Chair in _chairs ) {
				chair.allowMovement();
			}
		}
		
		private function completedMovingChairs():void {
			moveChairs();
		}
		
	}
}
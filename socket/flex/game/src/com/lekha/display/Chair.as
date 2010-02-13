package com.lekha.display
{
	import com.game.core.Player;
	import com.game.requests.GameObjectRequest;
	import com.lekha.commands.*;
	import com.lekha.core.*;
	import com.lekha.events.*;
	import com.lekha.managers.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.*;
	import mx.events.FlexEvent;

	public class Chair extends ChairDisplay
	{
		public static const LEFT:String = "4";
		public static const TOP:String = "3";
		public static const RIGHT:String = "2";
		public static const BOTTOM:String = "1";
		public static const PLACEMENTS:Array = [BOTTOM, RIGHT, TOP, LEFT];
		
		private var _board:Board;
		
		private var _name:TextField;
		
		private var _placement:String;
		private var _placementChanged:Boolean;
		
		private var _position:Number;
		private var _game:LekhaGame;
		private var _player:Player;
		
		private var _hand:Hand;
		private var _statistic:Statistic;
		
		private var _allowMovement:Boolean;
		
		private static var _chairs:Array = [];
		
		
		private function resetPlayer():void {
			_player = new Player({id:-1, name:""});
		}
		
		public static function getAllChairs():Array {
			return _chairs;
		}
			
		public function get statistic():Statistic {
			return _statistic;
		}
		
		public function Chair() {
			super();
			
			mouseChildren = false;
			
			resetPlayer();
			
			_board = Board.getInstance();
					
			_game = LekhaGame.getInstance();
			_hand = new Hand();
			_hand.parent = Board.getInstance();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			
			_chairs.push(this);
			
			_position = _chairs.length;
			
			_statistic = new Statistic();
			_statistic.addEventListener(Event.CHANGE, statisticChanged);
		}
		
		public function reset():void {
			_hand = new Hand();
		}
		
		private function statisticChanged(evt:Event):void {
			//_button.label = _statistic.total.toString() + " points";
		}
			
		public function set position(value:Number):void {
			_position = value;	
		}
		
		public function get position():Number {
			return _position;
		}
		
		private function creationComplete(evt:FlexEvent):void {			
			this["green"].visible = false;
			this["yellow"].visible = false;
			
			_name = this["player_name"];
			
			setPosition();
		}
		
		public function set player(value:Player):void {
			_player = value;
			
			if ( _player ) {
				_name.text = value.name;
			} else {
				resetPlayer();
				_name.text = "";
			}
			
			this["green"].visible = false;
			this["yellow"].visible = false;
			
			if ( player.id == _game.currentPlayer.id ) {
				this["green"].visible = true;
			} else {
				if ( player.id > 0 ) {
					this["yellow"].visible = true;
				}
			}
		}
		
		public function get player():Player {
			return _player;
		}
		
		public function isEmpty():Boolean {
			if ( _player.id == -1 ) {
				return true;
			}
			return false;
		}
		
		public function set placement(value:String):void {
			_placement = value;
		}
		
		public function get placement():String {
			return _placement;
		}
		
		
		// set placement to null to remove stylish
		public function lockPosition():void {
			setPosition();
		}
		
		private function setPosition():void {
			switch(_placement) {
				case TOP:
					x = _board.width/2 - width/2;
					y = 0;
				break;
				
				case BOTTOM:
					x = _board.width/2 - width/2;
					y = _board.height - height;
				break;
				
				case LEFT:
					x = 0;
					y = _board.height/2 - height/2;
				break;
				
				case RIGHT:
					x = _board.width - width;
					y = _board.height/2 - height/2;
				break;
			}
			
			updateHolderPosition();
		}
		
		private function nextPosition(bp:Number=-1):Number {
			if ( bp == -1 ) {
				bp = position + 1;
			} else {
				bp++;
			}
			
			if ( bp > 4 ) {
				bp = 1;
			} 
			
			return bp;
		}
		
		private function beforePosition(bp:Number=-1):Number {
			if ( bp == -1 ) {
				bp = position - 1;
			} else {
				bp--;
			}
			
			if ( bp < 1 ) {
				bp = 4;
			} 
			
			return bp;
		}
		
		public function nextChair(alsoEmpty:Boolean = false):Chair {
			var currentPosition:Number = nextPosition();
			if ( alsoEmpty ) {
				return _chairs[(currentPosition-1)];
			}
			
			var chair:Chair;
			while(true) {
				chair = _chairs[(currentPosition-1)];
				if ( chair.isEmpty() || player.id == chair.player.id ) {
					currentPosition = nextPosition(currentPosition);
				} else {
					break;
				}
			}
			
			return chair;
		}
		
		public function beforeChair():Chair {
			var currentPosition:Number = beforePosition();
			var chair:Chair = _chairs[(currentPosition-1)];

			while(chair.isEmpty() || player.id == chair.player.id) {
				currentPosition = beforePosition(currentPosition);
				chair = _chairs[(currentPosition-1)];
			}
			return chair;
		}
		
		public function movePlacement():void {
			var placementNum:Number;
			if ( _placement != null ) {
				placementNum = Number(_placement);
				placementNum++;
				if ( placementNum > 4 ) {
					placementNum = 1;
				}
			} else {
				placementNum = nextPosition();
			}
			
			_placement = Chair.PLACEMENTS[(placementNum-1)];
		}
		
		public function get hand():Hand {
			return _hand;
		}
		
		private function updateHolderPosition():void {
			//Logger.log("placement for chair", _placement, player.name);
			var _board:Board = Board.getInstance();
			if ( _placement == TOP || _placement == BOTTOM ) {
				_hand.order = Holder.HORIZONTAL;
				
				_hand.x = (_board.width/2) - (8*DealManager.cardSpace);
				if ( _placement == TOP ) {
					_hand.y = height - CardImage.HEIGHT/2;
				} else {
					_hand.y = y;
				}
			} else {
				_hand.order = Holder.VERTICAL;		
				
				_hand.y = (_board.height/2) - (8*DealManager.cardSpace);
				if ( _placement == LEFT ) {
					_hand.x = width - CardImage.WIDTH/2;	
				} else {
					_hand.x = x + CardImage.WIDTH/2;
				}		
			}
		}
	}
}
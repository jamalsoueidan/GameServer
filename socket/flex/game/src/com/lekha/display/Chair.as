package com.lekha.display
{
	import com.game.core.Player;
	import com.game.requests.GameObjectRequest;
	import com.lekha.core.*;
	import com.lekha.events.*;
	import com.lekha.managers.DealManager;
	import com.lekha.stage.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.*;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class Chair extends VBox
	{
		public static const LEFT:String = "4";
		public static const TOP:String = "3";
		public static const RIGHT:String = "2";
		public static const BOTTOM:String = "1";
		public static const PLACEMENTS:Array = [BOTTOM, RIGHT, TOP, LEFT];
		
		private var _button:Button;
		private var _buttonText:String;
		private var _buttonChanged:Boolean;
		
		private var _name:Text;
		private var _nameText:String;
		private var _nameChanged:Boolean;
		
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
		
		public function isAllowedMovement():Boolean {
			return _allowMovement;
		}
		
		public function Chair() {
			super();
			
			resetPlayer();
			
			setStyle("backgroundColor", "#F21A1A"); 
					
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
			_button.label = _statistic.total.toString() + " points";
		}
			
		public function set position(value:Number):void {
			_position = value;	
		}
		
		public function get position():Number {
			return _position;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_button ) {
				_button = new Button();
				_button.label = "0 points";
				_button.mouseEnabled = _button.mouseChildren = false;
				addChild(_button);
			}
			
			if ( !_name ) {
				_name = new Text();
				_name.mouseEnabled = _name.mouseChildren = false
				_name.text = "Empty";
				addChild(_name);
			}
		}
		
		private function creationComplete(evt:FlexEvent):void {
			_game.addEventListener(ChairEvent.COMPLETE, removeChangePosition);
			
			addEventListener(MouseEvent.CLICK, click);
			
		 	lockMovement();
		}
		
		private function removeChangePosition(evt:ChairEvent):void {
			removeEventListener(MouseEvent.CLICK, click);
			
			_game.removeEventListener(ChairEvent.COMPLETE, removeChangePosition);
		}
		
		private function click(evt:MouseEvent):void {
			if ( player.id == _game.currentPlayer.id ) {
				return;
			}
			
			if ( player.id > 0 ) {
				Alert.show("Chair is already taken, choose another one");
				return;
			}
			
			var sendObject:GameObjectRequest = new GameObjectRequest(ChairEvent, ChairEvent.CHOOSEN);
			sendObject.addKeyValue("position", _position);
			_game.send(sendObject);
			
			player = _game.currentPlayer;
			
		}
		
		public function set player(value:Player):void {
			_player = value;
			
			if ( _player ) {
				//_buttonText = value.session;
				_nameText = value.name;
			} else {
				
				resetPlayer();
				setStyle("backgroundColor", "#F21A1A");
				
				_buttonText = "Button";
				_nameText = "Empty chair";
			}
			
			//_buttonChanged = true;
			_nameChanged = true;
			
			invalidateProperties();
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
			_placementChanged = true;
			invalidateDisplayList();
		}
		
		public function get placement():String {
			return _placement;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if ( _buttonChanged ) {
				_button.label = _buttonText;
				_buttonChanged = false;
			}
			
			if ( _nameChanged ) {
				_name.text = _nameText;
				_nameChanged = false;
			}
		}
		
		// set placement to null to remove stylish
		public function lockMovement():void {
			_allowMovement = false;
			
			updateHolderPosition();
			
			switch(_placement) {
				case TOP:
					setStyle("horizontalCenter", 0);
					setStyle("top", 0);
				break;
				
				case BOTTOM:
					setStyle("horizontalCenter", 0);
					setStyle("bottom", 0);
				break;
				
				case LEFT:
					setStyle("verticalCenter", 0);
					setStyle("left", 0);	
				break;
				
				case RIGHT:
					setStyle("verticalCenter", 0);
					setStyle("right", 0);
				break;
			}
		}
		
		public function allowMovement():void {
			_allowMovement = true;
			
			setStyle("horizontalCenter", null);
			setStyle("verticalCenter", null);
			setStyle("right", null);
			setStyle("left", null);	
			setStyle("bottom", null);
			setStyle("top", null);
		}
		
		override public function invalidateDisplayList():void {
			super.invalidateDisplayList();
			
			if ( _placementChanged ) {
				_placementChanged = false;
				lockMovement();
			}
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
			
			if ( _placement == TOP || _placement == BOTTOM ) {
				_hand.order = Holder.HORIZONTAL;
				
				_hand.x = (Application.application.width/2) - (8*DealManager.cardSpace);
				if ( _placement == TOP ) {
					_hand.y = height + DealManager.cardSpace;	
				} else {
					_hand.y = (Application.application.height - height) - DealManager.cardSpace - CardImage.HEIGHT;
				}
			} else {
				_hand.order = Holder.VERTICAL;		
				
				_hand.y = (Application.application.height/2) - (8*DealManager.cardSpace);
				if ( _placement == LEFT ) {
					_hand.x = width + DealManager.cardSpace + CardImage.HEIGHT;	
				} else {
					_hand.x = x - DealManager.cardSpace;
				}		
			}
		}
	}
}
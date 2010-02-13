package com.lekha.display
{
	import com.lekha.engine.Card;
	import com.lekha.events.CardEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.controls.Image;
	
	public class CardImage extends CardImageSkin
	{
		public static const HEIGHT:Number = 100;
		public static const WIDTH:Number = 70;
		
		private var _shown:Object;
		private var _visible:Boolean = true;
		
		private var _card:Card;
		private var _loader:Loader;
		private var _selected:Boolean;
		
		private var _movement:Boolean;
		
		private var _liked:Boolean;
		
		public function get sort():Number {
			return Board.getInstance().getChildIndex(this);
		}
		
		public function set liked(value:Boolean):void {
			_liked = value;
		}
		
		public function get liked():Boolean {
			return _liked;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set card(value:Card):void {
			_card = value;
		}
		
		public function get card():Card {
			return _card;
		}
		
		public function get isShown():Boolean {
			return _visible;
		}
		
		private function loadCard():void {
			//trace("Load", "assets/png_cards/" + _card.toPath() + ".png");
			
			source = this[_card.toPath()];
			/*_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{ 
				source = _loader.content;
			});
			_loader.load(new URLRequest("assets/png_cards/" +  + ".png"));*/
		}
		
		public function hide():void {
			source = this["hidden"];
			_visible = false;
		}
		
		public function show():void {
			loadCard();
			_visible = true;
		}
		
		public function lock():void {
			movement = false;
			clickable = false;
		}
		
		public function set clickable(value:Boolean):void {
			if ( !value ) {
				removeEventListener(MouseEvent.CLICK, click);
			} else {
				addEventListener(MouseEvent.CLICK, click, false, 0, true);
			}
		}
		
		public function set movement(value:Boolean):void {
			_movement = value;
			if ( !value ) {
				removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);	
			} else {
				addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			}
		}
		
		public function CardImage() {
			scaleContent = false;
			movement = true;
			clickable = true;
			mouseChildren = false;
			hide();
			
		}
		
		private function mouseOver(evt:MouseEvent):void {
			if ( _movement ) {
				y -= 10;
			}
		}
		
		private function mouseOut(evt:MouseEvent):void {
			if ( _movement ) {
				y += 10;
			}
		}
		
		private function click(evt:MouseEvent):void {
			var event:CardEvent;
			
			if ( _visible ) {
				hide();
				
				event = new CardEvent(CardEvent.HIDDEN);
			} else {
				show();
				y += 10;
				event = new CardEvent(CardEvent.VISIBLE);
			}
			
			event.cardImage = this;
			dispatchEvent(event);
		}
	}
}
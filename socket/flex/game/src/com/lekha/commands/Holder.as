package com.lekha.commands
{
	import com.firebug.logger.Logger;
	import com.greensock.*;
	import com.lekha.display.CardImage;
	
	import mx.core.UIComponent;
	
	public class Holder
	{
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		
		public var order:String = HORIZONTAL; 
		
		private var _list:Object = {}; // all objects
		private var _indexs:Number = 13;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _children:Number = 0;
		
		private var _parent:UIComponent; // where the children uicomponent is located
		
		private var _spaceBetween:Number = 17;
		private var _owner:Boolean;
		
		public function get rectangle():Number {
			return _children*_spaceBetween;
		}
		
		public function get width():Number {
			return _children*_spaceBetween;
		}
		
		public function get height():Number {
			return _children*_spaceBetween;
		}
		public function get total():Number {
			return _children;
		}
		
		public function set parent(value:UIComponent):void {
			_parent = value;
		}
				
				
		public function set owner(value:Boolean):void {
			_owner = value;
			_spaceBetween = 22;
		}
		
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
		}
		
		
		public function add(uicomponent:UIComponent):void {
			var index:Number = findIndex();
			addAtIndex(uicomponent, index);
		}
		
		public function addAtIndex(uicomponent:UIComponent, index:Number, force:Boolean=false):void {
			if ( !force ) {
				if ( _list[index] ) {
					return;
				}
			}
			
			if ( index == -1 ) {
				throw new Error("No more space in the hand");
			}
			
			_list[index] = uicomponent;
			_children++;
			animate(uicomponent, index); 
		}
		
		public function remove(uicomponent:UIComponent):void {
			var cardImage:CardImage = uicomponent as CardImage;
			for( var i:int=0; i<_indexs; i++) {
				if ( _list[i] && _list[i].card.toString() == cardImage.card.toString()  ) {
					//Logger.log("removed uicomponent from holder", _list[i].card.toString());
					_children--;
					_list[i] = null;
					
					centerObjects();
				}
			}
		}
		
		private function centerObjects():void {
			var foundChildren:Number = Math.ceil(_children/2);
			var totalChildren:Number = Math.ceil(_indexs/2);
			
			var startIndex:Number = totalChildren - foundChildren;
			var currentIndex:Number = startIndex;
			for( var i:int = 0;i < _indexs; i++) {
				if ( _list[i] ) {
					TweenLite.to(_list[i], 1,  position(currentIndex));
					currentIndex++
				}
			}
			
			Logger.log("found", foundChildren, totalChildren, startIndex);
		}
		
		public function removeAtIndex(uicomponent:UIComponent, index:Number):void {
			if ( _list[index] ) {
				_list[index] = null;
				_children--;
			}
			
		}
		
		public function getAtIndex(index:Number):UIComponent {
			return _list[index];	
		}
		
		public function isEmpty():Boolean {
			return ( _children == 0 ? true : false );
		}
		
		public function clear():void {
			_list = {};
			_children = 0;
		}
		
		private function animate(uicomponent:UIComponent, index:Number):void {
			addChildren(uicomponent, index);
			var vars:Object = position(index);
			if ( !_owner ) {
				vars.scaleX = vars.scaleY = .7
			} else {
				vars.scaleX = vars.scaleY = 1.2
			}
			
			TweenLite.to(uicomponent, 1,  vars);
		}
		
		private function position(index:Number):Object {
			var xPosition:Number = _x;
			
			if ( order == HORIZONTAL ) {
				if ( index > 0 ) {
					xPosition = _x+(_spaceBetween*index);
				}
			}
			
			var yPosition:Number = _y;
			if ( order == VERTICAL ) {
				if ( index > 0 ) {
					yPosition = _y+(_spaceBetween*index);
				}
			}
			
			var rPosition:Number = 0;
			if ( order == VERTICAL ) {
				rPosition = 90;
			}
			
			return {x:xPosition, y:yPosition, rotation:rPosition};
		}
		
		private function getIndexBefore(beforeIndex:Number):Number {
			beforeIndex--;
			while(!_list[beforeIndex]&&beforeIndex>-1) {
				beforeIndex--;
			}
			
			return beforeIndex;
		}
		
		private function getIndexAfter(afterIndex:Number):Number {
			afterIndex++;
			while(!_list[afterIndex]&&afterIndex<_children) {
				afterIndex++;
			}
			return afterIndex;
		}
		
		private function addChildren(uicomponent:UIComponent, index:Number):void {
			if ( _children > 1 ) {
				var beforeIndex:Number = getIndexBefore(index);
				var afterIndex:Number = getIndexAfter(index);
				var childIndex:Number;
			
				if ( _list[beforeIndex] ) {
					
					childIndex = _parent.getChildIndex(_list[beforeIndex]) + 1;
					_parent.addChildAt(uicomponent, childIndex);
					
					if (_list[afterIndex]) {
						addChildren(_list[afterIndex], afterIndex);
					}  
				} else if (_list[afterIndex]) {
					childIndex = _parent.getChildIndex(_list[afterIndex]) - 1;
					_parent.addChildAt(uicomponent, childIndex)
				}
			}
		}
		
		private function findIndex():Number {
			for( var i:int=0; i<_indexs; i++) {
				if ( _list[i] == null ) {
					return i;
				}
			}
			return -1;
		}

	}
}
package com.lekha.managers
{
	import com.firebug.logger.Logger;
	import com.lekha.commands.DealCards;
	import com.lekha.display.Board;
	import com.lekha.display.Chair;
	
	public class ChairManager
	{
		public static function getPlacement(chair:Chair):String {
			var middlePoint:Number = Board.getInstance().width/2;
			var topCenter:Number = (chair.x + chair.width/2) - middlePoint; 
			 
			var placement:String;
			if ( topCenter <= 1 && topCenter >= 0) {
				if ( chair.y == 0 ) {
					placement = Chair.TOP;
				} else {
					placement = Chair.BOTTOM;
				}
			} else {
				if ( chair.x == 0 ) {
					placement = Chair.LEFT;
				} else {
					placement = Chair.RIGHT;
				}
			}
			
			Logger.log(placement, chair.x, chair.y);
			 
			return placement;
		}

		public static function getByPosition(position:Number):Chair {
			for each( var chair:Chair in Chair.getAllChairs() ) {
				if ( chair.position == position ) {
					break;
				}
			}
			
			return  chair;
		}
		
		public static function getByPlayer(id:Number):Chair {
			return getByPosition(getChairPositionByPlayer(id));
		}
		
		public static function getChairPositionByPlayer(id:Number):Number {
			
			for each( var chair:Chair in Chair.getAllChairs() ) {
				if ( chair.player.id == id ) {
					break;
				}
			}
			
			return chair.position;
		}
		
		public static function getDealerChair():Chair {
			return getByPlayer(DealCards.dealerSession);
		}
	}
}
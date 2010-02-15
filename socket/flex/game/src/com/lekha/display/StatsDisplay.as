package com.lekha.display
{
	import com.firebug.logger.Logger;
	
	import flash.text.TextField;
	
	public class StatsDisplay extends Stats
	{
		private static var instance:StatsDisplay;
		
		public static function getInstance():StatsDisplay {
			if ( !instance ) instance = new StatsDisplay();
			return instance;
		}
		
		public function addCount(chair:Chair, count:Number):void {
			var textField:TextField = this["chair_" + chair.placement];
			var extract:Array = getNumbers(chair.placement);
			var count:Number = extract[0] + count;
			
			textField.text = count.toString() + " (" + extract[1] + ")";
		}
		
		private function getNumbers(placement:String):Array {
			var textField:TextField = this["chair_" + placement];
			var text:String = textField.text;
			var value:Array = text.split(" ");
			var currentRoundCount:Number = Number(value[0]);
			var allRoundString:String = value[1].replace("(", "");
			allRoundString = allRoundString.replace(")", "");
			return [currentRoundCount, Number(allRoundString)];
		}
		
		public function update():void {
			for each( var placement:String in Chair.PLACEMENTS ) {
				var textField:TextField = this["chair_" + placement];
				var extract:Array = getNumbers(placement);
				var count:Number = extract[0] + extract[1];
			
				textField.text = "0 (" + count + ")";
			}
		}
		
		public function get doWeHaveLoser():Boolean {
			var count:Number = 0;
			for each( var placement:String in Chair.PLACEMENTS ) {
				var extract:Array = getNumbers(placement);
				if ( extract[1] > count ) {
					count = extract[1];
				}
			}

			if ( count >= 151 ) {
				return true;
			} else {
				return false;
			}
		}
		
		public function getLoserChair():Chair {
			var count:Number = 0;
			var chairPlacement:String;
			for each( var placement:String in Chair.PLACEMENTS ) {
				var textField:TextField = this["chair_" + placement];
				var extract:Array = getNumbers(placement);
				if ( extract[1] > count ) {
					count = extract[1];
					chairPlacement = placement;
				}
			}
			
			for each( var chair:Chair in Chair.getAllChairs() ) {
				if ( chair.placement == chairPlacement ) {
					break;
				}
			}
			
			return chair;
		}
	}
}
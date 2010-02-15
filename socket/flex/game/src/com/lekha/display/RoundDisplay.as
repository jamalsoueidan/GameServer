package com.lekha.display
{
	import com.game.utils.TimerLite;
	
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class RoundDisplay extends Round
	{
		private static var instance:RoundDisplay;
		private var _timer:Timer;
		
		public static function getInstance():RoundDisplay {
			if ( !instance ) instance = new RoundDisplay();
			return instance;
		}
		
		public function RoundDisplay():void {
			TimerLite.onRepeat(updateTime, 1000, 999999, {parameter:"self"});	
		}
		
		private function updateTime(timer:Timer):void {
			var textField:TextField = this["time"];
			if ( textField ) {
				var currentCount:Number = timer.currentCount;
				var currentTimer:String;
				if ( currentCount < 10 ) {
					currentTimer = "00:0" + currentCount.toString();
				} else {
					currentTimer = "00:" + currentCount.toString();
				}
				
				if ( timer.currentCount >= 60 ) {
					currentCount = timer.currentCount/60;
					currentTimer = "0" + currentCount.toString().substr(0, 4);
					if ( currentTimer.length == 4 ) {
						currentTimer = currentTimer + "0";
					}
				}
				
				textField.text = currentTimer.replace(".", ":");
			}
		}
		
		public function newRound():void {
			var textField:TextField = this["round"];
			textField.text = String(Number(textField.text) + 1);	
		}
		
		public function setTimeLeft(sec:Number):void {
			_timer = TimerLite.onBoth(repeat, resetTimeLeft, 1000, (sec+1)); 	
			
			this["timeleft"].text = sec + " sec left";
		}
		
		public function resetTimeLeft():void {
			if ( _timer ) {
				_timer.stop();
				_timer = null;
			}
			
			this["timeleft"].text = "";	
		}
		
		private function repeat():void {
			if ( _timer ) {
				var sec:Number = _timer.repeatCount-1 - _timer.currentCount;
				if ( sec > 0 ) {
					this["timeleft"].text = sec + " sec left";
				} else {
					resetTimeLeft();
				}
			}
		}
		
	}
}
package com.game.requests
{
	import flash.utils.getQualifiedClassName;
	
	public class Request
	{
		protected var _object:Object = {};
		
		public function Request():void {
			setRequest();	
		}
		
		private function setRequest():void {
			var packageName:String = getQualifiedClassName(this);
			var className:String = packageName.substr(packageName.lastIndexOf(":") + 1);
			_object["className"] = className;
		}
		
		public function get object():Object {
			return _object;
		}
		
		protected function validateKey(value:String):void {
			if ( value == "className" ) {
				throw new Error("You cannot use className as key in object");
			}
		}

	}
}
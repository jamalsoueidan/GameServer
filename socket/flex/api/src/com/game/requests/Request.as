package com.game.requests
{
	import com.game.utils.ClassUtils;
	
	import flash.utils.getQualifiedClassName;
	
	public class Request
	{
		protected var _object:Object = {};
		
		public function Request():void {
			setRequest();
		}
		
		protected function setRequest():void {
			_object["className"] = ClassUtils.getName(this);
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
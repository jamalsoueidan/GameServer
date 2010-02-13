package com.game.requests
{
	import com.firebug.logger.Logger;
	import com.game.core.Player;
	import com.game.utils.ClassUtils;
	
	public class GameObjectRequest extends Request
	{
		
		public function GameObjectRequest(classDispatcher:Object=null, eventDispatcher:String=null, filter:Object=null):void {
			super();
			
			if ( classDispatcher && eventDispatcher ) {
				this.classDispatcher = classDispatcher;
				this.eventDispatcher = eventDispatcher;
			}
			
			_object["className"] = "GameObjectRequest";
			
			filterObject(filter);
		}
		
		protected function filterObject(value:Object):void {
			if ( value ) {
				for( var key:String in value ) {
					addKeyValue(key, value[key]);
				}	
			}
		}
		
		public function addKeyValue(key:String, value:*):void {
			validateKey(key);			
			_object[key] = value;
		}
		
		public function toPlayer(player:Player):void {
			_object["to_player_id"] = player.id;
		}
		
		public function set classDispatcher(object:Object):void {
			_object["classDispatcher"] = ClassUtils.getNameWithPackage(object);
		}
		
		public function set eventDispatcher(value:String):void {
			_object["eventDispatcher"] = value;
		}
		
		public function set object(object:Object):void {
			for each(var key:String in object ) {
				validateKey(key);
				_object[key] = object[key];
			}
		}
		
	}
}
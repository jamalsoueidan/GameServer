package com.game.utils
{
	import flash.utils.getQualifiedClassName;
	
	public class ClassUtils
	{
		public static function getName(value:Object):String {
			var packageName:String = getQualifiedClassName(value);
			var className:String = packageName.substr(packageName.lastIndexOf(":") + 1);
			return className;
		}
		
		public static function getNameWithPackage(value:Object):String {
			var packageName:String = getQualifiedClassName(value);
			return packageName.replace("::", ".");
		}

	}
}
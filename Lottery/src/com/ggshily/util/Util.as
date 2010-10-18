package com.ggshily.util
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class Util
	{
		public function Util()
		{
		}
//		public static function getMC(addEventListener:String) : MovieClip
//		{
//			return new Class(getDefinitionByName(addEventListener));
//		}// end function
		
		public static function addEventListener(param1:EventDispatcher, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = true) : void
		{
			param1.addEventListener(param2, param3, param4, param5, param6);
			return;
		}// end function
	}
}
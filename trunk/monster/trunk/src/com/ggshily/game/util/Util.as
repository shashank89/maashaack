package com.ggshily.game.util
{
	import flash.events.EventDispatcher;

	public class Util
	{
		public static const HOUR_MS : Number = 24 * 60 * 60 * 1000;
		
		public function Util()
		{
		}
		
		public static function removeFromVector(vector : Vector.<Object>, element : Object) : void
		{
			var index : int = vector.indexOf(element);
			if(index >= 0)
			{
				vector.splice(index, 1);
			}
		}
		
		public static function addEventListener(dispatcher : EventDispatcher, event : String, callback : Function) : void
		{
			dispatcher.addEventListener(event, callback, false, 0, true);
		}
	}
}
package com.ggshily.util
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;

	public class Util
	{
		
		public static function addEventListener(dispathcher : EventDispatcher, type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void
		{
			dispathcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function getMC(name : String) : MovieClip
		{
			return new (Class(getDefinitionByName(name)))();
		}
	}
}
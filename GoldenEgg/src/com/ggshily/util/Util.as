package com.ggshily.util
{
	import flash.events.EventDispatcher;

	public class Util
	{
		
		public static function AddEventListener(dispathcher : EventDispatcher, type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void
		{
			dispathcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
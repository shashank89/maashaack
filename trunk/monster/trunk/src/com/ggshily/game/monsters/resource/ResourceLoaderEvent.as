package com.ggshily.game.monsters.resource
{
	import flash.events.Event;
	
	public class ResourceLoaderEvent extends Event
	{
		public static const COMPLETE : String = "COMPLETE";
		
		public function ResourceLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.ggshily.game.monsters.resource
{
	import flash.events.Event;
	
	public class ResourceFileEvent extends Event
	{
		public static const COMPLETE : String = "COMPLETE";
		
		public function ResourceFileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
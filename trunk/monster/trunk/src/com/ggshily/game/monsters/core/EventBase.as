package com.ggshily.game.monsters.core
{
	import flash.events.Event;
	
	public class EventBase extends Event
	{
		public function EventBase(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function process(world : WorldBase) : void
		{
			
		}
	}
}
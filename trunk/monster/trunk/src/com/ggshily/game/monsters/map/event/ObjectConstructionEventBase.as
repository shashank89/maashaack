package com.ggshily.game.monsters.map.event
{
	import com.ggshily.game.monsters.map.GameMap;
	
	import flash.events.Event;
	
	public class ObjectConstructionEventBase extends Event
	{
		public static const PRODUCED_MONSTER : String = "PRODUCED_MONSTER";
		
		public function ObjectConstructionEventBase(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function process(gameMap : GameMap) : void
		{
			
		}
	}
}
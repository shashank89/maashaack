package com.ggshily.game.monsters.map.event
{
	import com.ggshily.game.monsters.core.EventBase;
	
	public class GameMapEvent extends EventBase
	{
		public static const SELECT_BUILDING : String = "SELECT_BUILDING";
		
		public function GameMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
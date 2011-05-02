package com.ggshily.game.monsters.map.event
{
	import com.ggshily.game.monsters.core.EventBase;
	
	public class GameMapEvent extends EventBase
	{
		public static const SELECT_BUILDING : String = "SELECT_BUILDING";
		public static const SHOW_BUILDING_MENU : String = "SHOW_BUILDING_MENU";
		public static const HIDE_BUILDING_MENU : String = "HIDE_BUILDING_MENU";
		
		public function GameMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.EventBase;
	
	public class PanelMainInfoEvent extends EventBase
	{
		public static const CLICK_BUILD_BUTTON : String = "CLICK_BUILD_BUTTON";
		public static const CLICK_MAP_BUTTON : String = "CLICK_MAP_BUTTON";
		public static const CLICK_STROE_BUTTON : String = "CLICK_STROE_BUTTON";
		
		public function PanelMainInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
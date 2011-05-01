package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.EventBase;

	public class PanelConstructionShopEvent extends EventBase
	{
		public static const BUILD_CONSTRUCTION : String = "BUILD_CONSTRUCTION";
		
		public function PanelConstructionShopEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
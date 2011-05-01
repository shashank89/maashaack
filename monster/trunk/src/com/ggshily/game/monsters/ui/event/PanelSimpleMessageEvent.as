package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;

	public class PanelSimpleMessageEvent extends PanelEvent
	{
		public static const CLOSE : String = "CLOSE_SIMPLE_MESSAGE_PANEL";
		
		public function PanelSimpleMessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
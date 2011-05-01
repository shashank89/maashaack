package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.EventBase;
	
	public class PanelEvent extends EventBase
	{
		public static const HIDE : String = "HIDE";
		
		public function PanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
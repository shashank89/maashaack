package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;

	public class PanelMainInfoEventOpenMap extends PanelMainInfoEvent
	{
		public function PanelMainInfoEventOpenMap()
		{
			super(CLICK_MAP_BUTTON, false, false);
		}
		
		override public function process(world:WorldBase):void
		{
			trace("process open map");
		}
	}
}
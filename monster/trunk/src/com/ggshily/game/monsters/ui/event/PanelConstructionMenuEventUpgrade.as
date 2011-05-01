package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;

	public class PanelConstructionMenuEventUpgrade extends PanelConstructionMenuEvent
	{
		public function PanelConstructionMenuEventUpgrade()
		{
			super(UPGRADE);
		}
		
		override public function process(world:WorldBase):void
		{
			trace("process upgrade event");
		}
	}
}
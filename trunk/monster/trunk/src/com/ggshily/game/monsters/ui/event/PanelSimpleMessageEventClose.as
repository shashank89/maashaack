package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.PanelBase;

	public class PanelSimpleMessageEventClose extends PanelSimpleMessageEvent
	{
		private var _panel : PanelBase;
		
		public function PanelSimpleMessageEventClose(panel : PanelBase)
		{
			super(CLOSE);
			
			_panel = panel;
		}
		
		
		override public function process(world:WorldBase):void
		{
			world.hidePanel(_panel);
		}
	}
}
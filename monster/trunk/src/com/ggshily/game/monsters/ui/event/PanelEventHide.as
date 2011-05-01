package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.PanelBase;

	public class PanelEventHide extends PanelEvent
	{
		private var _panel : PanelBase;
		
		public function PanelEventHide(panel : PanelBase)
		{
			super(HIDE);
			
			_panel = panel;
		}
		
		override public function process(world:WorldBase):void
		{
			world.hidePanel(_panel);
			_panel = null;
		}
	}
}
package com.ggshily.game.monsters.ui.button
{
	import com.ggshily.game.monsters.ui.ButtonBase;
	import com.ggshily.game.monsters.ui.PanelBase;
	import com.ggshily.game.monsters.ui.event.PanelEventHide;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonClose extends ButtonBase
	{
		public function ButtonClose(button:MovieClip, panel:PanelBase)
		{
			super(button, panel);
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			_panel.dispatchEvent(new PanelEventHide(_panel));
		}
	}
}
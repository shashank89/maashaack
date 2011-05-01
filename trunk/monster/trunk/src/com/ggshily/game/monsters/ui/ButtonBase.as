package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.util.Util;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ButtonBase
	{
		protected var _panel : PanelBase;
		
		public function ButtonBase(button : MovieClip, panel : PanelBase)
		{
			_panel = panel;
			
			button.mouseChildren = false;
			button.buttonMode = true;
			button.gotoAndStop(1);
			
			Util.addEventListener(button, MouseEvent.CLICK, clickHandler);
		}
		
		protected function clickHandler(e : MouseEvent) : void
		{
			
		}
	}
}
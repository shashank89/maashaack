package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.core.ObjectBase;
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.event.PanelEvent;
	import com.ggshily.game.util.Util;

	public class PanelBase extends ObjectBase
	{
		protected var _isShowing : Boolean;
		
		public function PanelBase(world : WorldBase)
		{
			super();
			
			world.addEvent(this, PanelEvent.HIDE);
		}
		
		protected function init() : void
		{
			
		}
		
		public function show() : void
		{
			init();
			_displayContent.visible = true;
			_isShowing = true;
		}
		
		public function hide() : void
		{
			_isShowing = false;
			
			_displayContent.visible = false;
		}

		public function get isShowing():Boolean
		{
			return _isShowing;
		}

	}
}
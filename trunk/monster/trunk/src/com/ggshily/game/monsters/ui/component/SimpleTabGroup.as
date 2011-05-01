package com.ggshily.game.monsters.ui.component
{
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SimpleTabGroup
	{
		private var _tabs : Vector.<MovieClip>;
		private var _updateCallback : Function;
		private var _currentIndex : int;
		
		public function SimpleTabGroup(updateCallback : Function)
		{
			_tabs = new Vector.<MovieClip>();
			_updateCallback = updateCallback;
		}
		
		public function addTab(button : MovieClip, isDefault : Boolean = false) : int
		{
			UIUtil.setButtonMode(button);
			
			Util.addEventListener(button, MouseEvent.CLICK, clickHandler);
			
			var index : int = _tabs.push(button) - 1;
			
			if(isDefault)
			{
				_currentIndex = index;
//				UIUtil.setButtonSelected(button, true);
			}
			
			return index;
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			var currentButton : MovieClip = e.currentTarget as MovieClip;
			
			for(var i : int = 0; i < _tabs.length; ++i)
			{
				var button : MovieClip = _tabs[i];
				if(button != currentButton)
				{
//					UIUtil.setButtonSelected(button, false);
				}
				else if(_currentIndex != i)
				{
					_currentIndex = i;
//					UIUtil.setButtonSelected(button, true);
					_updateCallback(i);
				}
			}
		}

		public function get currentIndex():int
		{
			return _currentIndex;
		}

	}
}
package com.ggshily.game.monsters.ui.component
{
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SimpleScrollButton
	{
		private var _previousButton : MovieClip;
		private var _nextButton : MovieClip;
		private var _currentPageIndex : int;
		private var _totalPageNumber : int;
		private var _updateCallback : Function;
		
		public function SimpleScrollButton(previousButton : MovieClip,
									 nextButton : MovieClip,
									 totalPageNumber : int,
									 updateCallback : Function,
									 initIndex : int = 0)
		{
			UIUtil.setButtonMode(previousButton);
			UIUtil.setButtonMode(nextButton);
			
			Util.addEventListener(previousButton, MouseEvent.CLICK, clickHandler);
			Util.addEventListener(nextButton, MouseEvent.CLICK, clickHandler);
			
			_previousButton = previousButton;
			_nextButton = nextButton;
			_totalPageNumber = totalPageNumber;
			_updateCallback = updateCallback;
			_currentPageIndex = initIndex;
			
			setButtonVisible();
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			var button : MovieClip = e.currentTarget as MovieClip;
			
			if(button == _previousButton)
			{
				_currentPageIndex--;
			}
			else if(button == _nextButton)
			{
				_currentPageIndex++;
			}
			
			setButtonVisible();
			_updateCallback(_currentPageIndex);
		}
		
		private function setButtonVisible() : void
		{
			_previousButton.visible = _currentPageIndex > 0;
			_nextButton.visible = _currentPageIndex < _totalPageNumber - 1;
		}

		public function reset(currentPageIndex : int, totalPageNumber : int):void
		{
			_currentPageIndex = currentPageIndex;
			_totalPageNumber = totalPageNumber;
			setButtonVisible();
			_updateCallback(currentPageIndex);
		}

		public function get currentPageIndex():int
		{
			return _currentPageIndex;
		}

	}
}
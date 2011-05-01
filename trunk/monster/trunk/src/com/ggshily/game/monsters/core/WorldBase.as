package com.ggshily.game.monsters.core
{
	import com.ggshily.game.monsters.ui.PanelBase;
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.events.EventDispatcher;

	public class WorldBase extends ObjectBase
	{
		private var _currentPanel : PanelBase;
		private var _panelQuene : Vector.<PanelBase>;
		
		public function WorldBase()
		{
			super();
			_panelQuene = new Vector.<PanelBase>();
		}
		
		public function start() : void
		{
			
		}
		
		public function addEvent(dispatcher : EventDispatcher, type : String) : void
		{
			Util.addEventListener(dispatcher, type, processEvent);
		}
		
		private function processEvent(event : EventBase) : void
		{
			event.process(this);
		}
		
		public function showPanel(panel : PanelBase, forceShow : Boolean = false) : void
		{
			if(forceShow && _currentPanel != null)
			{
				_panelQuene.unshift(_currentPanel);
			}
			if(_currentPanel == null || forceShow)
			{
				_currentPanel = panel;
				if(!panel.isShowing)
				{
					panel.show();
					_displayContent.addChild(panel.displayContent);
				}
			}
			else
			{
				_panelQuene.push(panel);
			}
		}
		
		public function hidePanel(panel : PanelBase) : void
		{
			UIUtil.removeFromParent(panel.displayContent);
			_currentPanel = null;
			if(_panelQuene.length > 0)
			{
				showPanel(_panelQuene.shift());
			}
		}
	}
}
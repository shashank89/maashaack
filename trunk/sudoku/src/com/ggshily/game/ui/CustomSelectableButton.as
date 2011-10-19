package com.ggshily.game.ui
{
	import flash.display.DisplayObject;

	public class CustomSelectableButton extends CustomSimpleButton
	{
		private var _upUnselectState:DisplayObject;
		private var _upSelectState:DisplayObject;
		
		private var _selected:Boolean;
		
		public function CustomSelectableButton(text:String)
		{
			super(text);
			
			_upUnselectState = upState;
			_upSelectState = new ButtonDisplayState(text, upColor, size, 0x0000FF);
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if(_selected)
			{
				upState = _upSelectState;
			}
			else
			{
				upState = _upUnselectState;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
	}
}
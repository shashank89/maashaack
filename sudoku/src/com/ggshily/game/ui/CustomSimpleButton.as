package com.ggshily.game.ui
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class CustomSimpleButton extends SimpleButton
	{
		protected var upColor:uint   = 0xFFCC00;
		protected var overColor:uint = 0xCCFF00;
		protected var downColor:uint = 0x00CCFF;
		protected var size:uint      = 80;
		
		public function CustomSimpleButton(text:String) {
			downState      = new ButtonDisplayState("down", downColor, size);
			overState      = new ButtonDisplayState("over", overColor, size);
			upState        = new ButtonDisplayState("up", upColor, size);
			hitTestState   = new ButtonDisplayState(null, upColor, size);
			//		hitTestState.x = -(size / 4);
			//		hitTestState.y = hitTestState.x;
			useHandCursor  = true;
		}
	}
}
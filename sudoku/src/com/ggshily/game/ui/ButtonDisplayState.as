package com.ggshily.game.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ButtonDisplayState extends Sprite
	{
		private var _bgColor:uint;
		private var _lineColor:uint;
		private var _size:uint;
		
		public function ButtonDisplayState(name:String, bgColor:uint, size:uint, lineColor:uint = 0x000000) {
			_bgColor   = bgColor;
			_lineColor = lineColor;
			_size      = size;
			draw();
			
			if(name != null)
			{
				var tf:TextField = new TextField();
				tf.text = name;
				tf.selectable = false;
				tf.mouseEnabled = false;
				addChild(tf);
			}
		}
		
		private function draw():void {
			graphics.lineStyle(1, _lineColor);
			graphics.beginFill(_bgColor);
			graphics.drawRect(0, 0, _size, _size / 2);
			graphics.endFill();
		}
	}
}
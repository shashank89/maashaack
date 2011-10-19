package com.ggshily.game.ui
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class UIUtil
	{
		public function UIUtil()
		{
		}
		
		public static function getTextField(fontSize:int, multiline:Boolean, size:int):TextField
		{
			var tf:TextField = new TextField();
			tf.multiline = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.width = size;
			tf.height = size;
			
			var font:TextFormat = tf.defaultTextFormat;
			font.size = fontSize;
			
			tf.defaultTextFormat = font;
			
			return tf;
		}
	}
}
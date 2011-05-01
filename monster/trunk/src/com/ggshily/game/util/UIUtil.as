package com.ggshily.game.util
{
	import com.ggshily.game.monsters.ui.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	public class UIUtil
	{
		public function UIUtil()
		{
		}
		
		public static function createTextField(text : String, x : Number, y : Number) : TextField
		{
			var tf : TextField = new TextField();
			tf.text = text;
			tf.x = x;
			tf.y = y;
			
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.border = true;
			
			var format : TextFormat = tf.getTextFormat();
			format.size = 24;
			tf.setTextFormat(format);
			
			return tf;
		}
		
		public static function createButton(name : String, x : Number, y : Number) : Sprite
		{
			var button : Sprite = new Sprite();
			button.x = x;
			button.y = y;
			button.buttonMode = true;
			button.mouseChildren = false;
			button.name = name;
			
			var tf : TextField = createTextField(name, 0, 0);
			button.addChild(tf);
			button.graphics.beginFill(0x0000FF, .8);
			button.graphics.drawRect(0, 0, tf.width, tf.height);
			button.graphics.endFill();
			
			return button;
		}
		
		public static function setButtonMode(button : MovieClip) : void
		{
			button.buttonMode = true;
			button.mouseChildren = false;
		}
		
		public static function scaleTo(displayObject : DisplayObject, width : Number, height : Number) : void
		{
			var scale : Number = Math.min(width / displayObject.width, height / displayObject.height);
			
			displayObject.scaleX = displayObject.scaleY = scale;
		}
		
		public static function removeFromParent(child : DisplayObject) : void
		{
			if(child && child.parent)
			{
				child.parent.removeChild(child);
			}
		}
		
		public static function getDisplayObject(name : String) : DisplayObject
		{
			var cls : Class = getDefinitionByName(name) as Class;
			return new cls();
		}
	}
}
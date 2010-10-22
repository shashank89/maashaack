package com.playfish.game.arena.config
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	public class ConfigGameObject
	{
		private var _className : String;
		
		public function ConfigGameObject()
		{
		}
		
		public function get className():String
		{
			return _className;
		}

		public function set className(value:String):void
		{
			_className = value;
		}

		public function getDisplayContent() : DisplayObject
		{
			return new (getDefinitionByName(className) as Class)();
		}
	}
}
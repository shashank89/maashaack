package com.ggshily.game.monsters.core
{
	import com.ggshily.game.util.UIUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class ObjectBase extends EventDispatcher
	{
		protected var _name : String;
		protected var _displayContent : Sprite;
		
		protected var _children : Array;
		
		public function ObjectBase()
		{
			_displayContent = new Sprite();
			
			_children = new Array();
		}
		
		public function addDisplayChild(child : DisplayObject) : void
		{
			_displayContent.addChild(child);
		}
		
		public function addObjectChild(child : ObjectBase) : void
		{
			_children.push(child);
		}
		
		public function getObjectChild(name : String) : ObjectBase
		{
			for each(var child : ObjectBase in _children)
			{
				if(child._name == name)
				{
					return child;
				}
			}
			return null;
		}
		
		public function get displayContent() : DisplayObjectContainer
		{
			return _displayContent;
		}
		
		public function tick(currentTime : Number) : void
		{
			for each(var child : ObjectBase in _children)
			{
				child.tick(currentTime);
			}
		}
		
		public function destroy() : void
		{
			for each(var child : ObjectBase in _children)
			{
				child.destroy();
			}
			UIUtil.removeFromParent(_displayContent);
			_displayContent = null;
		}
	}
}
package com.playfish.game.arena.object
{
	import com.playfish.game.arena.config.ConfigGameObject;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class GameObject
	{
		private var _config : ConfigGameObject;
		private var _displayContent : DisplayObject;
		private var _id : int = -1;
		private var _x : int;
		private var _y : int;
		private var _isEnemy : Boolean;
		private var _abilities : Vector.<GameObjectAbility>;
		
		public function GameObject(config : ConfigGameObject)
		{
			_config = config;
			
			_abilities = new Vector.<GameObjectAbility>();
		}

		public function get displayContent():DisplayObject
		{
			if(!_displayContent)
			{
				_displayContent = config.getDisplayContent();
				DisplayObjectContainer(_displayContent).mouseEnabled = false;
			}
			return _displayContent;
		}

		public function set displayContent(value:DisplayObject):void
		{
			_displayContent = value;
		}

		public function get config():ConfigGameObject
		{
			return _config;
		}

		public function set config(value:ConfigGameObject):void
		{
			_config = value;
		}

		public function set id(value : int) : void
		{
			_id = value;
		}
		
		public function get id() : int
		{
			return _id;
		}
		
		public function set x(value : int) : void
		{
			_displayContent.x = value;
		}
		
		public function get x():int
		{
			return _x;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_displayContent.y = value;
		}

		public function get isEnemy():Boolean
		{
			return _isEnemy;
		}

		public function set isEnemy(value:Boolean):void
		{
			_isEnemy = value;
		}

		public function get abilities():Vector.<GameObjectAbility>
		{
			return _abilities;
		}

		public function set abilities(value:Vector.<GameObjectAbility>):void
		{
			_abilities = value;
		}


	}
}
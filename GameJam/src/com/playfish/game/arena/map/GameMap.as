package com.playfish.game.arena.map
{
	import com.playfish.game.arena.object.GameObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class GameMap
	{
		private var _width : int;
		private var _height : int;
		private var _tiles : Array;
		
		public function GameMap(width : int, height : int)
		{
			_width = width;
			_height = height;
			_tiles = new Array(width * height);
			
			
		}
		
		public function updateGameObjectIndex(displayContent : DisplayObjectContainer) : void
		{
			for(var i : int = 0; i < _height; i++)
			{
				for(var j : int = 0; j < i + 1; j++)
				{
					if(getObjectIn(new Point(j, i)))
					{
						displayContent.addChild(getObjectIn(new Point(j, i)).displayContent);
					}
				}
			}
		}
		
		public function putObject(desPoint : Point, obj : GameObject) : Boolean
		{
			var index : int = desPoint.y * _height + desPoint.x; 
			if(index < 0 || index >= _width * _height || _tiles[index])
			{
				return false;
			}
			_tiles[index] = obj;
			return true;
		}
		
		public function getObjectIn(point : Point) : GameObject
		{
			var index : int = point.y * _height + point.x; 
			if(index >= 0 && index < _width * _height)
			{
				return _tiles[index];
			}
			else
			{
				return null;
			}
		}
		
		public function removeObjectIn(point : Point) : void
		{
			var index : int = point.y * _height + point.x;
			if(index >= 0 && index < _width * _height)
			{
				_tiles[index] = null;
			}
		}
		
		public function removeObject(obj : GameObject) : void
		{
			for (var i : int = 0; i < _width * _height; i++)
			{
				if(_tiles[i] == obj)
				{
					_tiles[i] = null;
				}
			}
		}
	}
}
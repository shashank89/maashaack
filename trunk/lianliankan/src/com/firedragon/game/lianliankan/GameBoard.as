package com.firedragon.game.lianliankan
{
	import flash.geom.Point;

	public class GameBoard
	{
		private static const BLANK_CELL:int = -1;
		
		private var _data:Vector.<int>;
		private var _width:int;
		private var _height:int;
		
		public function GameBoard()
		{
		}
		
		public function init(data:Vector.<int>, width:int, height:int):void
		{
			_data = data;
			_width = width;
			_height = height;
		}
		
		public function getPath(start:Point, target:Point):Vector.<Point>
		{
			var path:Vector.<Point> = new Vector.<Point>();
			
			// direct line
			if(connectDirectly(start, target))
			{
				path.push(target);
				return path;
			}
			
			var startPointLines:Vector.<Vector.<Point>> = getLines(start);
			var targetPointLines:Vector.<Vector.<Point>> = getLines(target);
			
			var startLine:Vector.<Point>;
			var targetLine:Vector.<Point>;
			
			// one corner
			var find:Boolean = false;
			for each(startLine in startPointLines)
			{
				for each(targetLine in targetPointLines)
				{
					var collidePoint:Point = collide(startLine, targetLine);
					if(collidePoint != null)
					{
						path.push(collidePoint, target);
						find = true;
						break;
					}
				}
				if(find)
				{
					break;
				}
			}
			
			// two corner
			if(!find)
			{
				for each(startLine in startPointLines)
				{
					for each(targetLine in targetPointLines)
					{
						var directConnectPoints:Vector.<Point> = getDirectConnectPoints(startLine, targetLine);
						if(directConnectPoints.length == 2)
						{
							path.push(directConnectPoints[0], directConnectPoints[1]);
							find = true;
						}
					}
					if(find)
					{
						break;
					}
				}
			}
			
			return path;
		}
		
		public function connectDirectly(start:Point, target:Point):Boolean
		{
			if((start.x == target.x && (start.x == -1 || start.x == _width))
				|| (start.y == target.y && (start.y == -1 || start.y == _height)))
			{
				return true;
			}
			
			
			var hasBlock:Boolean;
			var step:int;
			if(start.x == target.x)
			{
				step = (target.y - start.y) / Math.abs(start.y - target.y);
				var y:int = start.y;
				hasBlock = false;
				while(y + step != target.y)
				{
					y += step;
					if(_data[start.x + y * _width] != BLANK_CELL)
					{
						hasBlock = true;
						break;
					}
				}
				if(!hasBlock)
				{
					return true;
				}
			}
			if(start.y == target.y)
			{
				step = (target.x - start.x) / Math.abs(start.x - target.x);
				var x:int = start.x;
				hasBlock = false;
				while(x + step != target.x)
				{
					x += step;
					if(_data[x + start.y * _width] != BLANK_CELL)
					{
						hasBlock = true;
						break;
					}
				}
				if(!hasBlock)
				{
					return true;
				}
			}
			return false;
		}
		
		public function collide(line1:Vector.<Point>, line2:Vector.<Point>):Point
		{
			for each(var point1:Point in line1)
			{
				for each(var point2:Point in line2)
				{
					if(point1.x == point2.x && point1.y == point2.y)
					{
						return new Point(point1.x, point1.y);
					}
				}
			}
			return null;
		}
		
		public function getDirectConnectPoints(line1:Vector.<Point>, line2:Vector.<Point>):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			for each(var point1:Point in line1)
			{
				for each(var point2:Point in line2)
				{
					if(connectDirectly(point1, point2))
					{
						points.push(point1, point2);
						return points;
					}
				}
			}
			return points;
		}
		
		public function getLines(point:Point):Vector.<Vector.<Point>>
		{
			var lines:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			
			var lineLeft:Vector.<Point> = new Vector.<Point>();
			var x:int = point.x;
			while(x > 0 && _data[--x + point.y * _width] == BLANK_CELL)
			{
				lineLeft.push(new Point(x, point.y));
			}
			if(x == 0)
			{
				lineLeft.push(new Point(-1, point.y));
			}
			if(lineLeft.length > 0)
			{
				lines.push(lineLeft);
			}
			
			var lineRight:Vector.<Point> = new Vector.<Point>();
			x = point.x;
			while(x < _width - 1 && _data[++x + point.y * _width] == BLANK_CELL)
			{
				lineRight.push(new Point(x, point.y));
			}
			if(x == _width - 1)
			{
				lineRight.push(new Point(_width, point.y));
			}
			if(lineRight.length > 0)
			{
				lines.push(lineRight);
			}
			
			var lineUp:Vector.<Point> = new Vector.<Point>();
			var y:int = point.y;
			while(y > 0 && _data[point.x + (--y) * _width] == BLANK_CELL)
			{
				lineUp.push(new Point(point.x, y));
			}
			if(y == 0)
			{
				lineUp.push(new Point(point.x, -1));
			}
			if(lineUp.length > 0)
			{
				lines.push(lineUp);
			}
			
			var lineDown:Vector.<Point> = new Vector.<Point>();
			y = point.y;
			while(y < _height - 1 && _data[point.x + (++y) * _width] == BLANK_CELL)
			{
				lineDown.push(new Point(point.x, y));
			}
			if(y == _height - 1)
			{
				lineDown.push(new Point(point.x, _height));
			}
			if(lineDown.length > 0)
			{
				lines.push(lineDown);
			}
			
			return lines;
		}
	}
}
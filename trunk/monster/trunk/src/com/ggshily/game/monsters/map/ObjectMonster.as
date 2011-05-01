package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonster;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class ObjectMonster extends ObjectConstruction
	{
		private var _targetGrid : Grid;
		private var _lastUpdateTime : Number;
		private var _parentFrame : Grid;
		
		public function ObjectMonster(config:ConfigConstruction)
		{
			super(config);
			
			
			// TODO : read the level from user info
			_level = 1;
			
			_lastUpdateTime = getTimer();
		}
		
		override public function initFromBuilding(building:Building, gameMap : GameMap):void
		{
			super.initFromBuilding(building, gameMap);
			
		}
		
		override public function setPostionCell(cellX : int, cellY : int, frame : Grid) : void
		{
			super.setPostionCell(cellX, cellY, frame);
			
			_parentFrame = frame;
		}
		
		override public function tick(currentTime:Number):void
		{
			if(!_targetGrid.intersectsGrid(_grid))
			{
				var targetPoint : Point = new Point(_targetGrid.x + _grid.xoffset, _targetGrid.y + _targetGrid.yoffset);
				
				var result : Point = targetPoint.subtract(new Point(_grid.x, _grid.y));
				result.normalize(0.1);
				
				var speed : Number = (_config.getLevelInfo(_level) as ConfigLevelInfoMonster).speed;
				
				
				_grid.setPos(_grid.x + result.x * 10, _grid.y + result.y * 10);
				
				_displayContent.x = _grid.x;
				_displayContent.y = _grid.y;
			}
			else
			{
				_displayContent.x += Math.random() * 2;
				_displayContent.y += Math.random() * 2;
				
				if(Math.abs(_displayContent.x - _grid.x) > 2
					|| Math.abs(_displayContent.y - _grid.y))
				{
					_displayContent.x = _grid.x;
					_displayContent.y = _grid.y;
				}
			}
			
			_lastUpdateTime = currentTime;
		}
		
		public function setTargetGrid(grid : Grid) : void
		{
			_targetGrid = grid;
		}
	}
}
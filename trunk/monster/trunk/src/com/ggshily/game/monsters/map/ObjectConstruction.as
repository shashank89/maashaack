package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.geom.Rhombus;
	import com.ggshily.game.geom.RhombusGrid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.config.ConfigBase;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigMapInfo;
	import com.ggshily.game.monsters.core.ObjectBase;
	import com.ggshily.game.monsters.user.UserManager;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class ObjectConstruction extends ObjectBase
	{
		public static const LAYER_BG : int = 0;
		public static const LAYER_BUILDING : int = 1;
		public static const LAYER_TOP : int = 2;
		
		public static var BUILDING_INSTANCE_ID : int = 0;
		
		protected var _swfClass : Class;
		protected var _bg : Sprite;
		protected var _buildingLayer : Sprite;
		protected var _topLayer : Sprite;
		protected var _state : int;
		protected var _buildingCompleteTime : int;
		protected var _instanceId : int;
		protected var _isBuildComplete : Boolean;
		protected var _config : ConfigConstruction;
		protected var _level : int;
		
		protected var _grid : Grid;
		
		public function ObjectConstruction(config : ConfigConstruction)
		{
			super();
			
			_bg = new Sprite();
			_buildingLayer = new Sprite();
			_topLayer = new Sprite();
			
			_displayContent.addChild(_bg);
			_displayContent.addChild(_buildingLayer);
			_displayContent.addChild(_topLayer);
			
			_instanceId = -1;
			
			var building : DisplayObject = config.getDisplayContent();
//			building.alpha = .8;
			building.x = -config.xOffset;
			building.y = -config.yOffset;
			building.scaleX = building.scaleY = .3;
			
			addDisplayObject(building);
			_grid = config.grid.clone() as RhombusGrid;
			_grid.setPosCell(0, 0, new Grid());
			drawBg();
			
			_config = config;
			
//			scaleX = scaleY = .3;
		}
		
		/**
		 * temporary to add building asset
		 * 
		 */
		public function addDisplayObject(displayObject : DisplayObject) : void
		{
			_buildingLayer.addChild(displayObject);
		}
		
		public function setBuildingAlpha(alpah : Number) : void
		{
			_buildingLayer.alpha = alpah;
		}
		
		public function drawBg(color : int = 0x00FFFF) : void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(color);
			_bg.graphics.lineStyle(1, 0xFFFFFF);
			_bg.graphics.moveTo(grid.xoffset, 0);
			_bg.graphics.lineTo(grid.width, grid.height - grid.yoffset);
			_bg.graphics.lineTo(grid.width - grid.xoffset,  grid.height);
			_bg.graphics.lineTo(0,  grid.yoffset);
			_bg.graphics.lineTo(grid.xoffset, 0);
			_bg.graphics.endFill();
		}
		
		public static function drawBg1(graphics : Graphics, grid : Grid, fill : Boolean = true) : void
		{
			graphics.clear();
			if(fill)
			{
				graphics.beginFill(0x00FF00);
			}
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.moveTo(grid.x + grid.xoffset, grid.y + 0);
			graphics.lineTo(grid.x + grid.width, grid.y + grid.height - grid.yoffset);
			graphics.lineTo(grid.x + grid.width - grid.xoffset, grid.y +  grid.height);
			graphics.lineTo(grid.x + 0,  grid.y + grid.yoffset);
			graphics.lineTo(grid.x + grid.xoffset, grid.y + 0);
			if(fill)
			{
				graphics.endFill();
			}
			
		}
		
		public function setBgVisible(visible : Boolean) : void
		{
			_bg.visible = visible;
		}
		
		public function setGrid(column : int, row : int) : void
		{
			_grid = new RhombusGrid(ConfigMapInfo.instance.cell as Rhombus, column, row);
			_grid.setPosCell(0, 0, new Grid());
		}
		
		public function setPostionCell(cellX : int, cellY : int, frame : Grid) : void
		{
			_grid.setPosCell(cellX, cellY, frame);
			
			_displayContent.x = _grid.x;
			_displayContent.y = _grid.y;
		}
		
		public function initFromBuilding(building : Building, gameMap : GameMap) : void
		{
			setPostionCell(building.x, building.y, gameMap.frame);
			_level = building.level;
			_buildingLayer.alpha = 1;
			_instanceId = building.id;
			
			// init state
			_state = building.state;
		}
		
		public function initEvent(gameMap : GameMap) : void
		{
		}
		
		public function startBuild() : void
		{
			_level++;
			
			_instanceId = ++BUILDING_INSTANCE_ID;
			_state = Building.STATE_IN_BUILDING;
			_buildingLayer.alpha = .8;
			_buildingCompleteTime = getTimer() + _config.getLevelInfo(_level).time * 1000;
		}
		
		override public function tick(currentTime : Number):void
		{
			if(_state == Building.STATE_IN_BUILDING)
			{
				
				if(_buildingCompleteTime < currentTime)
				{
					buildComplete(currentTime);
				}
				else
				{
					var percentage : Number = 1 - (_buildingCompleteTime - currentTime) / _config.getLevelInfo(_level).time / 1000 ;
					
					_topLayer.graphics.beginFill(0xFF0000);
					_topLayer.graphics.drawRect(0, 0, percentage * 50, 10);
				}
			}
		}
		
		/*public function setState(...states) : void
		{
			for each(var state : int in states)
			{
				_state |= state;
			}
		}
		
		public function clearState(...states) : void
		{
			for each(var state : int in states)
			{
				_state &= ~state;
			}
			
		}
		
		public function containState(... states) : Boolean
		{
			for each(var state : int in states)
			{
				if((_state & state) == 0)
				{
					return false;
				}
			}
			return true;
		}*/
		
		protected function buildComplete(currentTime : Number) : void
		{
			_topLayer.graphics.clear();
			_topLayer.visible = false;
			
			_buildingLayer.alpha = 1;
			_state = Building.STATE_IDLE;
			_isBuildComplete = true;
			
			UserManager.instance.currentUser.setBuildingState(instanceId, Building.STATE_IDLE);
		}
		
		public function onClick() : void
		{
			
		}

		public function get swfClass():Class
		{
			return _swfClass;
		}

		public function set swfClass(value:Class):void
		{
			_swfClass = value;
		}

		public function get grid():Grid
		{
			return _grid;
		}

		public function get zOrder() : Number
		{
			return (_grid.cellX + _grid.cellY + _grid.column / 2 + _grid.row / 2) / 2;
		}

		public function get instanceId():int
		{
			return _instanceId;
		}

		public function get state():int
		{
			return _state;
		}

		public function get level():int
		{
			return _level;
		}

		public function get config():ConfigConstruction
		{
			return _config;
		}


	}
}
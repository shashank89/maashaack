package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.geom.RhombusGrid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionTownHall;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.config.ConfigMapInfo;
	import com.ggshily.game.monsters.core.CONSTANT;
	import com.ggshily.game.monsters.core.ObjectBase;
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.event.GameMapEvent;
	import com.ggshily.game.monsters.map.event.ObjectConstructionEventBase;
	import com.ggshily.game.monsters.ui.PanelConstructionMenu;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public class GameMap extends ObjectBase
	{
		public static const STATE_IDLE : int = 0;
		public static const STATE_BUILD_CONSTRUCTION : int = 1;
		
		public static const CONSTRUCTION_TOWN_HALL : int = 10000000;
		
		[Embed(source="swf/land.jpg")]
		private var land:Class;
		
		[Embed(source="swf/isograss1.jpg")]
		private var grass0:Class;
		[Embed(source="swf/isograss2.png")]
		private var grass1:Class;
		[Embed(source="swf/isograss3.png")]
		private var grass2:Class;
		[Embed(source="swf/isograss2.png")]
		private var grass3:Class;
		[Embed(source="swf/isograss3.png")]
		private var grass4:Class;
		
		private var _frame : Grid;		
		private var _isDraging : Boolean;
		private var _mouseDown : Boolean;
		private var _buildArea : Rectangle;
		private var _dragBounds : Rectangle;
		
		private var _mapLayer : Sprite;
		private var _uiLayer : Sprite;
		private var _bottomLayer : Sprite;
		private var _buildingLayer : Sprite;
		private var _topLayer : Sprite;
		
		private var _buildingMapObject : ObjectConstruction;
		private var _canBuild : Boolean;
		private var _mouseOverConstruction : ObjectConstruction;
		private var _state : int;
		private var _constructionMenu : PanelConstructionMenu;
		
		private var _currentConstructionIndex : int;
		private var _loadComplete : Boolean;
		
		private var _constructions : Vector.<ObjectConstruction>;
		
		private var _townHall : ObjectConstruction;
		
		public function GameMap(world : WorldBase, name : String)
		{
			super();
			
			_name = name;
			
			world.addEvent(this, GameMapEvent.SELECT_BUILDING);
			
			_frame = new RhombusGrid(ConfigMapInfo.instance.cell, 400, 400);
			_frame.setGrid(400, 400);
			
			_mapLayer = new Sprite();
			_uiLayer = new Sprite();
			
			_bottomLayer = _mapLayer.addChild(new Sprite()) as Sprite;
			_buildingLayer = _mapLayer.addChild(new Sprite()) as Sprite;
			_topLayer = _mapLayer.addChild(new Sprite()) as Sprite;
			
			_displayContent.addChild(_mapLayer);
			_displayContent.addChild(_uiLayer);
			
			_mapLayer.mouseChildren = false;
			
			_constructionMenu = new PanelConstructionMenu(world);
			_uiLayer.addChild(_constructionMenu.displayContent);
			_uiLayer.visible = false;
			
			Debug.TRACE(land);
			for(var i : int = 0; i < 10; ++i)
			{
				for(var j : int = 0; j < 10; ++j)
				{
					var index : int = Math.random() * 5;
					var cls : Class = (getDefinitionByName("com.ggshily.game.monsters.map::GameMap_grass" + index)) as Class;
					var pic : DisplayObject = new cls();
					_bottomLayer.addChild(pic);
					pic.x = j * 200;
					pic.y = i * 100;
				}
			}
			
			ObjectConstruction.drawBg1(_buildingLayer.graphics, _frame, false);
			
//			_displayContent.mouseChildren = false;
			
			_mapLayer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_mapLayer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_mapLayer.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_mapLayer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_mapLayer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
//			var bg : Sprite = new Sprite();
//			bg.graphics.beginFill(0x00FFFF);
//			bg.graphics.drawRect(0, 0, 1000, 1000);
//			bg.graphics.endFill();
//			addChild(bg);
			_buildArea = new Rectangle(0, 0, 1000, 1000);
			_dragBounds = new Rectangle();
			
			_constructions = new Vector.<ObjectConstruction>();
			
			updateMoveBounds();
			
//			scaleX = scaleY = .5;
//			_bottomLayer.scaleX = _bottomLayer.scaleY = 1/ .5;
		}
		
		public function updateMoveBounds(w : int = 0, scale : Number = 1) : void
		{
			if(w == 0)
			{
				w = _displayContent.width;
			}
			else
			{
				w = w / scale;
			}
			
			_dragBounds.left = -_displayContent.width + GameEngine.WIDTH;
			_dragBounds.right = 0;
			_dragBounds.top = -_displayContent.height + GameEngine.HEIGHT;
			_dragBounds.bottom = 0;
			
			/*mapMovable = false;
			if(_displayContent.width * scaleX > w)
			{
				mapMovable = true;
				_dragBounds.left = (w - mapPanel._width*scaleX)/scaleX;
				if(scale == 1){
					mapMoveBounds.right = 0;
				}else{
					mapMoveBounds.right = -(w-_width)/2;
				}
			}
			else
			{
				_dragBounds.left = _displayContent.x;
				_dragBounds.right = _displayContent.x;
			}
			if(_displayContent._height*scaleY > _height)
			{
				mapMovable = true;
				_dragBounds.top =( _height - _displayContent._height*scaleY)/scaleY;
				_dragBounds.bottom = 0;
			}
			else
			{
				_dragBounds.top = _displayContent.y;
				_dragBounds.bottom = _displayContent.y;
			}
			//revise
			_displayContent.x = Math.max(_displayContent.x,_dragBounds.left);
			_displayContent.x = Math.min(_displayContent.x,_dragBounds.right);
			_displayContent.y = Math.max(_displayContent.y,_dragBounds.top);
			_displayContent.y = Math.min(_displayContent.y,_dragBounds.bottom);*/
		}
		
		public function loadOneConstruction() : Boolean
		{
			addConstruction(UserManager.instance.currentUser.buildings[_currentConstructionIndex++]);
			
			_loadComplete = _currentConstructionIndex == UserManager.instance.currentUser.buildings.length;
			return _loadComplete;
		}
		
		public function addEvent(dispatcher : EventDispatcher, type : String) : void
		{
			Util.addEventListener(dispatcher, type, processEvent);
		}
		
		private function processEvent(event : ObjectConstructionEventBase) : void
		{
			event.process(this);
		}
		
		private function addConstruction(building : Building) : void
		{
			var config : ConfigConstruction = ConfigMain.instance.getConfigByTypeId(building.typeId) as ConfigConstruction;
			
			var construnction : ObjectConstruction = config.createConsturction();
			construnction.initFromBuilding(building, this);
			construnction.initEvent(this);
			
			_constructions.push(construnction);
			_buildingLayer.addChild(construnction.displayContent);
			construnction.setBgVisible(false);
			
			if(_townHall == null && config is ConfigConstructionTownHall)
			{
				_townHall = construnction;
			}
		}
		
		
		override public function tick(currentTime : Number) : void
		{
			for each(var construction : ObjectConstruction in _constructions)
			{
				construction.tick(currentTime);
			}
		}
		
		public function getConstructionsByTypeId(typeId : int) : Vector.<ObjectConstruction>
		{
			var constructions : Vector.<ObjectConstruction> = new Vector.<ObjectConstruction>();
			
			for each(var construction : ObjectConstruction in _constructions)
			{
				if(construction.config.typeId == typeId)
				{
					constructions.push(construction);
				}
			}
			return constructions;
		}
		
		private function mouseClickHandler(e : MouseEvent) : void
		{
			Debug.TRACE("mouse click");
			if(!_isDraging)
			{
				var construnction : ObjectConstruction;
				if(_buildingMapObject != null && _canBuild)
				{
					if(_buildingMapObject.instanceId < 0)
					{
						_buildingMapObject.startBuild();
						
						UserManager.instance.reduces(_buildingMapObject.config);
						UserManager.instance.currentUser.addBuilding(_buildingMapObject.config.typeId, _buildingMapObject.instanceId, Building.STATE_IN_BUILDING, _buildingMapObject.config.beanClass);
					}
					
					_constructions.push(_buildingMapObject);
					_buildingLayer.addChild(_buildingMapObject.displayContent);
					//				_buildingMapObject.x = _topLayer.x;
					//				_buildingMapObject.y = _topLayer.y;
					_buildingMapObject.setBuildingAlpha(1.0);
					_buildingMapObject.setBgVisible(false);
					_buildingMapObject = null;
					
					sort();
					for each(construnction in _constructions)
					{
						construnction.setBgVisible(false);
						construnction.setBuildingAlpha(1);
						_buildingLayer.addChild(construnction.displayContent);
					}
					
					_state = STATE_IDLE;
				}
				else if(_mouseOverConstruction != null && _mouseOverConstruction.state == Building.STATE_IDLE)
				{
					_constructionMenu.setConstruction(_mouseOverConstruction);
					_uiLayer.visible = true;
					/*
					_mouseOverBuilding.onClick();
					*/
				}
			}
			_isDraging = false;
			_mouseDown = false;
		}
		
		public function moveConstruction() : void
		{
			_buildingLayer.removeChild(_mouseOverConstruction.displayContent);
			_buildingMapObject = _mouseOverConstruction;
			_buildingMapObject.drawBg();
			_constructions.splice(_constructions.indexOf(_buildingMapObject), 1);
			_topLayer.addChild(_buildingMapObject.displayContent);
			_mouseOverConstruction = null;
			
			for each(var mapObject : ObjectConstruction in _constructions)
			{
				mapObject.drawBg();
				mapObject.setBgVisible(true);
				mapObject.setBuildingAlpha(.8);
			}
		}
		
		private function mouseDownHandler(e : MouseEvent) : void
		{
			Debug.TRACE("mouse down");
			_displayContent.startDrag(false, _dragBounds);
			_mouseDown = true;
			
			_constructionMenu.hide();
		}
		
		private function mouseUpHandler(e : MouseEvent) : void
		{
			Debug.TRACE("mouse up");
			_displayContent.stopDrag();
		}
		
		private function mouseOutHandler(e : MouseEvent) : void
		{
//			stopDrag();
			_isDraging = false;
			_mouseDown = false;
		}
		
		private function mouseMoveHandler(e : MouseEvent) : void
		{
			if(_mouseDown)
			{
				_isDraging = true;
			}
			else
			{
				var result : Grid = new Grid(ConfigMapInfo.instance.cell);
				_frame.containsPointInGrid(e.localX, e.localY, result);
				
				var construnction : ObjectConstruction;
				if(_buildingMapObject != null)
				{
					_buildingMapObject.setPostionCell(result.cellX, result.cellY, _frame);
					
					_canBuild = result.cellX >= 0 && result.cellY >= 0
						&& result.cellX <= _frame.column - _buildingMapObject.grid.column
						&& result.cellY <= _frame.row - _buildingMapObject.grid.row;
					if(_canBuild)
					{
						for each(construnction in _constructions)
						{
							if(construnction.grid.intersectsGrid(_buildingMapObject.grid))
							{
								_canBuild = false;
								break;
							}
						}
					}
					if(_canBuild)
					{
						_buildingMapObject.drawBg();
					}
					else
					{
						_buildingMapObject.drawBg(0xFF0000);
					}
				}
				else
				{
					if(_mouseOverConstruction != null)
					{
						_mouseOverConstruction.setBgVisible(false);
						_mouseOverConstruction = null;
					}
					for each(construnction in _constructions)
					{
						if(!construnction.grid.containsPoint(e.localX, e.localY).isOut())
						{
							construnction.setBgVisible(true);
							_mouseOverConstruction = construnction;
							break;
						}
					}
				}
			}
		}
		
		public function startDrag(construction : ObjectConstruction) : void
		{
			construction.displayContent.mouseChildren = false;
			construction.displayContent.mouseEnabled = false;
			construction.initEvent(this);
			_buildingMapObject = construction;
			_topLayer.addChild(_buildingMapObject.displayContent);
			
			for each(construction in _constructions)
			{
				construction.drawBg();
				construction.setBgVisible(true);
				construction.setBuildingAlpha(.8);
			}
			
			_state = STATE_BUILD_CONSTRUCTION;
		}
		
		
		public function produceMonster(typeId : int, hatchery : ObjectConstructionMonsterHatchery) : ObjectConstructionMonsterHousing
		{
			var constructions : Vector.<ObjectConstruction> = getConstructionsByTypeId(CONSTANT.CONSTRUCTION_HOUSING);
			var housing : ObjectConstructionMonsterHousing;
			for each(housing in constructions)
			{
				if(housing.hasFreeCapacity())
				{
					break;
				}
			}
			var monster : ObjectMonster = addMonster(typeId, housing);
			monster.setPostionCell(hatchery.grid.cellX, hatchery.grid.cellY, _frame);
			monster.setTargetGrid(housing.grid);
			
			return housing;
		}
		
		public function addMonster(typeId : int, housing : ObjectConstructionMonsterHousing) : ObjectMonster
		{
			var monster : ObjectMonster = housing.addMonster(typeId);
			monster.setPostionCell(housing.grid.cellX, housing.grid.cellY, _frame);
			
			_constructions.push(monster);
			_displayContent.addChild(monster.displayContent);
			
			sort();
			
			return monster;
		}
		
		private function sort() : void
		{
			_constructions.sort(function(a : ObjectConstruction, b : ObjectConstruction) : int{ return a.zOrder < b.zOrder ? 0 : 1});
		}

		public function get state():int
		{
			return _state;
		}

		public function get loadComplete():Boolean
		{
			return _loadComplete;
		}

		public function set loadComplete(value:Boolean):void
		{
			_loadComplete = value;
		}

		public function get townHall():ObjectConstruction
		{
			return _townHall;
		}

		public function get frame():Grid
		{
			return _frame;
		}


	}
}
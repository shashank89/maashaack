package com.playfish.game.arena.world
{
	import com.playfish.game.arena.config.ConfigGameObject;
	import com.playfish.game.arena.map.GameMap;
	import com.playfish.game.arena.object.GameObject;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WorldArena extends WorldBase
	{
		public static const MAP_WIDTH : int = 1280;
		public static const MAP_HEIGHT : int = 640;
		public static const MAP_OFFSET_X : int = MAP_WIDTH >> 1;
		public static const MAP_OFFSET_Y : int = 0;
		public static const TILE_WIDTH : int = 128;
		public static const TILE_HEIGHT : int = 64;
		public static const TILE_OFFSET_X : int = TILE_WIDTH >> 1;
		public static const TILE_OFFSET_Y : int = TILE_HEIGHT >> 1;
		
		private var isSwitchWorld : Boolean;
		private var gameMap : GameMap;
		
		private var isPreparingBattle : Boolean;
		private var selectedGameObject : GameObject;
		
		public function WorldArena()
		{
			super();
			
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill(0xFFFFFF);
			sprite.graphics.drawRect(0, 0, MAP_WIDTH, MAP_HEIGHT);
			sprite.graphics.endFill();
			drawGrids(sprite.graphics, MAP_WIDTH / TILE_WIDTH, MAP_HEIGHT / TILE_HEIGHT);
			
			
			displayContent = sprite;
			displayContent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			displayContent.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			gameMap = new GameMap(MAP_WIDTH / TILE_WIDTH, MAP_HEIGHT / TILE_HEIGHT);
			
			var config : ConfigGameObject = new ConfigGameObject();
			config.className = "_dc_sculpture_PFC";
			selectedGameObject = new GameObject(config);
			
			displayContent.addChild(selectedGameObject.displayContent);
			displayContent.mouseChildren = false;
			
			isPreparingBattle = true;
		}
		
		private function onMouseMove(e : MouseEvent) : void
		{
			var point : Point = getMapPointUnder(e.localX, e.localY);
			var real : Point = getGridPosition(point.x, point.y);
			
			trace("tile(x/y):" + point.x + "/" + point.y);
			trace("mouse(x/y):" + e.localX + "/" + e.localY);
			
			if(isPreparingBattle)
			{
				if(selectedGameObject)// && !gameMap.getObjectIn(getMapPointUnder(e.localX, e.localY)))
				{
					selectedGameObject.x = real.x;
					selectedGameObject.y = real.y;
				}
			}
			else if(selectedGameObject)
			{
				selectedGameObject.x = real.x;
				selectedGameObject.y = real.y;
			}
			
		}
		
		private function onMouseClick(e : MouseEvent) : void
		{
			var point : Point = getMapPointUnder(e.localX, e.localY);
			var obj : GameObject = gameMap.getObjectIn(point);
			
			if(isPreparingBattle)
			{
				if(selectedGameObject && !obj)
				{
					// add a game object on the map
					gameMap.putObject(point, selectedGameObject);
					gameMap.updateGameObjectIndex(displayContent);
					
					var config : ConfigGameObject = new ConfigGameObject();
					config.className = "_dc_sculpture_PFC";
					selectedGameObject = new GameObject(config);
					displayContent.addChild(selectedGameObject.displayContent);
				}
			}
			else if(obj)
			{
				if(obj.isEnemy)
				{
					
				}
				else
				{
					if(selectedGameObject)
					{
//						selectedGameObject.displayContent.
					}
					selectedGameObject = obj;
					
				}
				
			}
//			isSwitchWorld = true;
			
			trace("tile(x/y):" + point.x + "/" + point.y);
		}
		
		public override function tickFrame(delta : int) : IGameWorld
		{
//			trace("world arena");
			
			if(isSwitchWorld)
			{
				isSwitchWorld = false;
				return WorldManager.instance.getWorld(WorldManager.WORLD_MENU);
			}
			else
			{
				return this;
			}
		}
		
		public static function getMapPointUnder(x : int, y : int) : Point
		{
			var sx : int = (y + (x - MAP_OFFSET_X) * .5) / TILE_HEIGHT;
			var sy : int = (y - (x - MAP_OFFSET_X) * .5) / TILE_HEIGHT;
			
//			if((sx + sy) & 1 == 0)
//			{
//				sx -= 1;
//			}
			
			return new Point(sx, sy);
		}
		
		public static function getGridPosition(x : int, y : int) : Point
		{
			var sx : int = (x - y) * TILE_HEIGHT + MAP_OFFSET_X - TILE_OFFSET_X;
			var sy : int = (x + y) * TILE_HEIGHT / 2;
			
			return new Point(sx, sy);
		}
		
		public static function drawGrids(graphics : Graphics, width : int, height : int) : void
		{
			var commands : Vector.<int> = new Vector.<int>();
			var data : Vector.<Number> = new Vector.<Number>();
			
			for(var i : int = 0; i < height; i++)
			{
				for(var j : int = 0; j < width; j++)
				{
					pushGrid(commands, data, i, j);
				}
			}
			
			graphics.lineStyle(1, 0xFF0000);
//			graphics.beginFill(0x00FFFF);
			graphics.drawPath(commands, data);
//			graphics.endFill();
		}
		
		private static function pushGrid(commands : Vector.<int>, data : Vector.<Number>, x : int, y : int) : void
		{
			commands.push(GraphicsPathCommand.MOVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			
			data.push(MAP_OFFSET_X + (x - y) * TILE_OFFSET_X - (TILE_WIDTH >> 1));
			data.push(MAP_OFFSET_Y + (x + y) * TILE_OFFSET_Y + (TILE_HEIGHT >> 1));
			data.push(MAP_OFFSET_X + (x - y) * TILE_OFFSET_X);
			data.push(MAP_OFFSET_Y + (x + y) * TILE_OFFSET_Y);
			data.push(MAP_OFFSET_X + (x - y) * TILE_OFFSET_X + (TILE_WIDTH >> 1));
			data.push(MAP_OFFSET_Y + (x + y) * TILE_OFFSET_Y + (TILE_HEIGHT >> 1));
			data.push(MAP_OFFSET_X + (x - y) * TILE_OFFSET_X);
			data.push(MAP_OFFSET_Y + (x + y) * TILE_OFFSET_Y + TILE_HEIGHT);
			data.push(MAP_OFFSET_X + (x - y) * TILE_OFFSET_X - (TILE_WIDTH >> 1));
			data.push(MAP_OFFSET_Y + (x + y) * TILE_OFFSET_Y + (TILE_HEIGHT >> 1));
		}
	}
}
package com.ggshily.game.monsters.world
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.ui.PanelMainInfo;
	import com.ggshily.game.monsters.user.OfflineUserManager;
	
	import flash.utils.getTimer;
	
	public class WorldOwnCity extends WorldBase
	{
		public static const CHILD_GAME_MAP : String = "GAME_MAP";
		public static const CHILD_MAIN_INFO : String = "MAIN_INFO";
		
		private var _gameMap : GameMap;
		private var _panelMainInfo : PanelMainInfo;
		
		private var _gameMapLoaded : Boolean;
		
		public function WorldOwnCity()
		{
			super();
		}
		
		override public function start() : void
		{
			
			new OfflineUserManager();
			
			_gameMap = new GameMap(this, CHILD_GAME_MAP);
			_panelMainInfo = new PanelMainInfo(this, CHILD_MAIN_INFO);
			
			addObjectChild(_gameMap);
			addObjectChild(_panelMainInfo);
			
			addDisplayChild(_gameMap.displayContent);
			addDisplayChild(_panelMainInfo.displayContent);
			
			
			
			_panelMainInfo.show();
		}
		
		override public function tick(currentTime:Number):void
		{
			if(!_gameMapLoaded)
			{
				var startTime : Number = getTimer();
				
				while(!_gameMap.loadOneConstruction() && getTimer() - startTime < 30)
				{
					
				}
				_gameMapLoaded = _gameMap.loadComplete;
				return;
			}
			super.tick(currentTime);
		}
		
		public function get gameMap():GameMap
		{
			return _gameMap;
		}
	}
}
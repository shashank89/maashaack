package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.bean.BuildingMaterial;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionMaterial;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMaterial;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.util.Util;
	
	import flash.utils.getTimer;

	public class ObjectConstructionMaterial extends ObjectConstruction
	{
		
		private var _startGatheringTime : Number;
		private var _gatheringAmount : Number;
		
		private var _lastUpdateTime : Number;
		
		public function ObjectConstructionMaterial(config : ConfigConstruction)
		{
			super(config);
			
		}
		
		override public function tick(currentTime : Number):void
		{
			super.tick(currentTime);
			
			if(_state == Building.STATE_IDLE)
			{
				if(currentTime / 1000 - 1 > _lastUpdateTime / 1000)
				{
					_lastUpdateTime = currentTime;
					
					var leveInfo : ConfigLevelInfoMaterial = _config.getLevelInfo(_level) as ConfigLevelInfoMaterial;
					_gatheringAmount = (currentTime - _startGatheringTime) / Util.HOUR_MS * leveInfo.productivePerHour;
					var capacity : int = leveInfo.capacity;
					if(_gatheringAmount >= capacity)
					{
						_gatheringAmount = capacity;
						_state = Building.STATE_FULL;
						/*clearState(STATE_GATHERING);
						setState(STATE_FULL);*/
					}
				}
			}
		}
		
		override protected function buildComplete(currentTime : Number):void
		{
			super.buildComplete(currentTime);
			_startGatheringTime = currentTime;
			_lastUpdateTime = currentTime;
		}
		
		override public function onClick():void
		{
			collectResource();
		}
		
		override public function initFromBuilding(building:Building, gameMap : GameMap):void
		{
			super.initFromBuilding(building, gameMap);
			
			_startGatheringTime = (building as BuildingMaterial).startGatheringTime;
			
		}
		
		public function collectResource() : void
		{
			_startGatheringTime = getTimer();
			_state = Building.STATE_IDLE;
			
			UserManager.instance.currentUser.addMaterial((_config as ConfigConstructionMaterial).produceMaterialId, int(_gatheringAmount));
		}

		public function get gatheringAmount():Number
		{
			return _gatheringAmount;
		}

	}
}
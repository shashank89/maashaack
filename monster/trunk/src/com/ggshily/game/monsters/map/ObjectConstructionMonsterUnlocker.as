package com.ggshily.game.monsters.map
{
	import com.ggshily.game.monsters.bean.BuildingMonsterUnlocker;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	
	public class ObjectConstructionMonsterUnlocker extends ObjectConstruction
	{
		private var _unlockingMonsterTypeId : int;
		private var _startTime : Number;
		
		public function ObjectConstructionMonsterUnlocker(config:ConfigConstruction)
		{
			super(config);
		}
		
		override public function initFromBuilding(building:Building, frame:Grid):void
		{
			super.initFromBuilding(building, frame);
			
			_unlockingMonsterTypeId = (building as BuildingMonsterUnlocker).unlockingMonsterTypeId;
			_startTime = (building as BuildingMonsterUnlocker).startTime;
		}
	}
}
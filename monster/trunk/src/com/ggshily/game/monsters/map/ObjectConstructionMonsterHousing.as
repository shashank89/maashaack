package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.bean.BuildingMonsterHousing;
	import com.ggshily.game.monsters.bean.Monster;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonster;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonsterHousing;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.core.CONSTANT;
	import com.ggshily.game.monsters.user.UserManager;
	
	public class ObjectConstructionMonsterHousing extends ObjectConstruction
	{
		private var _monsters : Vector.<ObjectMonster>;
		
		public function ObjectConstructionMonsterHousing(config:ConfigConstruction)
		{
			super(config);
			
			_monsters = new Vector.<ObjectMonster>();
		}
		
		override public function initFromBuilding(building:Building, gameMap : GameMap):void
		{
			super.initFromBuilding(building, gameMap);
			
			var monsters : Vector.<Monster> = (building as BuildingMonsterHousing).monsters;
			for each(var monster : Monster in monsters)
			{
				for(var i : int = 0; i < monster.amount; ++i)
				{
					gameMap.addMonster(monster.typeId, this);
				}
			}
		}
		
		override public function tick(currentTime:Number):void
		{
			super.tick(currentTime);
			
//			for each(var monster : ObjectMonster in _monsters)
//			{
//				monster.tick(currentTime);
//			}
		}
		
		private function isInConstruction(monster : ObjectMonster) : Boolean
		{
			return true;
		}
		
		private function gotoConstruction(monster : ObjectMonster) : void
		{
			
		}
		
		public function hasFreeCapacity() : Boolean
		{
			var housing : int;
			for each(var monster : ObjectMonster in _monsters)
			{
				housing += (monster.config.getLevelInfo(monster.level) as ConfigLevelInfoMonster).housing;
			}
			
			return housing < (_config.getLevelInfo(_level) as ConfigLevelInfoMonsterHousing).housing;
		}
		
		public function addMonster(typeId : int) : ObjectMonster
		{
			var objectMonster : ObjectMonster = new ObjectMonster(ConfigMain.instance.getConfigByTypeId(typeId) as ConfigConstruction);
			_monsters.push(objectMonster);
			
			return objectMonster;
		}
	}
}
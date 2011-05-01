package com.ggshily.game.monsters.bean
{
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonster;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.config.ConfigMonster;

	public class BuildingMonsterHousing extends Building
	{
		public var monsters : Vector.<Monster>;
		
		public function BuildingMonsterHousing()
		{
			super();
			
			monsters = new Vector.<Monster>();
		}
		
		public function getMonstersHousing() : int
		{
			var housing : int;
			for each(var monster : Monster in monsters)
			{
				housing += ((ConfigMain.instance.getConfigByTypeId(monster.typeId) as ConfigMonster)
					.getLevelInfo(monster.level) as ConfigLevelInfoMonster).housing;
			}
			return housing;
		}
	}
}
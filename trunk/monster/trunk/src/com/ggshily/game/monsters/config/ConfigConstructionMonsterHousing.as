package com.ggshily.game.monsters.config
{
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterHousing;

	public class ConfigConstructionMonsterHousing extends ConfigConstruction
	{
		public function ConfigConstructionMonsterHousing()
		{
			super();
			
			_levelInfoClass = ConfigLevelInfoMonsterHousing;
		}
		
		override public function createConsturction():ObjectConstruction
		{
			return new ObjectConstructionMonsterHousing(this);
		}
	}
}
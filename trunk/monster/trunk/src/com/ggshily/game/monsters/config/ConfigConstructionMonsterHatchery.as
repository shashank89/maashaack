package com.ggshily.game.monsters.config
{
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterHatchery;

	public class ConfigConstructionMonsterHatchery extends ConfigConstruction
	{
		public function ConfigConstructionMonsterHatchery()
		{
			super();
			
			_levelInfoClass = ConfigLevelInfoMonsterHatchery;
		}
		
		override public function createConsturction():ObjectConstruction
		{
			return new ObjectConstructionMonsterHatchery(this);
		}
	}
}
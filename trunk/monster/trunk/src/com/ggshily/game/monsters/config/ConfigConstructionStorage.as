package com.ggshily.game.monsters.config
{
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.map.ObjectConstructionStorage;

	public class ConfigConstructionStorage extends ConfigConstruction
	{
		
		public function ConfigConstructionStorage()
		{
			super();
			_levelInfoClass = ConfigLevelInfoStorage;
		}
		
		override public function createConsturction():ObjectConstruction
		{
			return new ObjectConstructionStorage(this);
		}
		
	}
}
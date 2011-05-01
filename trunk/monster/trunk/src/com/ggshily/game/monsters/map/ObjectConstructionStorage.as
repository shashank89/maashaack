package com.ggshily.game.monsters.map
{
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionMaterial;
	import com.ggshily.game.monsters.config.ConfigConstructionStorage;
	import com.ggshily.game.monsters.config.ConfigLevelInfoStorage;
	import com.ggshily.game.monsters.user.UserManager;
	
	public class ObjectConstructionStorage extends ObjectConstruction
	{
		public function ObjectConstructionStorage(config:ConfigConstruction)
		{
			super(config);
		}
		
		override protected function buildComplete(currentTime:Number):void
		{
			super.buildComplete(currentTime);
			
			UserManager.instance.currentUser.addMaterialCapacity((config.getLevelInfo(_level) as ConfigLevelInfoStorage).capacityPlus);
		}
	}
}
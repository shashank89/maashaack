package com.ggshily.game.monsters.config
{
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.map.ObjectConstructionTownHall;

	public class ConfigConstructionTownHall extends ConfigConstruction
	{
		public static const TYPE_ID : int = 10000000;
		
		public function ConfigConstructionTownHall()
		{
			super();
		}
		
		override public function createConsturction() : ObjectConstruction
		{
			return new ObjectConstructionTownHall(this);
		}
	}
}
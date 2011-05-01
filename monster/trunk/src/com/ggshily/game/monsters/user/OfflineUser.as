package com.ggshily.game.monsters.user
{
	import com.ggshily.game.monsters.bean.Building;

	public class OfflineUser extends User
	{
		public function OfflineUser()
		{
			_buildings = new Vector.<Building>();
			
			var building : Building = new Building();
			building.id = 1;
			building.typeId = 10000000;
			building.x = 80;
			building.y = 80;
			_buildings.push(new Building());
			
		}
	}
}
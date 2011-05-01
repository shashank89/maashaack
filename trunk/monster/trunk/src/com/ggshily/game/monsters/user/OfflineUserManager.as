package com.ggshily.game.monsters.user
{
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.bean.Material;
	import com.ggshily.game.monsters.bean.Monster;
	import com.ggshily.game.monsters.map.ObjectConstruction;

	public class OfflineUserManager
	{
		private static var _instance : OfflineUserManager;
		
		private var _currentUser : User;
		
		public function OfflineUserManager()
		{
			var user : User = new User();
			user.coin = 10000;
			
			var buildings : Vector.<Building> = new Vector.<Building>();
			
			var building : Building = new Building();
			building.id = ++ObjectConstruction.BUILDING_INSTANCE_ID;
			building.typeId = 10000000;
			building.x = 80;
			building.y = 80;
			building.level = 1;
			buildings.push(building);
			user.buildings = buildings;
			
			var resources : Vector.<Material> = new Vector.<Material>();
			var resource : Material = new Material();
			resource.typeId = 2000000;
			resource.amount = 100000;
			resource.capacity = 100000;
			resources.push(resource);
			
			resource = new Material();
			resource.typeId = 2000001;
			resource.amount = 100000;
			resource.capacity = 100000;
			resources.push(resource);
			
			resource = new Material();
			resource.typeId = 2000002;
			resource.amount = 100000;
			resource.capacity = 100000;
			resources.push(resource);
			
			resource = new Material();
			resource.typeId = 2000003;
			resource.amount = 100000;
			resource.capacity = 100000;
			resources.push(resource);
			
			user.materials = resources;
			
			user.unlockedMonsters = new Vector.<Monster>();
			
			user.monsters = new Vector.<Monster>();
			
			UserManager.instance.currentUser = user;
		}
	}
}
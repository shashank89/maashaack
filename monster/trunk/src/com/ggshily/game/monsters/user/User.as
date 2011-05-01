package com.ggshily.game.monsters.user
{
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.bean.BuildingMonsterHousing;
	import com.ggshily.game.monsters.bean.Material;
	import com.ggshily.game.monsters.bean.Monster;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionMonsterHatchery;
	import com.ggshily.game.monsters.config.ConfigConstructionMonsterHousing;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonster;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonsterHatchery;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonsterHousing;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.config.ConfigMonster;
	
	import flash.utils.getDefinitionByName;

	public class User
	{
		public static const BEAN_CLASS_PACKAGE : String = "com.ggshily.game.monsters.bean::";
		
		public var id : int;
		public var name : String;
		public var exp : int;
		public var coin : int;
		public var buildings : Vector.<Building>;
		public var materials : Vector.<Material>;
		public var unlockedMonsters : Vector.<Monster>;
		public var monsters : Vector.<Monster>;
		
		public function User()
		{
		}
		
		public function addMaterial(typeId : int, amount : int) : void
		{
			for each(var material : Material in materials)
			{
				if(material.typeId == typeId)
				{
					material.amount += amount;
					return;
				}
			}
		}
		
		public function addBuilding(typeId : int, instanceId : int, state : int, beanClass : String) : void
		{
			var cls : Class = getDefinitionByName(BEAN_CLASS_PACKAGE + beanClass) as Class;
			var building : Building = new cls();
			building.typeId = typeId;
			building.level = 1;
			building.state = state;
			building.id = instanceId;
			
			buildings.push(building);
		}
		
		public function setBuildingState(instanceId : int, state : int) : void
		{
			for each(var building : Building in buildings)
			{
				if(building.id == instanceId)
				{
					building.state = state;
					break;
				}
			}
		}
		
		public function addMonster(typeId : int, buildingId : int) : void
		{
			var building : BuildingMonsterHousing = getBuildingByInstanceId(buildingId) as BuildingMonsterHousing;
			
			
			var monster : Monster;
			for each(var m : Monster in building.monsters)
			{
				if(m.typeId == typeId)
				{
					monster = m;
					break;
				}
			}
			if(monster == null)
			{
				monster = new Monster();
				monster.typeId = typeId;
				monster.level = 1;
				monster.amount = 0;
				building.monsters.push(monster);
			}
			monster.amount++;
		}
		
		public function getTotalMonsterHousing() : int
		{
			var totalHousing : int;
			for each(var building : Building in buildings)
			{
				if(building is BuildingMonsterHousing)
				{
					totalHousing += ((ConfigMain.instance.getConfigByTypeId(building.typeId) as ConfigConstruction)
						.getLevelInfo(building.level) as ConfigLevelInfoMonsterHousing).housing;
				}
			}
			
			return totalHousing;
		}
		
		public function getCurrentMonsterHousing() : int
		{
			var currentHousing : int;
			for each(var building : Building in buildings)
			{
				if(building is BuildingMonsterHousing)
				{
					currentHousing += (building as BuildingMonsterHousing).getMonstersHousing();
				}
			}
			return currentHousing;
		}
		
		public function getBuildingByInstanceId(instanceId : int) : Building
		{
			for each(var building : Building in buildings)
			{
				if(building.id == instanceId)
				{
					return building;
				}
			}
			return null;
		}
		
		public function getBuildingsByTypeId(typeId : int) : Vector.<Building>
		{
			var result : Vector.<Building> = new Vector.<Building>();
			for each(var building : Building in buildings)
			{
				if(building.typeId == typeId)
				{
					result.push(building);
				}
			}
			return result;
		}
		
		public function addMaterialCapacity(plus : int) : void
		{
			for each(var material : Material in materials)
			{
				material.capacity += plus;
			}
		}
		
		public function getMonsterLevel(typeId : int) : int
		{
			for each(var monster : Monster in unlockedMonsters)
			{
				if(monster.typeId == typeId)
				{
					return monster.level;
				}
			}
			return 1;
		}
	}
}
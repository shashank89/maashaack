package com.ggshily.game.monsters.user
{
	import com.ggshily.game.monsters.bean.Material;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionTownHall;
	import com.ggshily.game.monsters.config.ConfigLevelInfo;

	public class UserManager
	{
		private static var _instance : UserManager;
		
		private var _currentUser : User;
		
		public function UserManager()
		{
		}
		
		public function canBuild(config : ConfigConstruction) : Boolean
		{
			var levelInfo : ConfigLevelInfo = config.getLevelInfo(1);
			var result : Boolean = _currentUser.coin >= levelInfo.costCoin;
			if(result)
			{
				for each(var material : Material in _currentUser.materials)
				{
					result &&= material.amount >= levelInfo.getCost(material.typeId);
					if(!result)
					{
						break;
					}
				}
			}
			return result;
		}
		
		public function reduces(config : ConfigConstruction, level : int = 1) : void
		{
			var levelInfo : ConfigLevelInfo = config.getLevelInfo(level);
			
			_currentUser.coin -= levelInfo.costCoin;
			for each(var material : Material in _currentUser.materials)
			{
				material.amount -= levelInfo.getCost(material.typeId);
			}
		}
		
		public function get currentUser():User
		{
			return _currentUser;
		}

		public function set currentUser(value:User):void
		{
			_currentUser = value;
		}

		public static function get instance() : UserManager
		{
			if(_instance == null)
			{
				_instance = new UserManager();
			}
			return _instance;
		}
	}
}
package com.ggshily.game.monsters.config
{
	public class ConfigCostMaterial
	{
		private var _typeId : int;
		private var _amount : int;
		
		public function ConfigCostMaterial(typId : int, amount : int)
		{
			_typeId = typId;
			_amount = amount;
		}

		public function get typeId():int
		{
			return _typeId;
		}

		public function get amount():int
		{
			return _amount;
		}


	}
}
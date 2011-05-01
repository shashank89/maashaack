package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfo
	{
		private var _id : int;
		private var _health : int;
		private var _costCoin : int;
		private var _costMaterials : Vector.<ConfigCostMaterial>
		private var _time : int;
		
		public function ConfigLevelInfo()
		{
		}
		
		public function parseData(data : XML) : void
		{
			_id = XmlUtil.getAttributeAsNumber(data, "id");
			_health = XmlUtil.getAttributeAsNumber(data, "health");
			_costCoin = XmlUtil.getAttributeAsNumber(data, "costCoin");
			_time = XmlUtil.getAttributeAsNumber(data, "time");
			
			_costMaterials = new Vector.<ConfigCostMaterial>();
			for each(var child : XML in data.costResource)
			{
				_costMaterials.push(new ConfigCostMaterial(XmlUtil.getAttributeAsNumber(child, "type"),
					XmlUtil.getAttributeAsNumber(child, "value")));
			}
		}
		
		public function getCost(resourceId : int) : int
		{
			for each(var cost : ConfigCostMaterial in _costMaterials)
			{
				if(cost.typeId == resourceId)
				{
					return cost.amount;
				}
			}
			return 0;
		}

		public function get id():int
		{
			return _id;
		}

		public function get health():int
		{
			return _health;
		}

		public function get costCoin():int
		{
			return _costCoin;
		}

		public function get costResources():Vector.<ConfigCostMaterial>
		{
			return _costMaterials;
		}

		public function get time():int
		{
			return _time;
		}


	}
}
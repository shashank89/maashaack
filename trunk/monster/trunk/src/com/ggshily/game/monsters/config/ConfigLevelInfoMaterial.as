package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfoMaterial extends ConfigLevelInfo
	{
		private var _productivePerHour : int
		private var _capacity : int;
		
		public function ConfigLevelInfoMaterial()
		{
			super();
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_productivePerHour = XmlUtil.getAttributeAsNumber(data, "productivePerHour");
			_capacity = XmlUtil.getAttributeAsNumber(data, "capacity");
		}

		public function get productivePerHour():int
		{
			return _productivePerHour;
		}

		public function get capacity():int
		{
			return _capacity;
		}


	}
}
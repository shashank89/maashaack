package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfoStorage extends ConfigLevelInfo
	{
		private var _capacityPlus : int;
		
		public function ConfigLevelInfoStorage()
		{
			super();
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_capacityPlus = XmlUtil.getAttributeAsNumber(data, "capacityPlus");
		}

		public function get capacityPlus():int
		{
			return _capacityPlus;
		}

	}
}
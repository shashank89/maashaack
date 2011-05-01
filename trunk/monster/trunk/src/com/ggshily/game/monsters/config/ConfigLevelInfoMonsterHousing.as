package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfoMonsterHousing extends ConfigLevelInfo
	{
		private var _housing : int;
		
		public function ConfigLevelInfoMonsterHousing()
		{
			super();
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_housing = XmlUtil.getAttributeAsNumber(data, "housing");
		}

		public function get housing():int
		{
			return _housing;
		}

	}
}
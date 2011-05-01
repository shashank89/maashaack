package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfoMonsterHatchery extends ConfigLevelInfo
	{
		private var _queneNumber : int;
		
		public function ConfigLevelInfoMonsterHatchery()
		{
			super();
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_queneNumber = XmlUtil.getAttributeAsNumber(data, "queneNumber");
		}

		public function get queneNumber():int
		{
			return _queneNumber;
		}

	}
}
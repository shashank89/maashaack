package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigMaterial extends ConfigBase
	{
		private var _type : String;
		private var _name : String;
		private var _initCapacity : int;
		
		public function ConfigMaterial()
		{
		}
		
		override public function parseData(data:XML):void
		{
			_type = XmlUtil.getAttributeAsString(data, "type");
			_name = XmlUtil.getAttributeAsString(data, "name");
		}
	}
}
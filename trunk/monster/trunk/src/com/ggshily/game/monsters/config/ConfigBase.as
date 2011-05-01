package com.ggshily.game.monsters.config
{
	public class ConfigBase
	{
		protected var _typeId : Number;
		
		public function ConfigBase()
		{
		}
		
		public function parseData(data : XML) : void
		{
		}
		
		public function get typeId():Number
		{
			return _typeId;
		}
	}
}
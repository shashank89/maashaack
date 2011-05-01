package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;

	public class ConfigLevelInfoMonster extends ConfigLevelInfo
	{
		private var _speed : Number;
		private var _housing : Number;
		private var _damage : Number;
		private var _range : Number;
		private var _cooldown : Number;
		private var _favoriteTarget : Vector.<int>;
		
		public function ConfigLevelInfoMonster()
		{
			super();
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_speed = XmlUtil.getAttributeAsNumber(data, "speed");
			_housing = XmlUtil.getAttributeAsNumber(data, "housing");
			_damage = XmlUtil.getAttributeAsNumber(data, "damage");
			_range = XmlUtil.getAttributeAsNumber(data, "range");
			_cooldown = XmlUtil.getAttributeAsNumber(data, "cooldown");
			
			_favoriteTarget = new Vector.<int>();
			for each(var child : XML in data.favoriteTarget)
			{
				_favoriteTarget.push(XmlUtil.getAttributeAsNumber(child, "typeId"));
			}
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function get housing():Number
		{
			return _housing;
		}

		public function get damage():Number
		{
			return _damage;
		}

		public function get range():Number
		{
			return _range;
		}

		public function get cooldown():Number
		{
			return _cooldown;
		}

		public function get favoriteTarget():Vector.<int>
		{
			return _favoriteTarget;
		}


	}
}
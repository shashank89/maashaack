package com.ggshily.game.monsters.config
{
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.map.ObjectConstructionMaterial;
	import com.ggshily.game.util.XmlUtil;

	public class ConfigConstructionMaterial extends ConfigConstruction
	{
		private var _produceMaterialId : int;
		
		public function ConfigConstructionMaterial()
		{
			super();
			
			_levelInfoClass = ConfigLevelInfoMaterial;
		}
		
		override public function createConsturction():ObjectConstruction
		{
			return new ObjectConstructionMaterial(this);
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
			
			_produceMaterialId = XmlUtil.getAttributeAsNumber(data, "produceMaterialId");
		}

		public function get produceMaterialId():int
		{
			return _produceMaterialId;
		}

	}
}
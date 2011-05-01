package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.XmlUtil;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ConfigMain
	{
		private static const CONFIG_PACKAGE : String = "com.ggshily.game.monsters.config::";
		
		private static const DUMP_CONFIG_BUILDING : ConfigConstruction = null;
		private static const DUMP_CONFIG_RESOURCE : ConfigMaterial = null;
		private static const DUMP_CONFIG_TOWN_HALL : ConfigConstructionTownHall = null;
		private static const DUMP_CONFIG_CONSTRUCTION_MATERIAL : ConfigConstructionMaterial = null;
		private static const DUMP_CONFIG_MONSTER : ConfigMonster = null;
		
		private static const CONFIGCONSTUCTIONMONSTERUNLOCKER : ConfigConstuctionMonsterUnlocker = null;
		private static const CONFIGCONSTRUCTIONMONSTERHATCHERY : ConfigConstructionMonsterHatchery = null;
		private static const CONFIGCONSTRUCTIONMONSTERHOUSING : ConfigConstructionMonsterHousing = null;
		
		private static var _instance : ConfigMain;
		
		private var _configMap : Dictionary;
		private var _configTypeMap : Dictionary;
		
		public function ConfigMain()
		{
			_configMap = new Dictionary();
			_configTypeMap = new Dictionary();
		}
		
		public static function get instance() : ConfigMain
		{
			if(_instance == null)
			{
				_instance = new ConfigMain();
			}
			return _instance;
		}
		
		public function getConfigs(configClass : Class) : Array
		{
			for(var name : String in _configMap)
			{
				if(name == getQualifiedClassName(configClass))
				{
					return _configMap[name];
				}
			}
			return [];
		}
		
		public function getMultyConfigs(configClasses : Array ) : Array
		{
			var result : Array = [];
			for each(var configClass : Class in configClasses)
			{
				result = result.concat(getConfigs(configClass));
			}
			return result;
		}
		
		public function getConfigByTypeId(typeId : int) : ConfigBase
		{
			return _configTypeMap[typeId];
		}
		
		public function loadConfig(data : XML) : void
		{
			for each(var child : XML in data.children())
			{
				var cls : Class;
				
				var className : String = XmlUtil.getAttributeAsString(child, "ConfigClass", null, true);
				if(className)
				{
					className = CONFIG_PACKAGE + className;
					cls = getDefinitionByName(className) as Class;
				}
				else
				{
					throw new Error("Can't find class name:\n" + child);
				}
				var config : ConfigBase = new cls();
				config.parseData(child);
				
				if(!_configMap[className])
				{
					_configMap[className] = new Array();
				}
				_configMap[className].push(config);
				
				_configTypeMap[config.typeId] = config;
			}
		}
	}
}
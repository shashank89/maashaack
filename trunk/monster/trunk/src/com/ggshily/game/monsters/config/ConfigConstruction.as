package com.ggshily.game.monsters.config
{
	import adobe.utils.XMLUI;
	
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.geom.Rhombus;
	import com.ggshily.game.geom.RhombusGrid;
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.XmlUtil;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ConfigConstruction extends ConfigBase
	{
		protected var _name : String;
		protected var _grid : Grid;
		protected var _xOffset : Number;
		protected var _yOffset : Number;
		protected var _swfClass : String;
		protected var _limits : Array;
		protected var _levels : Array;
		protected var _costCoin : int;
		protected var _beanClass : String;
		
		protected var _levelInfoClass : Class;
		
		public function ConfigConstruction()
		{
		}

		override public function parseData(data:XML):void
		{
			_typeId = XmlUtil.getAttributeAsNumber(data, "typeId");
			_swfClass = XmlUtil.getAttributeAsString(data, "swfClass");
			_name = XmlUtil.getAttributeAsString(data, "name");
			_beanClass = XmlUtil.getAttributeAsString(data, "beanClass", null, true);
			
			_xOffset = XmlUtil.getAttributeAsNumber(data, "x");
			_yOffset = XmlUtil.getAttributeAsNumber(data, "y");
			
			_grid = new RhombusGrid(ConfigMapInfo.instance.cell as Rhombus,
				XmlUtil.getAttributeAsNumber(data, "column"),
				XmlUtil.getAttributeAsNumber(data, "row"));
			
			_limits = [];
			var xmlList : XMLList = data.limitation;
			for each(var child : XML in xmlList)
			{
				_limits[int(XmlUtil.getAttributeAsNumber(child, "level"))] = int(XmlUtil.getAttributeAsNumber(child, "number"));
			}
			
			if(_levelInfoClass == null)
			{
				_levelInfoClass = ConfigLevelInfo;
			}
			
			_levels = []
			for each(child in data.level)
			{
				var level : ConfigLevelInfo = new _levelInfoClass();
				level.parseData(child);
				_levels[level.id] = level;
			}
		}
		
		public function getDisplayContent() : DisplayObject
		{
			return UIUtil.getDisplayObject(getQualifiedClassName(Res) + "_" + _swfClass);
		}
		
		public function createConsturction() : ObjectConstruction
		{
			return new ObjectConstruction(this);
		}
		
		public function getLimitedNumber(townHallLevel : int) : int
		{
			return _limits[townHallLevel];
		}
		
		public function getLevelInfo(id : int) : ConfigLevelInfo
		{
			return _levels[id];
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get swfClass():String
		{
			return _swfClass;
		}

		public function get xOffset():Number
		{
			return _xOffset;
		}

		public function get yOffset():Number
		{
			return _yOffset;
		}

		public function get grid():Grid
		{
			return _grid;
		}

		public function get costCoin():int
		{
			return _costCoin;
		}

		public function get beanClass():String
		{
			return _beanClass;
		}


	}
}
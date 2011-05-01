package com.ggshily.game.monsters.config
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.geom.Parallelogram;
	import com.ggshily.game.geom.Rhombus;

	public class ConfigMapInfo
	{
		private static var _instance : ConfigMapInfo;
		
		private var _cell : Parallelogram;
		
		public function ConfigMapInfo()
		{
			_cell = new Rhombus(4, 2);
		}
		
		public static function get instance() : ConfigMapInfo
		{
			if(_instance == null)
			{
				_instance = new ConfigMapInfo();
			}
			return _instance;
		}

		public function get cell():Rhombus
		{
			return _cell as Rhombus;
		}

	}
}
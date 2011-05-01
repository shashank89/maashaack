package com.ggshily.game.monsters.config
{
	import com.ggshily.game.util.UIUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	

	public class ConfigMonster extends ConfigConstruction
	{
		
		
		public function ConfigMonster()
		{
			_levelInfoClass = ConfigLevelInfoMonster;
		}
		
		override public function parseData(data:XML):void
		{
			super.parseData(data);
		}
		
		override public function getDisplayContent() : DisplayObject
		{
			var mc : MovieClip = UIUtil.getDisplayObject(_swfClass) as MovieClip;
			mc.gotoAndStop(1);
			return mc;
		}
		
	}
}
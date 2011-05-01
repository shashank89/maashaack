package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterHatchery;
	import com.ggshily.game.util.UIUtil;
	
	import flash.display.MovieClip;
	
	public class PanelHatchery extends PanelBase
	{
		private static const MC : String = "HATCHERYPOPUP_CLIP";
		
		private var _mc : MovieClip;
		private var _hatchery : ObjectConstructionMonsterHatchery;
		
		public function PanelHatchery(world:WorldBase, hatchery : ObjectConstructionMonsterHatchery)
		{
			super(world);
			
			_hatchery = hatchery;
			
		}
		
		override protected function init():void
		{
			_mc = _displayContent.addChild(UIUtil.getDisplayObject(MC)) as MovieClip;
			
			
		}
	}
}
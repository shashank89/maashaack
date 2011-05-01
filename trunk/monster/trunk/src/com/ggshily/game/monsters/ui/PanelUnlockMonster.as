package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterUnlocker;
	
	public class PanelUnlockMonster extends PanelBase
	{
		private var _constructionUnlocker : ObjectConstructionMonsterUnlocker;
		
		public function PanelUnlockMonster(world:WorldBase, unlocker : ObjectConstructionMonsterUnlocker)
		{
			super(world);
			
			_constructionUnlocker = unlocker;
		}
		
		
	}
}
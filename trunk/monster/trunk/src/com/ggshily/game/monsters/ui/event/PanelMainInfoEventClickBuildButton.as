package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.ui.PanelConstructionShop;
	import com.ggshily.game.monsters.world.WorldOwnCity;

	public class PanelMainInfoEventClickBuildButton extends PanelMainInfoEvent
	{
		public function PanelMainInfoEventClickBuildButton()
		{
			super(CLICK_BUILD_BUTTON, false, false);
		}
		
		override public function process(world:WorldBase):void
		{
			if((world.getObjectChild(WorldOwnCity.CHILD_GAME_MAP) as GameMap).state == GameMap.STATE_BUILD_CONSTRUCTION)
			{
				// cancle building
			}
			else
			{
				world.showPanel(new PanelConstructionShop(world));
			}
		}
	}
}
package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.world.WorldOwnCity;

	public class PanelConstructionMenuEventMove extends PanelConstructionMenuEvent
	{
		public function PanelConstructionMenuEventMove()
		{
			super(MOVE);
		}
		
		override public function process(world:WorldBase):void
		{
			(world.getObjectChild(WorldOwnCity.CHILD_GAME_MAP) as GameMap).moveConstruction();
		}
	}
}
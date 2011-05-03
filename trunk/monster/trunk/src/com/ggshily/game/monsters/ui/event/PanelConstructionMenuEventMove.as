package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.world.WorldOwnCity;

	public class PanelConstructionMenuEventMove extends PanelConstructionMenuEvent
	{
		private var _construction : ObjectConstruction;
		
		public function PanelConstructionMenuEventMove(construnction : ObjectConstruction)
		{
			super(MOVE);
			
			_construction = construnction;
		}
		
		override public function process(world:WorldBase):void
		{
			(world.getObjectChild(WorldOwnCity.CHILD_GAME_MAP) as GameMap).moveConstruction(_construction);
		}
	}
}
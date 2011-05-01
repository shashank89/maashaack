package com.ggshily.game.monsters.ui.event
{
	public class PanelConstructionMenuEvent extends PanelEvent
	{
		public static const MOVE : String = "MOVE";
		public static const UPGRADE : String = "UPGRADE";
		
		public function PanelConstructionMenuEvent(type : String)
		{
			super(type);
		}
	}
}
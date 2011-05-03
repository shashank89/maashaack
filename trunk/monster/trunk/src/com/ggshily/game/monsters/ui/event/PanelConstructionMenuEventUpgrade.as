package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.ObjectConstruction;

	public class PanelConstructionMenuEventUpgrade extends PanelConstructionMenuEvent
	{
		private var _construction : ObjectConstruction;
		
		public function PanelConstructionMenuEventUpgrade(construction : ObjectConstruction)
		{
			super(UPGRADE);
			
			_construction = construction;
		}
		
		override public function process(world:WorldBase):void
		{
			trace("process upgrade event");
		}
	}
}
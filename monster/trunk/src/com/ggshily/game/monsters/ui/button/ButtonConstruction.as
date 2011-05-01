package com.ggshily.game.monsters.ui.button
{
	import com.ggshily.game.monsters.config.ConfigBase;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.ui.ButtonBase;
	import com.ggshily.game.monsters.ui.PanelBase;
	import com.ggshily.game.monsters.ui.event.PanelConstructionShopEventBuildConstruction;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonConstruction extends ButtonBase
	{
		private var _config : ConfigConstruction;
		
		public function ButtonConstruction(button:MovieClip, panel:PanelBase, config : ConfigConstruction)
		{
			super(button, panel);
			
			_config = config;
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			_panel.dispatchEvent(new PanelConstructionShopEventBuildConstruction(_config, _panel));
		}
	}
}
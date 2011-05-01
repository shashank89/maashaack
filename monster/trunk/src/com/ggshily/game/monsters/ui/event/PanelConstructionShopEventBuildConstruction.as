package com.ggshily.game.monsters.ui.event
{
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.ui.PanelBase;
	import com.ggshily.game.monsters.ui.PanelConstructionShop;
	import com.ggshily.game.monsters.ui.PanelSimpleMessage;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.monsters.world.WorldOwnCity;

	public class PanelConstructionShopEventBuildConstruction extends PanelConstructionShopEvent
	{
		private var _constructionConfig : ConfigConstruction;
		private var _panel : PanelBase
		
		public function PanelConstructionShopEventBuildConstruction(construction : ConfigConstruction, panel : PanelBase)
		{
			super(BUILD_CONSTRUCTION);
			
			_constructionConfig = construction;
			_panel = panel;
		}
		
		override public function process(world:WorldBase):void
		{
			var mapObject : ObjectConstruction = _constructionConfig.createConsturction();
			
			var maxNumber : int = _constructionConfig.getLimitedNumber((world as WorldOwnCity).gameMap.townHall.level);
			var currentNumber : int = (world as WorldOwnCity).gameMap.getConstructionsByTypeId(_constructionConfig.typeId).length;
			if(maxNumber > currentNumber && UserManager.instance.canBuild(_constructionConfig))
			{
				(world.getObjectChild(WorldOwnCity.CHILD_GAME_MAP) as GameMap).startDrag(mapObject);
				_panel.dispatchEvent(new PanelEventHide(_panel));
			}
			else
			{
				world.showPanel(new PanelSimpleMessage(world, "Warning!", "you have not enough coin or resource or you reached the limitation!"), true);
			}
			_constructionConfig = null;
		}
	}
}
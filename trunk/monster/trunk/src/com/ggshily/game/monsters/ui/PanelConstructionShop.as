package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigConstructionMaterial;
	import com.ggshily.game.monsters.config.ConfigConstructionMonsterHatchery;
	import com.ggshily.game.monsters.config.ConfigConstructionMonsterHousing;
	import com.ggshily.game.monsters.config.ConfigConstructionStorage;
	import com.ggshily.game.monsters.config.ConfigConstructionTownHall;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.core.CONSTANT;
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.button.ButtonClose;
	import com.ggshily.game.monsters.ui.button.ButtonConstruction;
	import com.ggshily.game.monsters.ui.component.SimpleScrollButton;
	import com.ggshily.game.monsters.ui.event.PanelConstructionShopEvent;
	import com.ggshily.game.monsters.ui.event.PanelConstructionShopEventBuildConstruction;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.util.UIUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PanelConstructionShop extends PanelBase
	{
		private static const MC : String = "BUILDINGSPOPUP_CLIP";
		private static const CONSTRUCTION_BUTTON : String  = "BUILDINGBUTTON_CLIP";
		
		private static const ONE_PAGE_NUMBER : int = 10;
		private static const ONE_LINE_NUMBER : int = 5;
		
		private static const CONSTRUCTION_START_X : int = 60;
		private static const CONSTRUCTION_START_Y : int = 115;
		private static const CONSTRUCTION_OFFSET_X : int = 130;
		private static const CONSTRUCTION_OFFSET_Y : int = 170;
		
		private var _configs : Array;
		private var _mc : MovieClip;
		private var _scrollButton : SimpleScrollButton;
		private var _buttons : Vector.<ButtonConstruction>;
		
		private var closeButton : ButtonClose;
		
		public function PanelConstructionShop(world : WorldBase)
		{
			super(world);
			
			world.addEvent(this, PanelConstructionShopEvent.BUILD_CONSTRUCTION);
			
			
		}
		
		override protected function init():void
		{
			_configs = ConfigMain.instance.getMultyConfigs(
				[
					ConfigConstructionMaterial,
					ConfigConstructionStorage,
					ConfigConstructionMonsterHatchery,
					//					ConfigConstuctionMonsterUnlocker,
					ConfigConstructionMonsterHousing
				]);
			
			_mc = _displayContent.addChild(UIUtil.getDisplayObject(MC)) as MovieClip;
			_mc.gotoAndStop(1);
			
			var closeButtonMc : MovieClip = _displayContent.addChild(UIUtil.getDisplayObject(CONSTANT.UI_CLOSE_BUTTON)) as MovieClip;
//			closeButtonMc.x = _mc.width;
			closeButton = new ButtonClose(closeButtonMc, this);
			
			var totalPage : int = Math.ceil(_configs.length / ONE_PAGE_NUMBER);
			_scrollButton = new SimpleScrollButton(_mc.bPrevious, _mc.bNext, totalPage, updateList);
			
			_mc.bPrevious.gotoAndStop(totalPage > 1 ? 2 : 1);
			_mc.bNext.gotoAndStop(totalPage > 1 ? 2 : 1);
			
			_buttons = new Vector.<ButtonConstruction>();
			var length : int = Math.min(_configs.length, ONE_PAGE_NUMBER);
			for(var i : int = 0; i < length; ++i)
			{
				addConstruction((_configs[i] as ConfigConstruction),
					CONSTRUCTION_START_X + CONSTRUCTION_OFFSET_X * (i % ONE_LINE_NUMBER),
					CONSTRUCTION_START_Y + CONSTRUCTION_OFFSET_Y * int(i / ONE_LINE_NUMBER));
			}
		}
		
		private function addConstruction(config : ConfigConstruction, x : Number, y : Number) : void
		{
			
			var buttonMc : MovieClip = UIUtil.getDisplayObject(CONSTRUCTION_BUTTON) as MovieClip;
			_buttons.push(new ButtonConstruction(buttonMc, this, config));
			buttonMc.x = x;
			buttonMc.y = y;
			buttonMc.mcNew.visible = false;
			buttonMc.mcSale.visible = false;
			buttonMc.tName.text = config.name;
			_mc.addChild(buttonMc);
			
			var icon : DisplayObject = config.getDisplayContent();
			UIUtil.scaleTo(icon, 118, 100);
			icon.y = 35;
			buttonMc.addChild(icon);
			
			var maxNumber : int = config.getLimitedNumber(UserManager.instance.currentUser.getBuildingsByTypeId(ConfigConstructionTownHall.TYPE_ID)[0].level);
			var currentNumber : int = UserManager.instance.currentUser.getBuildingsByTypeId(config.typeId).length;
			buttonMc.tQuantity.text = currentNumber + "/" + maxNumber;
		}
		
		private function updateList(pageIndex : int) : void
		{
			
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			var index : int = displayContent.getChildIndex(e.currentTarget as DisplayObject);
			trace(index);

			dispatchEvent(new PanelConstructionShopEventBuildConstruction(_configs[index], this));
			
		}
		
		private function rollOverHandler(e : MouseEvent) : void
		{
			trace("mouseover");
			var building : DisplayObject = (e.currentTarget as DisplayObject);
			building.scaleX = building.scaleY = 1.2;
		}
		
		private function rollOutHandler(e : MouseEvent) : void
		{
			var building : DisplayObject = (e.currentTarget as DisplayObject);
			building.scaleX = building.scaleY = 1;
		}
	}
}
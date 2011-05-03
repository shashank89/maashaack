package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.map.ObjectConstruction;
	import com.ggshily.game.monsters.ui.event.PanelConstructionMenuEvent;
	import com.ggshily.game.monsters.ui.event.PanelConstructionMenuEventMove;
	import com.ggshily.game.monsters.ui.event.PanelConstructionMenuEventUpgrade;
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PanelConstructionMenu extends PanelBase
	{
		private var _construction : ObjectConstruction
		private var _isInit : Boolean;
		private var _buttons : Array;
		
		public function PanelConstructionMenu(world:WorldBase)
		{
			super(world);
			
			world.addEvent(this, PanelConstructionMenuEvent.MOVE);
			world.addEvent(this, PanelConstructionMenuEvent.UPGRADE);
		}
		
		public function setConstruction(construction : ObjectConstruction) : void
		{
			_construction = construction;
			
			show();
		}
		
		override protected function init():void
		{
			_displayContent.x = _construction.grid.x;
			_displayContent.y = _construction.grid.y;
			
			if(!_isInit)
			{
				_buttons = [];
				
				var x : int = 0;
				var y : int = 0;
				
				var button : Sprite = UIUtil.createButton("Move", x, y);
				_displayContent.addChild(button);
				Util.addEventListener(button, MouseEvent.CLICK, clickHandler);
				_buttons.push(button);
				
				y += 40;
				button = UIUtil.createButton("Upgrade", x, y);
				_displayContent.addChild(button);
				Util.addEventListener(button, MouseEvent.CLICK, clickHandler);
				_buttons.push(button);
				
				_isInit = true;
			}	
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			if(e.currentTarget.name == "Move")
			{
				dispatchEvent(new PanelConstructionMenuEventMove(_construction));
			}
			else if(e.currentTarget.name == "Upgrade")
			{
				dispatchEvent(new PanelConstructionMenuEventUpgrade(_construction));
			}
			
			hide();
		}
	}
}
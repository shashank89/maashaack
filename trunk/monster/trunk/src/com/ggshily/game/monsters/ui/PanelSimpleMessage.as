package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.event.PanelSimpleMessageEvent;
	import com.ggshily.game.monsters.ui.event.PanelSimpleMessageEventClose;
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PanelSimpleMessage extends PanelBase
	{
		private var _title : String;
		private var _content : String;
		
		public function PanelSimpleMessage(world:WorldBase, title : String, content : String)
		{
			super(world);
			
			world.addEvent(this, PanelSimpleMessageEvent.CLOSE);
			
			_title = title;
			_content = content;
		}
		
		override protected function init():void
		{
			_displayContent.addChild(UIUtil.createTextField(_title, GameEngine.WIDTH / 2 - 100, GameEngine.HEIGHT / 2));
			_displayContent.addChild(UIUtil.createTextField(_content, 50, GameEngine.HEIGHT / 2 + 50));
			
			var closeButton : Sprite = UIUtil.createButton("close", GameEngine.WIDTH / 2, GameEngine.HEIGHT / 2 + 100);
			_displayContent.addChild(closeButton);
			
			Util.addEventListener(closeButton, MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			dispatchEvent(new PanelSimpleMessageEventClose(this));
		}
	}
}
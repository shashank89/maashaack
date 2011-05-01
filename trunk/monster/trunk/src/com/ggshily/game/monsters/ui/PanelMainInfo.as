package com.ggshily.game.monsters.ui
{
	import com.ggshily.game.monsters.bean.Material;
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.ui.event.PanelMainInfoEvent;
	import com.ggshily.game.monsters.ui.event.PanelMainInfoEventClickBuildButton;
	import com.ggshily.game.monsters.ui.event.PanelMainInfoEventOpenMap;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.util.UIUtil;
	import com.ggshily.game.util.Util;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PanelMainInfo extends PanelBase
	{
		private static const TOP_MC : String = "UI_TOP_CLIP";
		private static const MATERIAL_POPUP : String = "bubblepopup3_CLIP";
		
		private var _topMc : MovieClip;
		private var _resourcesMc : Vector.<MovieClip>;
		
		public function PanelMainInfo(world : WorldBase, name : String)
		{
			super(world);
			
			_name = name;
			
		
			world.addEvent(this, PanelMainInfoEvent.CLICK_BUILD_BUTTON);
			world.addEvent(this, PanelMainInfoEvent.CLICK_MAP_BUTTON);
		}
		
		override protected function init():void
		{
			_topMc = _displayContent.addChild(UIUtil.getDisplayObject(TOP_MC)) as MovieClip;
			_topMc.gotoAndStop(1);
			_topMc.x = 10;
			_topMc.y = 10;
			
			_topMc.mc.mcPoints.gotoAndStop(1);
			_topMc.mcSave.gotoAndStop(1);
			_topMc.mcZoom.gotoAndStop(1);
			_topMc.mcSound.gotoAndStop(1);
			
			_resourcesMc = new Vector.<MovieClip>();
			
			_resourcesMc.push(_topMc.mc.mcR1);
			_resourcesMc.push(_topMc.mc.mcR2);
			_resourcesMc.push(_topMc.mc.mcR3);
			_resourcesMc.push(_topMc.mc.mcR4);
			
			var x : Number = 0;
			var y : Number = 10;
			
			
			x = GameEngine.WIDTH - 100;
			y = GameEngine.HEIGHT - 200;
			addButton("map", x, y);
			x -= 50;
			addButton("build", x, y);
		}
		
		private function addTextField(text : String, x : Number, y : Number, add : Boolean = true) : TextField
		{
			var tf : TextField = UIUtil.createTextField(text, x, y);
			if(add)
			{
				_displayContent.addChild(tf);
			}
			
			return tf;
		}
		
		private function addButton(name : String, x : Number, y : Number) : void
		{
			var button : Sprite = UIUtil.createButton(name, x, y);
			
			_displayContent.addChild(button);
			
			Util.addEventListener(button, MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e : MouseEvent) : void
		{
			if(e.currentTarget.name == "build")
			{
				dispatchEvent(new PanelMainInfoEventClickBuildButton());
			}
			else if(e.currentTarget.name == "map")
			{
				dispatchEvent(new PanelMainInfoEventOpenMap());
			}
		}
		
		override public function tick(currentTime:Number):void
		{
			for(var i : int = 0; i < UserManager.instance.currentUser.materials.length; ++i)
			{
				var material : Material = UserManager.instance.currentUser.materials[i];
				_resourcesMc[i].tR.text = material.amount.toString();
				
				var percent : int = Math.min(material.amount / material.capacity * 100, 100);
				_resourcesMc[i].mcBar.width = percent;
			}
		}
	}
}
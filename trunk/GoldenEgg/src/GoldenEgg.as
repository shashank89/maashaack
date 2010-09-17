package
{
	import com.ggshily.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	
	[SWF(width="550", height="314", backgroundColor="#ffffff", frameRate="30",allowFullScreen="true")]
	public class GoldenEgg extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/asset.swf";
		public static const MC_HAMMER : String = "chuizi";
		public static const MC_EGGS : Array = ["egg1", "egg2", "egg3"];
		public static const MC_EGGS_BG : Array = ["egg1_bg", "egg2_bg", "egg3_bg"];
		public static const MC_RESULT : String = "mc_result";
		public static const MC_ANIM : String = "lihua";
		
		private var main : MovieClip;
		private var hammer : MovieClip;
		private var result : MovieClip;
		private var eggs : Array;
		private var eggs_bg : Array;
		private var maskSprite : Sprite;
		
		private var isKickingEgg : Boolean;
		
		public function GoldenEgg()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(e : Event) : void
		{
			try
			{
				var cm : ContextMenu = new ContextMenu();
				cm.hideBuiltInItems();
				contextMenu=cm;
				
				tabChildren = false;
				tabEnabled = false;
				
				Mouse.hide();
			}
			catch(e:Error)
			{
			}
			
			var loader : Loader = new Loader();
			Util.addEventListener(loader.contentLoaderInfo, Event.COMPLETE, loadCompleteHandler);
			Util.addEventListener(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(ASSET_FILE), new LoaderContext(false, ApplicationDomain.currentDomain));
		}

		private function loadCompleteHandler(e : Event) : void
		{
			main = e.target.content;
			addChild(main);

			init();
		}

		private function IOErrorHandler(e : Event) : void
		{
			trace(e);
		}

		private function init() : void
		{
			hammer = main[MC_HAMMER];
			hammer.mouseEnabled = false;
			
			result = main[MC_RESULT];
			result.gotoAndStop(1);
			result.visible = false;
			result.mouseEnabled = false;
			
			main[MC_ANIM].visible = false;
			main[MC_ANIM].mouseEnabled = false;
			
			eggs = [];
			for(var i : int = 0; i < MC_EGGS.length; i++)
			{
				var egg : MovieClip = main[MC_EGGS[i]];
				Util.addEventListener(egg, MouseEvent.CLICK, clickHandler);
				Util.addEventListener(egg, MouseEvent.MOUSE_OVER, mouseOverHandler);
				Util.addEventListener(egg, MouseEvent.MOUSE_OUT, mouseOutHandler);
				eggs.push(egg);
			}
			
			eggs_bg = [];
			for(i = 0; i < MC_EGGS_BG.length; i++)
			{
				var bg : MovieClip = main[MC_EGGS_BG[i]];
				bg.visible = false;
				eggs_bg.push(bg);
			}
			
			addEventListener(Event.ENTER_FRAME, tickFrame);
		}

		private function tickFrame(e : Event) : void
		{
			if(!isKickingEgg)
			{
				hammer.x = mouseX;
				hammer.y = mouseY;
			}
			
			isKickingEgg = hammer.currentFrame != 1;
		}

		private function clickHandler(e : MouseEvent) : void
		{
			var index : int = eggs.indexOf(e.currentTarget);
			eggs[index].gotoAndPlay(2);
			trace("select " + index);
			
			var loader : URLLoader = new URLLoader();
			Util.addEventListener(loader, Event.COMPLETE, getResult);
			Util.addEventListener(loader, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(getUrl(index)));
			
			hammer.gotoAndPlay(2);
			
//			addMask();
		}

		private function addMask() : void
		{
			if(!maskSprite)
			{
				maskSprite = new Sprite();
				maskSprite.graphics.beginFill(0xFFFFFF, 1.0);
				maskSprite.graphics.drawRect(0, 0, width, height);
				maskSprite.graphics.endFill();
			}
			addChild(maskSprite);
		}

		private function removeMask() : void
		{
			if(getChildIndex(maskSprite) != -1)
			{
				removeChild(maskSprite);
			}
		}

		private function getUrl(index : int) : String
		{
			return "";
		}

		private function getResult(e : Event) : void
		{
			
		}

		private function mouseOverHandler(e : MouseEvent) : void
		{
			eggs_bg[eggs.indexOf(e.currentTarget)].visible = true;
		}

		private function mouseOutHandler(e : MouseEvent) : void
		{
			eggs_bg[eggs.indexOf(e.currentTarget)].visible = false;
		}
	}
}
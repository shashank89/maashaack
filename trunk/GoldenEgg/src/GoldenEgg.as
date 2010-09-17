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
	import flash.utils.getDefinitionByName;
	
	[SWF(width="550", height="314", backgroundColor="#ffffff", frameRate="30",allowFullScreen="true")]
	public class GoldenEgg extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/asset.swf";
		public static const MC_HAMMER : String = "chuizi";
		public static const MC_EGGS : Array = ["egg1", "egg2", "egg3"];
		public static const MC_RESULT : String = "mc_result";
		
		private var main : MovieClip;
		private var hammer : MovieClip;
		private var result : MovieClip;
		private var eggs : Array;
		private var maskSprite : Sprite;
		
		private var isKickingEgg : Boolean;
		
		public function GoldenEgg()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(e : Event) : void
		{
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
			result = main[MC_RESULT];
			result.gotoAndStop(1);
			result.visible = false;
			result.mouseEnabled = false;
			
			eggs = [];
			for(var i : int = 0; i < MC_EGGS.length; i++)
			{
				var egg : MovieClip = main[MC_EGGS[i]];
				Util.addEventListener(egg, MouseEvent.CLICK, clickHandler);
				Util.addEventListener(egg, MouseEvent.MOUSE_OVER, mouseOverHandler);
				Util.addEventListener(egg, MouseEvent.MOUSE_OUT, mouseOutHandler);
				eggs.push(egg);
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
			var index : int = eggs.indexOf(e.target);
			eggs[index].gotoAndPlay(2);
			trace("select " + index);
			
			var loader : URLLoader = new URLLoader();
			Util.addEventListener(loader, Event.COMPLETE, getResult);
			Util.addEventListener(loader, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(getUrl(index)));
			
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
			
		}

		private function mouseOutHandler(e : MouseEvent) : void
		{
			
		}
	}
}
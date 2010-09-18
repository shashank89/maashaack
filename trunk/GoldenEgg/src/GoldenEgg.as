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
	
	[SWF(width="550", height="314", backgroundColor="#ffffff", frameRate="16",allowFullScreen="true")]
	public class GoldenEgg extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/asset.swf";
		public static const MC_HAMMER : String = "chuizi";
		public static const MC_EGGS : Array = ["egg1", "egg2", "egg3"];
		public static const MC_EGGS_BG : Array = ["egg1_bg", "egg2_bg", "egg3_bg"];
		public static const MC_RESULT : String = "mc_result";
		public static const MC_ANIM : String = "lihua";
		public static const RESULT_DESC : String = "mc_desc";
		public static const RESULT_TF : String = "tf_desc";
		public static const BTN_RESTART : String = "bn_restart";
		public static const BTN_CLOSE : String = "bn_close";
		
		public static const VAR_URL : String = "url";
		public static const VAR_USERNAME : String = "username";
		public static const VAR_CHANNEL : String = "channel";
		public static const VAR_INDEX : String = "index";
		public static const VAR_ASSET : String = "asset";
		
		private var main : MovieClip;
		private var hammer : MovieClip;
		private var result : MovieClip;
		private var eggs : Array;
		private var eggs_bg : Array;
		private var maskSprite : Sprite;
		
		private var curIndex : int;
		private var isKickingEgg : Boolean;
		private var url : String;
		private var userName : String;
		private var channel : String;
		
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
			
			url = stage.loaderInfo.parameters[VAR_URL];
			userName = stage.loaderInfo.parameters[VAR_USERNAME];
			channel = stage.loaderInfo.parameters[VAR_CHANNEL];
			
			var assetFile : String = stage.loaderInfo.parameters[VAR_ASSET] || ASSET_FILE; 
			
			var loader : Loader = new Loader();
			Util.addEventListener(loader.contentLoaderInfo, Event.COMPLETE, loadCompleteHandler);
			Util.addEventListener(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(assetFile), new LoaderContext(false, ApplicationDomain.currentDomain));
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
			Util.addEventListener(hammer, Event.ENTER_FRAME, hammerFrameHandler);
			
			result = main[MC_RESULT];
			result.gotoAndStop(1);
			result.visible = false;
			result.mouseEnabled = false;
			
			addMask();
			addChild(result);
			addChild(hammer);
			
			maskSprite.mouseEnabled = false;
			
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
			
			Util.addEventListener(result[BTN_RESTART], MouseEvent.CLICK, restartGame);
			Util.addEventListener(result[BTN_CLOSE], MouseEvent.CLICK, closeGame);
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

		private function hammerFrameHandler(e : Event) : void
		{
			if(hammer.currentFrame == hammer.totalFrames)
			{
				eggs[curIndex].gotoAndPlay(2);
			}
		}

		private function clickHandler(e : MouseEvent) : void
		{
			curIndex = eggs.indexOf(e.currentTarget);
			trace("select " + curIndex);
			eggs_bg[curIndex].visible = false;
			
			var loader : URLLoader = new URLLoader();
			Util.addEventListener(loader, Event.COMPLETE, getResult);
			Util.addEventListener(loader, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(getUrl(curIndex)));
			
			hammer.gotoAndPlay(2);
			
			main[MC_ANIM].visible = true;
			main[MC_ANIM].gotoAndPlay(1);
			
//			getResult(null);
			
			maskSprite.mouseEnabled = true;
		}

		private function closeGame(e : Event) : void
		{
			
		}

		private function restartGame(e : Event) : void
		{
			result.gotoAndStop(1);
			result.visible = false;
			
			for each(var egg : MovieClip in eggs)
			{
				egg.gotoAndStop(1);
			}
			
			maskSprite.mouseEnabled = false;
		}

		private function addMask() : void
		{
			if(!maskSprite)
			{
				maskSprite = new Sprite();
				maskSprite.graphics.beginFill(0xFFFFFF, 0.0);
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
			var requestURL : String = url;
			if(requestURL.charAt(requestURL.length - 1) != "/")
			{
				requestURL += "/";
			}
			requestURL += "&" + VAR_USERNAME + "=" + userName + "&" + VAR_CHANNEL + "="
				+ channel + "&" + VAR_INDEX + "=" + index;
			return requestURL;
		}

		private function getResult(e : Event) : void
		{
			result[RESULT_DESC][RESULT_TF].text = e.currentTarget.data;
			result.visible = true;
			result.gotoAndPlay(1);
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
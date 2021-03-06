package
{
	import com.ggshily.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	[SWF(width="550", height="314", backgroundColor="#ffffff", frameRate="16",allowFullScreen="true")]
	public class GoldenEgg extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/asset.swf";
		public static const MC_HAMMER : String = "chuizi";
		public static const MC_EGGS : Array = ["egg3", "egg2", "egg1"];
		public static const MC_EGGS_BG : Array = ["egg3_bg", "egg2_bg", "egg1_bg"];
		public static const MC_EGGS_ANIM : Array = ["lihua2", "lihua1", "lihua0"];
		public static const MC_RESULT : String = "mc_result";
		public static const MC_ANIM : String = "lihua";
		public static const RESULT_DESC : String = "mc_desc";
		public static const RESULT_TF : String = "tf_desc";
		public static const BTN_RESTART : String = "bn_restart";
		public static const BTN_CLOSE : String = "bn_close";
		public static const BTN_OPEN : String = "bn_open";
		public static const BTN_LOGIN : String = "bn_login";
		
		public static const VAR_URL : String = "url";
		public static const VAR_USERNAME : String = "username";
		public static const VAR_CHANNEL : String = "channel";
		public static const VAR_INDEX : String = "index";
		public static const VAR_ASSET : String = "asset";
		public static const VAR_OPEN_URL : String = "open_url";
        public static const VAR_IS_LOGIN:String = "islogin";
        public static const VAR_LOGIN_URL:String = "loginurl";
		
		private var main : MovieClip;
		private var hammer : MovieClip;
		private var result : MovieClip;
		private var eggs : Array;
		private var eggs_bg : Array;
		private var eggs_anim : Array;
		private var maskSprite : Sprite;
		
		private var msg : String = "";
		private var type : String = "";
		private var pid : String = "";
		private var openUrl : String;
        private var loginUrl:String = "";
		
		private var curIndex : int;
		private var isKickingEgg : Boolean;
		private var url : String;
		private var userName : String;
		private var channel : String;
        private var isLogin:Boolean;
		
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
			openUrl = stage.loaderInfo.parameters[VAR_OPEN_URL];
            isLogin = stage.loaderInfo.parameters[VAR_IS_LOGIN] != "false";
            loginUrl = stage.loaderInfo.parameters[VAR_LOGIN_URL];
			
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
			
			eggs_anim = [];
			for(i = 0; i < MC_EGGS_ANIM.length; i++)
			{
				var anim : MovieClip = main[MC_EGGS_ANIM[i]];
				anim.mouseEnabled = false;
				eggs_anim.push(anim);
			}
			
			addEventListener(Event.ENTER_FRAME, tickFrame);
			
			Util.addEventListener(result[BTN_RESTART], MouseEvent.CLICK, restartGame);
			Util.addEventListener(result[BTN_CLOSE], MouseEvent.CLICK, closeGame);
			Util.addEventListener(result[BTN_OPEN], MouseEvent.CLICK, closeGame);
			Util.addEventListener(result[BTN_LOGIN], MouseEvent.CLICK, closeGame);
		}

		private function tickFrame(e : Event) : void
		{
			if(!isKickingEgg)
			{
				hammer.x = mouseX;
				hammer.y = mouseY;
			}
			else
			{
				eggs_bg[curIndex].visible = false;
			}
			
			isKickingEgg = hammer.currentFrame != 1;
		}

		private function hammerFrameHandler(e : Event) : void
		{
			if(hammer.currentFrame == hammer.totalFrames)
			{
				eggs[curIndex].gotoAndPlay(2);
				eggs_anim[curIndex].gotoAndPlay(2);
			}
		}

		private function clickHandler(e : MouseEvent) : void
		{
			curIndex = eggs.indexOf(e.currentTarget);
			trace("select " + curIndex);
			eggs_bg[curIndex].visible = false;
			
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			Util.addEventListener(loader, Event.COMPLETE, getResult);
			Util.addEventListener(loader, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(getUrl(curIndex)));
			
			hammer.gotoAndPlay(2);
			
			/*main[MC_ANIM].visible = true;
			main[MC_ANIM].gotoAndPlay(1);*/
			
//			getResult(null);
			
			maskSprite.mouseEnabled = true;
		}

		private function closeGame(e : Event) : void
		{
//			navigateToURL(new URLRequest("javascript:window.close();"), "_top");
//			navigateToURL(new URLRequest("javascript:window.location.reload();"), "_top");
			if(!isLogin)

			{
				navigateToURL(new URLRequest(loginUrl), "_top");
				return;
			}
			if(type == "2")
			{
				navigateToURL(new URLRequest(openUrl + "?pid=" + pid + "&id=" + getTimer()), "_top");
			}
		}

		private function restartGame(e : Event) : void
		{
			navigateToURL(new URLRequest("javascript:window.location.reload();"), "_top");
			/*result.gotoAndStop(1);
			result.visible = false;
			
			for each(var egg : MovieClip in eggs)
			{
				egg.gotoAndStop(1);
			}
			for each(var anim : MovieClip in eggs_anim)
			{
				anim.gotoAndStop(1);
			}
			
			maskSprite.mouseEnabled = false;*/
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
			/*if(requestURL.charAt(requestURL.length - 1) != "/")
			{
				requestURL += "/";
			}*/
			requestURL += "?" + VAR_USERNAME + "=" + userName + "&" + VAR_CHANNEL + "="
				+ channel + "&" + "egg=" + (index + 1) + "&id=" + (new Date().time);
			return requestURL;
		}

		private function getResult(e : Event) : void
		{
			var data : ByteArray = e.currentTarget.data;
			var resultStr : String = data.readUTFBytes(data.bytesAvailable);
			
			resultStr = resultStr.substr(2);
			var arr : Array = resultStr.split("&");
			for each(var str : String in arr)
			{
				if(str.indexOf("message=") == 0)
				{
					msg = str.substr("message=".length);
				}
				else if(str.indexOf("type=") == 0)
				{
					type = str.substr("type=".length);
				}
				else if(str.indexOf("pid=") == 0)
				{
					pid = str.substr("pid=".length);
				}
			}
			
			result[RESULT_DESC][RESULT_TF].text = msg;
			result[BTN_OPEN].visible = type == "2";
			
			result.visible = true;
			result.gotoAndPlay(1);
            if (isLogin)
            {
                result[BTN_OPEN].visible = type == "2";
                result[BTN_LOGIN].visible = false;
            }
            else
            {
                result[BTN_OPEN].visible = false;
                result[BTN_LOGIN].visible = true;
                result[RESULT_DESC][RESULT_TF].text = "请登录";
            }
		}

		private function mouseOverHandler(e : MouseEvent) : void
		{
			eggs_bg[eggs.indexOf(e.currentTarget)].visible = true;
			trace("over");
		}

		private function mouseOutHandler(e : MouseEvent) : void
		{
			eggs_bg[eggs.indexOf(e.currentTarget)].visible = false;
		}
	}
}
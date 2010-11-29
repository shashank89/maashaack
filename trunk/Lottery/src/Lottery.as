package
{
	import com.ggshily.util.Util;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	[SWF(width="910", height="270", backgroundColor="#fbd380", frameRate="16",allowFullScreen="true")]
	public class Lottery extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/asset.swf";
		public static const MC_RESULT : String = "mc_result";
		public static const MC_ANIM : String = "lihua";
		public static const RESULT_DESC : String = "mc_desc";
		public static const RESULT_TF : String = "_tf";
		public static const BTN_OK : String = "bn_ok";
		public static const BTN_CLOSE : String = "bn_close";
		public static const SLOT_PREFIX : String = "h";
		public static const BTN_LEFT : String = "bn_left";
		public static const BTN_RIGHT : String = "bn_right";
		public static const BTN_OPEN : String = "bn_open";
		
		public static const VAR_URL : String = "url";
		public static const VAR_USERNAME : String = "username";
		public static const VAR_CHANNEL : String = "channel";
		public static const VAR_INDEX : String = "index";
		public static const VAR_ASSET : String = "asset";
		public static const VAR_OPEN_URL : String = "open_url";
		public static const VAR_IS_LOGIN : String = "islogin";
		public static const VAR_LOGIN_URL : String = "loginurl";
		
		public static const OFFSET : int = -100;
		public static const SLOT_NUMBER : int = 10;
		public static const SLOT_WIDTH : int = 133;
		public static const START_POSITION : int = 0;
		public static const AREA_WIDTH : int = SLOT_WIDTH * SLOT_NUMBER;
		
		public static const SPEED_NORMAL : int = 4;
		public static const SPEED_HIGH : int = 100;
		
		private var main : MovieClip;
		private var hammer : MovieClip;
		private var result : MovieClip;
		private var eggs : Array;
		private var eggs_bg : Array;
		private var maskSprite : Sprite;
		private var curSpeed : int;
		private var curPostion : int;
		private var resultStr : String;
		private var msg : String;
		private var type : String;
		private var pid : String;
		private var openUrl : String;
		private var loginUrl : String;
		
		private var curIndex : int;
		private var isMoving : Boolean;
		private var hasShownResult : Boolean;
		private var hasTimeout : Boolean;
		private var url : String;
		private var userName : String;
		private var channel : String;
		private var isLogin : Boolean;
		
		public function Lottery()
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
			
			result = main[MC_RESULT];
			
			init();
		}
		
		private function IOErrorHandler(e : Event) : void
		{
			trace(e);
		}
		
		private function init() : void
		{
			curSpeed = SPEED_NORMAL;
			
			for(var i : int = 0; i < SLOT_NUMBER; i++)
			{
				Util.addEventListener(main[SLOT_PREFIX + (i + 1)], MouseEvent.MOUSE_OVER, mouseOverHandler);
				Util.addEventListener(main[SLOT_PREFIX + (i + 1)], MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
			
			Util.addEventListener(main[BTN_OK], MouseEvent.CLICK, startLottery);
			Util.addEventListener(main[BTN_LEFT], MouseEvent.CLICK, leftClick);
			Util.addEventListener(main[BTN_RIGHT], MouseEvent.CLICK, rightClick);
			Util.addEventListener(main[MC_RESULT][BTN_CLOSE], MouseEvent.CLICK,
				function(e : Event) : void
				{
					curSpeed = SPEED_NORMAL;
					result.mouseEnabled = false;
					result.mouseChildren = false;
					result.visible = false;
					removeChild(maskSprite);
//					main[BTN_OK].visible = false;
				});
			Util.addEventListener(main[MC_RESULT][BTN_OPEN], MouseEvent.CLICK, closeGame);
			
			main[MC_RESULT].visible = false;
			main[MC_RESULT].gotoAndStop(main[MC_RESULT].totalFrames);
			
			Util.addEventListener(this, Event.ENTER_FRAME, tickFrame);
		}
		
		private function closeGame(e : Event) : void
		{
			if(type == "2")
			{
				navigateToURL(new URLRequest(openUrl + "?pid=" + pid + "&id=" + getTimer()), "_top");
			}
		}
		
		private function mouseOverHandler(e : Event) : void
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 0.9;
		}
		
		private function mouseOutHandler(e : Event) : void
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 0.8;
		}
		
		private function leftClick(e : Event) : void
		{
			curIndex = curPostion / SLOT_WIDTH;
			isMoving = true;
			curSpeed = SPEED_NORMAL;
		}
		
		private function rightClick(e : Event) : void
		{
			curIndex = curPostion / SLOT_WIDTH;
			isMoving = true;
			curSpeed = -SPEED_NORMAL;
		}
		
		private function tickFrame(e : Event) : void
		{
			if(isMoving && Math.abs(int(curPostion / SLOT_WIDTH) - curIndex) == 1)
			{
				isMoving = false;
				curSpeed = 0;
			}
			
			for(var i : int = 0; i < SLOT_NUMBER; i++)
			{
				main[SLOT_PREFIX + (i + 1)].x = (curPostion + i * SLOT_WIDTH) % AREA_WIDTH + OFFSET;
			}
			
			curPostion += curSpeed;
		}
		
		private function startLottery(e : Event) : void
		{
			/*if(!isLogin)
			{
//				navigateToURL(new URLRequest(loginUrl), "_top");
//				return;
			}*/
			
			curSpeed = SPEED_HIGH;
			
			if(!maskSprite)
			{
				maskSprite = new Sprite();
				maskSprite.graphics.beginFill(0xFFFFFF, 0.0);
				maskSprite.graphics.drawRect(0, 0, width, height);
				maskSprite.graphics.endFill();
			}
			addChild(maskSprite);
			
			var loader : URLLoader = new URLLoader();
			Util.addEventListener(loader, Event.COMPLETE, getResult);
			Util.addEventListener(loader, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(url));
			
			setTimeout(timeoutHandler, 3 * 1000);
		}
		
		private function getResult(e : Event) : void
		{
//			var data : ByteArray = e.currentTarget.data;
			resultStr = e.currentTarget.data;//data.readUTFBytes(data.bytesAvailable);
			resultStr = resultStr.substr(2);
//			resultStr = "message=xxxx&type=2&pid=123";
			
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
			
			if(hasTimeout)
			{
				hasShownResult = true;
				showResult(msg);
			}
		}
		
		private function timeoutHandler() : void
		{
			hasTimeout = true;
			
			if(!hasShownResult && msg)
			{
				showResult(msg);
			}
		}
		
		private function showResult(str : String) : void
		{
			curSpeed = 0;
			
			addChild(result);
			result[RESULT_DESC][RESULT_TF].text = str;
			result.visible = true;
			result.gotoAndPlay(1);
			result.mouseEnabled = true;
			result.mouseChildren = true;
			
			result[BTN_OPEN].visible = type == "2";
		}
	}
}
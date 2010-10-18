package 
{
	import com.ggshily.util.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	
	[SWF(width="655", height="360", frameRate="16",allowFullScreen="true")]
	public class Lottery extends Sprite
	{
		private var msg:String;
		private var channel:String;
		private var curPostion:int;
		private var pid:String;
		private var eggs:Array;
		private var hasShownResult:Boolean;
		private var isMoving:Boolean;
		private var eggs_bg:Array;
		private var result:MovieClip;
		private var main:MovieClip;
		private var openUrl:String;
		private var hammer:MovieClip;
		private var type:String;
		private var maskSprite:Sprite;
		private var resultStr:String;
		private var curSpeed:int;
		private var hasTimeout:Boolean;
		private var url:String;
		private var curIndex:int;
		private var userName:String;
		public static const VAR_INDEX:String = "index";
		public static const SLOT_NUMBER:int = 11;
		public static const AREA_WIDTH:int = 1463;
		public static const START_POSITION:int = 0;
		public static const SPEED_HIGH:int = 100;
		public static const ASSET_FILE:String = "./swf/asset.swf";
		public static const VAR_USERNAME:String = "username";
		public static const VAR_OPEN_URL:String = "open_url";
		public static const OFFSET:int = -100;
		public static const BTN_CLOSE:String = "bn_close";
		public static const VAR_URL:String = "url";
		public static const VAR_ASSET:String = "asset";
		public static const MC_ANIM:String = "lihua";
		public static const RESULT_TF:String = "_tf";
		public static const SPEED_NORMAL:int = 4;
		public static const SLOT_WIDTH:int = 133;
		public static const VAR_CHANNEL:String = "channel";
		public static const BTN_LEFT:String = "bn_left";
		public static const SLOT_PREFIX:String = "h";
		public static const MC_RESULT:String = "mc_result";
		public static const BTN_RIGHT:String = "bn_right";
		public static const RESULT_DESC:String = "mc_desc";
		public static const BTN_OK:String = "bn_ok";
		
		public function Lottery()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			return;
		}// end function
		
		private function startLottery(event:Event) : void
		{
			curSpeed = SPEED_HIGH;
			var _loc_2:* = new Sprite();
			_loc_2.graphics.beginFill(16777215, 0);
			_loc_2.graphics.drawRect(0, 0, width, height);
			_loc_2.graphics.endFill();
			addChild(_loc_2);
			var _loc_3:* = new URLLoader();
			Util.addEventListener(_loc_3, Event.COMPLETE, getResult);
			Util.addEventListener(_loc_3, IOErrorEvent.IO_ERROR, IOErrorHandler);
			_loc_3.load(new URLRequest(url));
			setTimeout(timeoutHandler, 3 * 1000);
			return;
		}// end function
		
		private function closeGame(event:Event) : void
		{
			if (type == "2")
			{
				navigateToURL(new URLRequest(openUrl + "?pid=" + pid), "_top");
			}
			return;
		}// end function
		
		private function loadCompleteHandler(event:Event) : void
		{
			main = event.target.content;
			addChild(main);
			result = main[MC_RESULT];
			init();
			return;
		}// end function
		
		private function getResult(event:Event) : void
		{
//			var data : ByteArray = event.currentTarget.data;
			var _loc_3:String = null;
			resultStr = event.currentTarget.data;//data.readUTFBytes(data.bytesAvailable);
			resultStr = resultStr.substr(2);
			var _loc_2:* = resultStr.split("&");
			for each (_loc_3 in _loc_2)
			{
				
				if (_loc_3.indexOf("message=") == 0)
				{
					msg = _loc_3.substr(8);
					continue;
				}
				if (_loc_3.indexOf("type=") == 0)
				{
					type = _loc_3.substr(5);
					continue;
				}
				if (_loc_3.indexOf("pid=") == 0)
				{
					pid = _loc_3.substr(4);
				}
			}
			if (hasTimeout)
			{
				hasShownResult = true;
				showResult(msg);
			}
			return;
		}// end function
		
		private function init() : void
		{
			curSpeed = 0;
			main[MC_RESULT].visible = false;
			main[MC_RESULT].gotoAndStop(main[MC_RESULT].totalFrames);
			var _loc_1:int = 0;
			while (_loc_1 < SLOT_NUMBER)
			{
				
				Util.addEventListener(main[SLOT_PREFIX + (_loc_1 + 1)], MouseEvent.MOUSE_OVER, mouseOverHandler);
				Util.addEventListener(main[SLOT_PREFIX + (_loc_1 + 1)], MouseEvent.MOUSE_OUT, mouseOutHandler);
				_loc_1++;
			}
			Util.addEventListener(main[BTN_OK], MouseEvent.CLICK, startLottery);
			Util.addEventListener(main[BTN_LEFT], MouseEvent.CLICK, leftClick);
			Util.addEventListener(main[BTN_RIGHT], MouseEvent.CLICK, rightClick);
			Util.addEventListener(main[MC_RESULT][BTN_CLOSE], MouseEvent.CLICK, closeGame);
			Util.addEventListener(this, Event.ENTER_FRAME, tickFrame);
			return;
		}// end function
		
		private function mouseOutHandler(event:Event) : void
		{
			var _loc_2:Number = 0.8;
			event.currentTarget.scaleY = 0.8;
			event.currentTarget.scaleX = _loc_2;
			return;
		}// end function
		
		private function addedToStageHandler(event:Event) : void
		{
			var cm:ContextMenu;
			var e:* = event;
			try
			{
				cm = new ContextMenu();
				cm.hideBuiltInItems();
				contextMenu = cm;
				tabChildren = false;
				tabEnabled = false;
			}
			catch (e:Error)
			{
			}
			url = stage.loaderInfo.parameters[VAR_URL];
			userName = stage.loaderInfo.parameters[VAR_USERNAME];
			channel = stage.loaderInfo.parameters[VAR_CHANNEL];
			openUrl = stage.loaderInfo.parameters[VAR_OPEN_URL];
			var assetFile:* = stage.loaderInfo.parameters[VAR_ASSET] || ASSET_FILE;
			var loader:* = new Loader();
			Util.addEventListener(loader.contentLoaderInfo, Event.COMPLETE, loadCompleteHandler);
			Util.addEventListener(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(assetFile), new LoaderContext(false, ApplicationDomain.currentDomain));
			return;
		}// end function
		
		private function timeoutHandler() : void
		{
			hasTimeout = true;
			if (!hasShownResult && msg)
			{
				showResult(msg);
			}
			return;
		}// end function
		
		private function leftClick(event:Event) : void
		{
			curIndex = curPostion / SLOT_WIDTH;
			isMoving = true;
			curSpeed = SPEED_NORMAL;
			return;
		}// end function
		
		private function rightClick(event:Event) : void
		{
			curIndex = curPostion / SLOT_WIDTH;
			isMoving = true;
			curSpeed = -SPEED_NORMAL;
			return;
		}// end function
		
		private function tickFrame(event:Event) : void
		{
			if (isMoving && Math.abs(int(curPostion / SLOT_WIDTH) - curIndex) == 1)
			{
				isMoving = false;
				curSpeed = 0;
			}
			var _loc_2:int = 0;
			while (_loc_2 < SLOT_NUMBER)
			{
				
				main[SLOT_PREFIX + (_loc_2 + 1)].x = (curPostion + _loc_2 * SLOT_WIDTH) % AREA_WIDTH + OFFSET;
				_loc_2++;
			}
			curPostion = curPostion + curSpeed;
			return;
		}// end function
		
		private function IOErrorHandler(event:Event) : void
		{
			trace(event);
			return;
		}// end function
		
		private function mouseOverHandler(event:Event) : void
		{
			var _loc_2:Number = 0.9;
			event.currentTarget.scaleY = 0.9;
			event.currentTarget.scaleX = _loc_2;
			return;
		}// end function
		
		private function showResult(str:String) : void
		{
			curSpeed = 0;
			addChild(result);
			result[RESULT_DESC][RESULT_TF].text = str;
			result.visible = true;
			result.gotoAndPlay(1);
			return;
		}// end function
		
	}
}

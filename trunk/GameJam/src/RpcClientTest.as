package
{

	import com.playfish.rpc.island.FriendMove;
	import com.playfish.rpc.island.RpcClient;
	import com.playfish.rpc.island.message.response.ChatReceived;
	import com.playfish.rpc.island.message.response.JoinGame;
	import com.playfish.rpc.share.ServerInfo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class RpcClientTest extends Sprite
	{
		private var rpcClient:RpcClient = new RpcClient (new URLVariables(DEBUG.SESSION));
		private var tableId:uint = 1;
		private var rpcClientSecond:RpcClient;
		
		private const buttons:Array = [
		[//first column
			[ "init", function (test : RpcClientTest):void {
				test.rpcClient.init(test.initSuccessCallback, function ():void { test.showError ("init"); } ); 
			} ],
			[ "Send Message", function ():void { rpcClientSecond.sendChatMessage ("Test chat", sendSuccessCallback , function ():void { showError ("sendMessage"); }); } ],
			//[ "Send Move", function ():void { rpcClientSecond.sendMove (7, 9, sendSuccessCallback , function ():void { showError ("sendMove"); } ); } ],
			[ "Create Arena", function ():void { rpcClientSecond.sendCreateArena (  getMapSuccessCallback , function ():void { showError ("getMap"); }); } ]
		],
		[//second column
		],
		[//third column
		]
	];
		

		private static const BUTTON_WIDTH:uint = 160;
		private static const BUTTON_HEIGHT:uint = 16;
		private static const BUTTON_SPACE:uint = 5;

		public function RpcClientTest ()
		{
			if (rpcClient == null) {
				trace("rpcClient is null");
			}
			else {
				trace("rpcClient not null");
			}

			var xpos:uint = BUTTON_SPACE;

			for each (var column:Array in buttons) {
				var ypos:uint = BUTTON_SPACE;
				
				for each (var spec:Array in column) {
				
					var button:Sprite = createButton (spec);
					addChild (button);
					button.x = xpos;
					button.y = ypos;
					ypos += BUTTON_HEIGHT + BUTTON_SPACE;
				}

				xpos += BUTTON_WIDTH + BUTTON_SPACE;
			}
			
		}

		private function createButton (spec:Array):Sprite
		{
			var button:Sprite = new Sprite ();
			
			var test : RpcClientTest = this;

			button.addEventListener (
				MouseEvent.CLICK,
				function (event:Event):void {
					trace ("button: " + spec[0]);
					trace ("TEST TRACE");
					trace ("before button: numResourceCopies=" + rpcClient.numResourceCopies);
					trace (spec);
					spec[1](test);
					trace ("after button: numResourceCopies=" + rpcClient.numResourceCopies);
				}
			);

			button.buttonMode = true;
			button.mouseChildren = false;
			button.graphics.beginFill (0xFFFFFF);
			button.graphics.drawRoundRect (0, 0, BUTTON_WIDTH, BUTTON_HEIGHT, 5);

			var text:TextField = new TextField ();
			text.text = spec[0];
			text.selectable = false;
			text.width = BUTTON_WIDTH - 20;
			button.addChild (text);
			text.x = 10;
			text.y = (BUTTON_HEIGHT - text.textHeight) / 2;
//			text.y = 10;

			return button;
		}

		private function initSuccessCallback ():void
		{
			trace ("TEST CLIENT: success callback: init");
			var parameters:Object = new URLVariables(DEBUG.SESSION);
			parameters['pf_url'] = "http://bl.dev.playfish.com/island/rpc/island/game";
			rpcClientSecond = new RpcClient (parameters);
			rpcClientSecond.sendJoinGame(joinMapSuccessCalback, function ():void { showError ("sendMove"); });
			//rpcClientSecond.startEventDelivery(function ():void { showError ("Pool"); } ); 
		}
		
		public function joinMapSuccessCalback():void
		{
			trace("Join Map Success -> let's Pool");
			rpcClientSecond.startEventDelivery(function ():void { showError ("Pool"); } ); 
		}
		
		public function getMapSuccessCallback():void
		{
			trace("getMapSuccessCalback ");
			
		}
		
		private function sendSuccessCallback ():void
		{
			trace ("TEST CLIENT: success callback.");
		}
		
		private function sendPullRequestSuccessCallback (value:Array):void
		{
			trace ("TEST CLIENT: success callback: sendPullRequest:");
			trace ("\tvalue: " + value.length);
		}

		public static function joinGameReceived(value:JoinGame):void
		{
				trace("Friend Join the Game "+value.toString);
		}
		
		public static function joinArenaReceived(value:Object):void
		{
				trace("Join Arena Received ");
		}
		
		public static function createArenaReceived(value:Object):void
		{
				trace("Create Arena Received ");
		}
		
	/*	public static function moveReceived(move:FriendMove):void
		{
			trace(move.toString());
		}*/
		
		public static function chatReceived(chat:ChatReceived):void
		{
	
			trace("Chat "+chat.message);
		}
		
		private function sendPollRequestSuccessCallback():void
		{
				trace("Succeed Poll")
		}
		
		private function showError (detail:String):void
		{
			trace ("TEST CLIENT: error callback: " + detail);
		}
	}
}
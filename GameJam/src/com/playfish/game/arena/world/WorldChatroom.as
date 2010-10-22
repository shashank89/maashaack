package com.playfish.game.arena.world
{
	import com.playfish.game.arena.core.RpcProxy;
	import com.playfish.rpc.island.RpcClient;
	import com.playfish.rpc.island.message.response.ChatReceived;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	public class WorldChatroom extends WorldBase
	{
		private var _inputTf : TextField;
		private var _messagesTf : TextField;
		
		public function WorldChatroom()
		{
			_inputTf = new TextField();
			_inputTf.type = TextFieldType.INPUT;
			_inputTf.multiline = true;
			_inputTf.x = 0;
			_inputTf.y = 500;
			_inputTf.addEventListener(KeyboardEvent.KEY_DOWN, onIntputMsg);
			
			_messagesTf = new TextField();
			_messagesTf.multiline = true;
			_messagesTf.width = 200;
			_messagesTf.height = 300;
			_messagesTf.selectable = true;
			_messagesTf.x = 0;
			_messagesTf.y = 200;
			_messagesTf.appendText("World message:");
			
			displayContent.addChild(_inputTf);
			displayContent.addChild(_messagesTf);
			
			RpcProxy.instance.setEventHandler(RpcClient.CHAT_RECEIVED, onChatReceived);
		}
		
		public override function tickFrame(delta : int) : IGameWorld
		{
			//			trace("world arena");
			
//			if(isSwitchWorld)
//			{
//				isSwitchWorld = false;
//				return WorldManager.instance.getWorld(WorldManager.WORLD_MENU);
//			}
//			else
			{
				return this;
			}
		}
		
		private function onIntputMsg(e : KeyboardEvent) : void
		{
			if(e.ctrlKey && e.keyCode = Keyboard.ENTER && _inputTf.text.length > 0)
			{
				RpcProxy.instance.sendChatMessage(_inputTf.text, sendMsgSuccess, sendMsgError);
			}
		}
		
		private function sendMsgSuccess() : void
		{
			
		}
		
		private function sendMsgError() : void
		{
			
		}
		
		private function onChatReceived(chat:ChatReceived) : void
		{
			_messagesTf.appendText("\n");
			_messagesTf.appendText(chat.message);
		}
	}
}
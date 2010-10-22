package com.playfish.game.arena.core
{
	import com.playfish.rpc.island.RpcClient;
	import com.playfish.rpc.island.message.response.ChatReceived;
	import com.playfish.rpc.island.message.response.JoinGame;

	public class RpcProxy
	{
		private static var _instance : RpcProxy;
		
		private var _rpcPersistent : RpcClient;
		private var _rpcAuditChange : RpcClient;
		private var _initSuccessCallback : Function;
		private var _loaderParameters : Object;
		
		public function RpcProxy()
		{
		}
		
		public static function get instance() : RpcProxy
		{
			if(!_instance)
			{
				_instance = new RpcProxy();
			}
			
			return _instance;
		}
		
		public function init(loaderParameters:Object, initSuccessCallback : Function, defaultNumResourceCopies:uint = 0) : void
		{
			_loaderParameters = loaderParameters;
			_initSuccessCallback = initSuccessCallback;
			
			_rpcAuditChange = new RpcClient(loaderParameters, defaultNumResourceCopies);
			_rpcAuditChange.init(onInitSuccess, onError);
			
			
		}
		
		public function setEventHandler(eventType : int, handler : Function) : void
		{
			_rpcPersistent.setEventHandler(eventType, handler);
		}
		
		public function sendChatMessage(message : String, successCallback : Function, errorCallback : Function) : void
		{
			_rpcPersistent.sendChatMessage(message, successCallback, errorCallback);
		}
		
		private function onInitSuccess() : void
		{
			_initSuccessCallback();
			
			_rpcPersistent = new RpcClient (_loaderParameters);
			_rpcPersistent.sendJoinGame(joinMapSuccessCalback, function ():void {trace("join error"); });
			
			_rpcPersistent.setEventHandler(RpcClient.JOIN_GAME, joinGameReceived);
//			_rpcPersistent.setEventHandler(RpcClient.CHAT_RECEIVED, chatReceived);
			//_rpcPersistent.setEventHandler(RpcClient.ARENA_ACTION, moveReceived);
			_rpcPersistent.setEventHandler(RpcClient.JOIN_ARENA, joinArenaReceived);
			_rpcPersistent.setEventHandler(RpcClient.CREATE_ARENA, createArenaReceived);
		}
		
		private function joinMapSuccessCalback() : void
		{
			trace("Join Map Success -> let's Pool");
			_rpcPersistent.startEventDelivery(function ():void { trace ("Pool"); } ); 
		}
		
		public function joinGameReceived(value:JoinGame):void
		{
			trace("Friend Join the Game "+value.toString);
		}
		
		public function joinArenaReceived(value:Object):void
		{
			trace("Join Arena Received ");
		}
		
		public function createArenaReceived(value:Object):void
		{
			trace("Create Arena Received ");
		}
		
		/*	public function moveReceived(move:FriendMove):void
		{
		trace(move.toString());
		}*/
		
		public function chatReceived(chat:ChatReceived):void
		{
			trace("Chat "+chat.message);
		}
		
		private function onError() : void
		{
			trace("rpc init error");
		}
	}
}
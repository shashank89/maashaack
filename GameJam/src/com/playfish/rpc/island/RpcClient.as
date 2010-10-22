package com.playfish.rpc.island
{
	import com.playfish.rpc.island.message.response.ChatReceived;
	import com.playfish.rpc.island.message.response.CreateArena;
	import com.playfish.rpc.island.message.response.JoinGame;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
    import com.playfish.rpc.island.bean.Arena;
	import flash.utils.getTimer;
     import com.playfish.rpc.island.message.response.JoinArena;
    import com.playfish.rpc.island.bean.Arena;
	import com.playfish.rpc.share.RpcClientBase;
	import com.playfish.rpc.share.NetworkUid;
	
	/**
	 * Object handling communication with the RPC server.
	 *
	 * <p>All of the methods in this class that perform any network communication take two callback functions as parameters.
	 * If the operation succeeds, the "success" callback is invoked, and if the operation returns any values, these are passed
	 * as parameters to this callback. If the operation fails, the "error" callback is invoked. This takes no parameters.
	 * Neither callback may return a value.</p>
	 *
	 * <p>This class supports the concept of a <i>batch operation</i>. 
	 */
	public class RpcClient extends RpcClientBase
	{
		/**
		 * Batch mode constant indicating that operations within the batch may be performed in any order, and can all succeed and
		 * fail independently of any other operations within the batch. This mode should only be used if there are no dependencies
		 * between any of the operations in the batch. This mode is roughly equivalent to the behaviour if no batch operation was
		 * in progress, and a number of operation methods were invoked without waiting for the previous ones to complete.
		 */
		public static const BATCHMODE_ASYNC:uint = RpcClientBase.BATCHMODE_ASYNC;

		/**
		 * Batch mode constant indicating that operations within the batch must be performed in the order that the methods were
		 * called, but that processing of the batch should continue even if one operation fails. This mode should be used if
		 * operations must be performed in order, but later operations do not rely upon all earlier ones having succeeded.
		 */
		public static const BATCHMODE_INORDER:uint = RpcClientBase.BATCHMODE_INORDER;

		/**
		 * Batch mode constant indicating that tasks within the batch must be performed in the order that the methods were called,
		 * and that if any task fails, none of the following tasks within the batch should even be attempted. This mode should be
		 * used if any tasks within the batch rely upon some earlier tasks having succeeded. If any task fails, all later tasks
		 * will be abandoned, and the <code>errorCallback</code> will be called for each abandoned task. Note that this mode does
		 * <em>not</em> imply that earlier operations will be rolled back if later operations fail.
		 */
		public static const BATCHMODE_CONDITIONAL:uint = RpcClientBase.BATCHMODE_CONDITIONAL;

		/**
		 * Score context constant to get scores within the full list of all users.
		 * This should be ORed with one of the TIME_CONTEXT_~~ constants to specify the time period required.
		 */
		public static const USER_CONTEXT_ALL:uint     = 0x01;

		/**
		 * Score context constant to get scores within the user's friends only.
		 * This should be ORed with one of the TIME_CONTEXT_~~ constants to specify the time period required.
		 */
		public static const USER_CONTEXT_FRIENDS:uint = 0x02;

		/**
		 * Score context constant to get scores within the user's region only.
		 * This should be ORed with one of the TIME_CONTEXT_~~ constants to specify the time period required.
		 */
		public static const USER_CONTEXT_REGION:uint  = 0x04;

		/**
		 * Score context constant to get all-time best scores, subject to the specified user restrictions.
		 * This should be ORed with one of the USER_CONTEXT_~~ constants to specify the user group required.
		 */
		public static const TIME_CONTEXT_ALL:uint     = 0x00;

		/**
		 * Score context constant to get this week's best scores, subject to the specified user restrictions.
		 * This should be ORed with one of the USER_CONTEXT_~~ constants to specify the user group required.
		 */
		public static const TIME_CONTEXT_WEEK:uint    = 0x10;

		/**
		 * Score context constant to get this month's best scores, subject to the specified user restrictions.
		 * This should be ORed with one of the USER_CONTEXT_~~ constants to specify the user group required.
		 */
		public static const TIME_CONTEXT_MONTH:uint   = 0x20;

		public static const USER_CONTEXT_CHALLENGE_ALL:uint 	= 0x05;

        public static const USER_CONTEXT_CHALLENGE_FRIENDS:uint 	= 0x06;
                
        public static const USER_CONTEXT_CHALLENGE_REGION:uint 	= 0x07;
				
		/**
		 * Event type for <code>recordGameEvent</code> meaning that initialisation is complete.
		 */
		public static const GAME_EVENT_INIT_DONE:uint = 0;

		/**
		 * Event type for <code>recordGameEvent</code> meaning that the user started a game.
		 */
		public static const GAME_EVENT_START:uint = 1;

		/**
		 * Event type for <code>recordGameEvent</code> meaning that the game wants to log a debug message.
		 */
		public static const GAME_EVENT_DEBUG:uint = 2;


		 /**
		 * Avatar type constant indicating the pictures is to use in a narrow profile box
		 */		
		public static const AVATAR_TYPE_PROFILE_NARROW:uint  = 1;
		/**
		 * Avatar type constant indicating the pictures is to use in a wide profile box
		 */
		public static const AVATAR_TYPE_PROFILE_WIDE:uint    = 2;
		/**
		 * Avatar type constant indicating the pictures is to use in-game
		 */
		public static const AVATAR_TYPE_PROFILE_GAME:uint    = 3;
		
		/**
		 * Server return Success
		 */
		public static const SUCCESS_RETURN:uint = 0;
		
		/**
		 * Server returns, communication ok but something was wrong on the server side
		 */
		public static const FAIL_RETURN:uint = 1;
		
	    /**
		 * Server returns, communication ok but package already Process
		 */
		public static const ALREADY_PROCESS_RETURN:uint = 2;
		
		/**
		 * Server returns, communication ok but an error which can not be recovered has been throw
		 */
		public static const UNRECOVERED_ERROR:uint = 3000;
		
		
		// Internal constants.

		
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getUserProfile:uint         = 0x03;
		
		private static var INIT_TIME:uint = 0;
		
		public static const CALL_TYPE_joinGame:uint = 0x05;
		public static const CALL_TYPE_chatSend:uint = 0x06;
		public static const CALL_TYPE_actionArena:uint = 0x07;
		public static const CALL_TYPE_joinArena:uint = 0x08;
		public static const CALL_TYPE_createArena:uint = 0x09;
		public static const CALL_TYPE_getAllArena:uint = 0x10;
        public static const CALL_TYPE_ping:uint = 0x11;

		public static const JOIN_ARENA:uint = 0x0A;
		public static const CREATE_ARENA:uint = 0x0B;
		public static const CHAT_RECEIVED:uint = 0x0C;
		public static const ARENA_ACTION:uint = 0x0D;
		public static const JOIN_GAME:uint = 0x0E;
		
		/**
		 * Create a new RpcClient.
		 *
		 * Note that this simply creates the object. No network communication is initiated until the init() method is called.
		 *
		 * @param	parameters
		 *			the value of loaderInfo.parameters for the top-level Sprite or MovieClip
		 * @param	defaultNumResourceCopies
		 *			the default value for numResourceCopies
		 */
		public function
		RpcClient (loaderParameters:Object, defaultNumResourceCopies:uint = 0)
		{
			super (
				loaderParameters, defaultNumResourceCopies,
				function ():RpcRequest { return new RpcRequest (); },
				function ():RpcResponse { return new RpcResponse (); }
			);
			
			registerEventType (JOIN_GAME, joinGameResponseHandler);
			setEventHandler(JOIN_GAME, RpcClientTest.joinGameReceived);
			
			registerEventType (CHAT_RECEIVED, chatReceivedResponseHandler);
			setEventHandler(CHAT_RECEIVED, RpcClientTest.chatReceived);
			
			//registerEventType (ARENA_ACTION, friendMoveResponseHandler);
			//setEventHandler(ARENA_ACTION, RpcClientTest.moveReceived);
			
			registerEventType (JOIN_ARENA, joinArenaResponseHandler);
			setEventHandler(JOIN_ARENA, RpcClientTest.joinArenaReceived);
			
			registerEventType (CREATE_ARENA, createArenaResponseHandler);
			setEventHandler(CREATE_ARENA, RpcClientTest.createArenaReceived);
			
		}

		public function sendPing (
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_ping, emptyResponseHandler, successCallback, errorCallback)
			);
			request.perform ();
		}


		public function sendJoinGame (
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_joinGame, joinGameResponseHandler, successCallback, errorCallback)
			);
			request.writeJoinGame();
			request.perform ();
		}
		
		
		public function sendChatMessage (message: String, 
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_chatSend, chatReceivedResponseHandler, successCallback, errorCallback)
			);
			request.writeChatSend(message);
			request.perform ();
		}
		
	
		/*public function sendMove (x: uint, y:uint,
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_move, emptyResponseHandler, successCallback, errorCallback)
			);
			request.writeMove(x, y);
			request.perform ();
		}*/
	

		public function sendCreateArena (
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_createArena, createArenaResponseHandler, successCallback, errorCallback)
			);
			request.writeCreateArena();
			request.perform ();
		}	
		
		
		public function sendJoinArena (uuid:String,
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_joinArena, joinArenaResponseHandler, successCallback, errorCallback)
			);
			request.writeJoinArena(uuid);
			request.perform ();
		}

		public function getAllArenas (
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequest = RpcRequest (
				newRpcRequest (CALL_TYPE_getAllArena, getAllArenasResponseHandler, successCallback, errorCallback)
			);
			request.perform ();
		}
		
		///////////////////////RESPONSE////////////////////////////////////////////
        private static function joinGameResponseHandler(
			response:RpcResponse, successCallback:Function):Function
		{
			var value:JoinGame = response.readJoinGame ();
			
			return function ():void {
				successCallback (value);
			};
		}
		
		
		// Response handler for chatReceived
		private static function chatReceivedResponseHandler (
			response:RpcResponse, successCallback:Function):Function
		{
			var value:ChatReceived = response.readChatReceived ();
			
			return function ():void {
				successCallback (value);
			};
		}
		
		private static function createArenaResponseHandler(
			response:RpcResponse, successCallback:Function):Function
		{
			var value:CreateArena = response.readCreateArena();
			
			return function ():void {
				successCallback (value);
			};
		}


		// Response handler for getAllArenasResponseHandler

		private static function getAllArenasResponseHandler (
			response:RpcResponse, successCallback:Function):Function
		{
			var value:Array = response.readArray(response.readShortArena);

			return function ():void {
				successCallback (value);
			};
		}

		// Response handler for Join Arena
		private static function joinArenaResponseHandler (
			response:RpcResponse, successCallback:Function):Function
		{
			var value:JoinArena = response.readJoinArena ();
			
			return function ():void {
				successCallback (value);
			};
		}
		
		
		// Response handler for moveReceived
		/*private static function friendMoveResponseHandler (
			response:RpcResponse, successCallback:Function):Function
		{
			var value:FriendMove = response.readFriendMove ();
			
			return function ():void {
				successCallback (value);
			};
		}*/
				
	}
}

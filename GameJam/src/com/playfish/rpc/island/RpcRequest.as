package com.playfish.rpc.island
{
	import com.playfish.rpc.share.RpcRequestBase;

	// Representation of a single outstanding RPC request.
	// usage: create, call write*() to build request body, call perform().
	internal class RpcRequest extends RpcRequestBase
	{
		
		// Write chat send value to request body. Illegal once perform() called.
		internal function writeChatSend (message: String):void
		{
			writeString (message);
		}
		
		
		// Write joinGame  value to request body. Illegal once perform() called.
		internal function writeJoinGame ():void
		{
		}
		
		// Write getMap  value to request body. Illegal once perform() called.
		internal function writeCreateArena():void
		{
		}
		
		// Write getMap  value to request body. Illegal once perform() called.
		internal function writeJoinArena(arenaId:String):void
		{
			writeString(arenaId);
		}
	}
}

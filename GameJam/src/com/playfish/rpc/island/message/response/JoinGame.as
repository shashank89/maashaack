package com.playfish.rpc.island.message.response 
{
	import com.playfish.rpc.share.NetworkUid;
	
	/**
	 * ...
	 * @author Playfish
	 */
	public class JoinGame 
	{
        /**
         *Id of the new Joiner
         */
		public var userId:NetworkUid;

        /**
         *Complete list of user
         */
         public var usersId:Array;

		public function toString():String
		{
			return "Join Game "+userId;
		}
	}
	
}
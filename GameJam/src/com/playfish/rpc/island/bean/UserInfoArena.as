package com.playfish.rpc.island.bean
{
    import com.playfish.rpc.share.NetworkUid;
	/**
	 * ...
	 * @author Playfish
	 */
	public class UserInfoArena
	{
		public var networkUid:NetworkUid;
        public var life:uint;
        //List of unity the user has in hand
        public var unityInHand:Array;

		public function UserInfoArena()
		{

		}

	}

}
package com.playfish.rpc.island.bean
{
    import com.playfish.rpc.share.NetworkUid;
	/**
	 * ...
	 * @author Playfish
	 */
	public class Arena
	{
        public var id:String;
        //Id of the arena creator
        public var userId:NetworkUid;
        public var playerOne:UserInfoArena;
        public var playerTwo:UserInfoArena;
        public var tiles:Array;

		public function Arena()
		{

		}

	}

}
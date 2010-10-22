package com.playfish.rpc.island.message.response 
{
	 import com.playfish.rpc.island.bean.Arena;
	/**
	 * Current user or an other user join the arena
	 * @author Playfish
	 */
	public class JoinArena 
	{
		public var canJoin:Boolean;
        public var arena:Arena;

		public function JoinArena() 
		{
			
		}
		
	}
	
}
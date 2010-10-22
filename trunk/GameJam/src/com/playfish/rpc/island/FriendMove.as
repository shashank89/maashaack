package com.playfish.rpc.island 
{
	import com.playfish.rpc.share.NetworkUid;
	
	/**
	 * ...
	 * @author Playfish
	 */
	public class FriendMove
	{
		public var initX:uint;
		public var initY:uint;
		
		public var finalX:uint;
		public var finalY:uint;
		
		public var userId:NetworkUid;
		public var speed:uint;
		
		public function toString():String {
			var s:String = "user Id "+userId.toString()+" initX " + initX + " initY" +initY + " finalX " + finalX + " final Y" + finalY
			trace(s);
			return s;
		}
	}
	
}
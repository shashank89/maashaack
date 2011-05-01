package com.ggshily.game.monsters.bean
{
	

	public class Building
	{
		public static const STATE_IN_BUILDING : int = 0;
		public static const STATE_IDLE : int = 1;
		public static const STATE_DAMAGED : int = 2;
		public static const STATE_FULL : int = 3;
		
		public var id : int;
		public var typeId : int;
		public var x : int;
		public var y : int;
		public var level : int;
		
		public var state : int;
		
		public function Building()
		{
		}
	}
}
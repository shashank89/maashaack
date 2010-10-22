package com.playfish.game.arena.world
{
	import flash.utils.getDefinitionByName;

	public class WorldManager
	{
		public static const WORLD_PACKAGE : String = "com.playfish.game.arena.world";
		public static const WORLD_MENU : String = WORLD_PACKAGE + ".WorldMenu";
		public static const WORLD_ARENA : String = WORLD_PACKAGE + ".WorldArena";
		public static const WORLD_CHATROOM : String = WORLD_PACKAGE + ".WorldChatroom";
		
		public static const WORLDS : Array = [WORLD_MENU, WORLD_ARENA];
		
		// force compile
		private static const dump1 : WorldMenu = null;
		private static const dump2 : WorldArena = null;
		
		private static var _instance : WorldManager;
		
		private var _worlds : Object;
		
		public function WorldManager()
		{
			_worlds = new Object();
		}
		
		public static function get instance() : WorldManager
		{
			if(!_instance)
			{
				_instance = new WorldManager();
			}
			
			return _instance;
		}
		
		public function getWorld(type : String) : IGameWorld
		{
			if(!_worlds[type])
			{
				_worlds[type] = new (getDefinitionByName(type) as Class)();
			}
			
			return _worlds[type]; 
		}
	}
}
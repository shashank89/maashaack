package com.playfish.game.arena.world
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WorldMenu extends WorldBase
	{
		private var isSwitchWorld : Boolean;
		
		
		public function WorldMenu()
		{
			super();
			
			displayContent.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e : Event) : void
		{
			isSwitchWorld = true;
		}
		
		public override function tickFrame(delta : int) : IGameWorld
		{
//			trace("world menu");
			
			if(isSwitchWorld)
			{
				isSwitchWorld = false;
				return WorldManager.instance.getWorld(WorldManager.WORLD_ARENA);
			}
			else
			{
				return this;
			}
		}
		
		
	}
}
package com.playfish.game.arena.world
{
	import flash.display.DisplayObjectContainer;

	public interface IGameWorld
	{
		function tickFrame(delta : int) : IGameWorld;
		function getDisplayContent() : DisplayObjectContainer;
	}
}
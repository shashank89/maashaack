package com.playfish.game.arena.world
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class WorldBase implements IGameWorld
	{
		protected var nextWorld : IGameWorld;
		protected var displayContent : DisplayObjectContainer;
		
		public function WorldBase()
		{
			nextWorld = this;
			
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill(0xFF0000);
			sprite.graphics.drawRect(0, 0, 100, 100);
			sprite.graphics.endFill();
			
			displayContent = sprite;
		}
		
		public function tickFrame(delta:int):IGameWorld
		{
			return nextWorld;
		}
		
		public function getDisplayContent() : DisplayObjectContainer
		{
			return displayContent;
		}
	}
}
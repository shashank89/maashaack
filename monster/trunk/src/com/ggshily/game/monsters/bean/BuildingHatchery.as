package com.ggshily.game.monsters.bean
{
	public class BuildingHatchery extends Building
	{
		public var startProduceTime : Number;
		public var produceQuene : Vector.<MonsterProduceQueneElement>;
		
		
		public function BuildingHatchery()
		{
			super();
		}
	}
}
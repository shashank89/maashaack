package
{
	import flash.display.Sprite;
	
	public class Res extends Sprite
	{
		[Embed(source="swf/town_hall.png")]
		private var building1:Class;
		
		[Embed(source="swf/building2.png")]
		private var building2:Class;
		
		[Embed(source="swf/building3.png")]
		private var building3:Class;
		
		[Embed(source="swf/building4.png")]
		private var building4:Class;
		
		[Embed(source="swf/building5.png")]
		private var building5:Class;
		
		[Embed(source="swf/building6.png")]
		private var building6:Class;
		
		[Embed(source="swf/monster_unlocker.png")]
		private var monster_unlocker:Class;
		
		[Embed(source="swf/monster_hatchery.png")]
		private var monster_hatchery:Class;
		
		[Embed(source="swf/monster_housing.png")]
		private var monster_housing:Class;
		
		public function Res()
		{
			super();
		}
	}
}
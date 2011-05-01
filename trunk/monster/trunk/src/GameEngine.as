package 
{
	import com.ggshily.game.monsters.core.WorldBase;
	import com.ggshily.game.monsters.resource.ResourceFile;
	import com.ggshily.game.monsters.resource.ResourceLoader;
	import com.ggshily.game.monsters.resource.ResourceLoaderEvent;
	import com.ggshily.game.monsters.world.WorldOwnCity;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	[SWF(width="760", height="700", frameRate="16",allowFullScreen="true")]
	public class GameEngine extends Sprite
	{
		public static const WIDTH : int = 760;
		public static const HEIGHT : int = 700;
		public static const RES_MAIN : String = "./xml/main.xml";
		
		private static var _instance : GameEngine;
		
		private var _currentWorld : WorldBase;

		
		public function GameEngine()
		{
			super();
			
			_instance = this;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(e : Event) : void
		{
			var resourceLoader : ResourceLoader = new ResourceLoader();
			resourceLoader.addEventListener(ResourceLoaderEvent.COMPLETE, loadCompleteHandler);
			resourceLoader.load(new ResourceFile(<file path="./xml/main.xml"/>));
		}
		
		private function loadCompleteHandler(e : Event) : void
		{
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			_currentWorld = new WorldOwnCity();
			_currentWorld.start();
			addChild(_currentWorld.displayContent);
		}
		
		public function enterFrameHandler(e : Event) : void
		{
			_currentWorld.tick(getTimer());
		}

		public static function get instance() : GameEngine
		{
			return _instance;
		}
		
		public function get currentWorld():WorldBase
		{
			return _currentWorld;
		}
	}
}
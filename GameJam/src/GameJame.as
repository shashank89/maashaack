package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	[SWF(width="700", height="650", frameRate="30",allowFullScreen="true")]
	public class GameJame extends Sprite
	{
		public function GameJame()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void
		{
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest("com/playfish/game/arena/core/Engine.swf"));
			
			trace(new Date(0).toUTCString());
		}
		
		private function onLoadComplete(e : Event) : void
		{
			addChild(e.target.content);
		}
		
		private function onIOError(e : Event) : void
		{
			trace(e);
		}
	}
}
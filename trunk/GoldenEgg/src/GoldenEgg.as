package
{
	import com.ggshily.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	[SWF(width="550", height="314", backgroundColor="#ffffff", frameRate="30",allowFullScreen="true")]
	public class GoldenEgg extends Sprite
	{
		public static const ASSET_FILE : String = "./swf/Untitled-1.swf";
		public static const MC_HAMMER : String = "hammer";
		
		private var main : MovieClip;
		
		public function GoldenEgg()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(e : Event) : void
		{
			var loader : Loader = new Loader();
			Util.AddEventListener(loader.contentLoaderInfo, Event.COMPLETE, loadCompleteHandler);
			Util.AddEventListener(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(ASSET_FILE), new LoaderContext(false, ApplicationDomain.currentDomain));
		}

		private function loadCompleteHandler(e : Event) : void
		{
			main = e.target.content;
			addChild(main);

			init();
		}

		private function IOErrorHandler(e : Event) : void
		{
			trace(e);
		}

		private function init() : void
		{
			
		}
	}
}
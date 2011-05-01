package
{
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	[SWF(width="760", height="700", frameRate="16",allowFullScreen="true")]
	public class GameLoader extends Sprite
	{
		public static const WIDTH : int = 760;
		public static const HEIGHT : int = 600;
		
		private var _progressTextFiled : TextField;
		private var _loader : Loader;
		
		public function GameLoader()
		{
			_progressTextFiled = new TextField();
			_progressTextFiled.selectable = false;
			_progressTextFiled.x = WIDTH >> 1;
			_progressTextFiled.y = HEIGHT >> 1;
			addChild(_progressTextFiled);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest("GameEngine.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function loadCompleteHandler(e : Event) : void
		{
			addChild(_loader);
			
			_loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader = null;
		}
		
		private function ioErrorHandler(e : Event) : void
		{
			trace(e.toString());
		}
	}
}
package com.ggshily.game.monsters.resource
{
	import com.ggshily.game.monsters.config.ConfigMain;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class ResourceFile extends EventDispatcher
	{
		private var _id : String;
		private var _filePath : String;
		private var _loadInBackground : Boolean;
		private var _loader : IEventDispatcher;
		private var _data : Object;
		
		private var _fileExtension : String;
		
		public function ResourceFile(data : XML)
		{
			_filePath = data.@path;
			_fileExtension = _filePath.substr(_filePath.length - 3, 3);
			_loadInBackground = false;
		}
		
		public function load() : void
		{
			if(_fileExtension == "xml")
			{
				var urlLoader : URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				urlLoader.load(new URLRequest(_filePath));
				_loader = urlLoader;
			}
			else if(_fileExtension == "jpg" || _fileExtension == "swf")
			{
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest(_filePath), new LoaderContext(false, ApplicationDomain.currentDomain));
				_loader = loader.contentLoaderInfo;
			}
			else
			{
				throw new Error("unsupported file:" + _filePath);
			}
		}
		
		private function loadCompleteHandler(e : Event) : void
		{
			_data = (e.currentTarget is URLLoader) ? e.currentTarget.data : e.currentTarget.content;
			
			if(_fileExtension == "xml" && _filePath != GameEngine.RES_MAIN)
			{
				ConfigMain.instance.loadConfig(new XML(_data));
			}
			
			_loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader = null;
			
			dispatchEvent(new ResourceFileEvent(ResourceFileEvent.COMPLETE));
		}
		
		private function ioErrorHandler(e : Event) : void
		{
			throw new Error(e.toString());
		}

		public function get id():String
		{
			return _id;
		}

		public function get filePath():String
		{
			return _filePath;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get loadInBackground():Boolean
		{
			return _loadInBackground;
		}


	}
}
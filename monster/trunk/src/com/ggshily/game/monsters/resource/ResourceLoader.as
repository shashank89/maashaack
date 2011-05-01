package com.ggshily.game.monsters.resource
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;

	public class ResourceLoader extends EventDispatcher
	{
		
		private var _loader : URLLoader;
		private var _currentFile : ResourceFile;
		private var _firstLoadedFiles : Vector.<ResourceFile>;
		private var _backgroundLoadedFiles : Vector.<ResourceFile>;
		
		public function ResourceLoader()
		{
			
		}
		
		public function load(resourceFile : ResourceFile) : void
		{
			_currentFile = resourceFile;
			_currentFile.addEventListener(ResourceFileEvent.COMPLETE, loadCompleteHanlder);
			_currentFile.load();
		}
		
		private function loadCompleteHanlder(e : Event) : void
		{
			_currentFile.removeEventListener(ResourceFileEvent.COMPLETE, loadCompleteHanlder);
			
			if(_currentFile.filePath == GameEngine.RES_MAIN)
			{
				parseMain(new XML(e.currentTarget.data));
			}
			else
			{
				if(_currentFile == _firstLoadedFiles[_firstLoadedFiles.length - 1])
				{
					dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.COMPLETE));
				}
				else
				{
					load(_firstLoadedFiles[_firstLoadedFiles.indexOf(_currentFile) + 1]);
				}
			}
		}
		
		private function parseMain(data : XML) : void
		{
			_firstLoadedFiles = new Vector.<ResourceFile>();
			_backgroundLoadedFiles = new Vector.<ResourceFile>();
			
			for each(var child : XML in data.children())
			{
				var resourceFile : ResourceFile = new ResourceFile(child);
				if(resourceFile.loadInBackground)
				{
					_backgroundLoadedFiles.push(resourceFile);
				}
				else
				{
					_firstLoadedFiles.push(resourceFile);
				}
			}
			
			load(_firstLoadedFiles[0]);
			trace(data);
		}
		
		private function ioErrorHandler(e : Event) : void
		{
			throw new Error(_currentFile + " can not loaded");
		}
	}
}
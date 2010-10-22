package com.playfish.game.arena.core
{
	import com.playfish.game.arena.world.IGameWorld;
	import com.playfish.game.arena.world.WorldManager;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;

	public class Engine extends Sprite
	{
		public static const DEFAULT_WORLD : String = WorldManager.WORLD_MENU;
		
		private var _curWorld : IGameWorld;
		private var _loadComplete : Boolean;
		private var _rpcInitSuccess : Boolean;
		private var _initComplete : Boolean;
		
		public function Engine()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void
		{
			CONFIG::debug
			{
				RpcProxy.instance.init(new URLVariables(DEBUG.SESSION.replace(/amp;/g, "")), onRpcInitSuccess);
			}
			
			CONFIG::release
			{
				RpcProxy.instance.init(stage.loaderInfo.parameters, onRpcInitSuccess);
			}
			
			load();
		}
		
		private function load() : void
		{
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(new URLRequest("swf/_dc_sculpture_PFC.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function loadComplete(e : Event) : void
		{
			_loadComplete = true;
			init();
		}
		
		private function onRpcInitSuccess() : void
		{
			_rpcInitSuccess = true;
			init();
		}
		
		private function init() : void
		{
			if(_rpcInitSuccess && _loadComplete)
			{
				switch2World(WorldManager.instance.getWorld(WorldManager.WORLD_MENU));
				addChild(WorldManager.instance.getWorld(WorldManager.WORLD_CHATROOM).getDisplayContent());
				
				addEventListener(Event.ENTER_FRAME, tickFrame);
			}
		}
		
		public function getLoadProgress() : Number
		{
			return 0.0;
		}
		
		private function switch2World(world : IGameWorld) : void
		{
			if(_curWorld)
			{
				removeChild(_curWorld.getDisplayContent());
			}
			
			_curWorld = world;
			addChildAt(_curWorld.getDisplayContent(), 0);
		}
		
		public function tickFrame(e : Event) : void
		{
			var nextWorld : IGameWorld = _curWorld.tickFrame(getTimer());
			
			if(nextWorld != _curWorld)
			{
				switch2World(nextWorld);
			}
		}
	}
}
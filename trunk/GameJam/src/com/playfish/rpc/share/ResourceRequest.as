package com.playfish.rpc.share
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	// Simple class used to record images needed to complete a response.
	// The callback is invoked with a single argument of type DisplayObject if the load is successful.
	internal class ResourceRequest
	{
		private var url:String;
		private var resultArray:Array;
		private var loader:Loader;
		private var doneCallback:Function;

		function ResourceRequest (url:String, resultArray:Array)
		{
			this.url = url;
			this.resultArray = resultArray;

			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, errorHandler);
		}

		// Load this resource, and call the doneCallback when done (either succeeded or failed).
		internal function load (doneCallback:Function):void
		{
			this.doneCallback = doneCallback;

			try {
				loader.load (new URLRequest (url));
			} catch (e:Error) {
				RpcClientBase.debug ("ERROR: image loading threw error: " + e);
				done ();
			}
		}

		// Cancel this load, if it is still in progress.
		// This does NOT call the doneCallback!
		internal function cancel ():void
		{
			if (loader != null) {
				loader.close ();
				loader = null;
			}
		}

		// Callback called if the image loads successfully.
		private function completeHandler (event:Event):void
		{
			RpcClientBase.debug ("loadImages: complete: url=" + url);
			if (loader != null) {
				resultArray.push (loader);
				done ();
			}
		}

		// Callback called if the image load fails.
		private function errorHandler (event:Event):void
		{
			RpcClientBase.debug ("ERROR: image load failed with event: " + event);
			done ();
		}

		// Note that this image is no longer loading, whether for better or for worse.
		private function done ():void
		{
			if (loader != null) {
				loader = null;
				doneCallback ();
			}
		}

// XXX DEBUG
		public function toString ():String
		{
			return "[ResourceRequest: " + url + "]";
		}
	}
}
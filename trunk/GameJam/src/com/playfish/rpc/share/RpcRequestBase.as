package com.playfish.rpc.share
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	// Representation of a single outstanding RPC request.
	// usage: create, call write*() to build request body, call perform().
	/** @private **/
	public class RpcRequestBase
	{
		// The RpcClientBase to which this belongs.
		private var client:RpcClientBase;

		// True if this request is a sub-request within a batch operation.
		private var partOfBatch:Boolean;

		// The number of copies to load of each resource referenced by this request.
		// This is internal rather than private, as the batch operation handling code in RpcClient needs direct access.
		internal var numResourceCopies:uint;

		// The message type. This is both the request message type, and the expected response message type.
		// This is internal rather than private, as the batch operation handling code in RpcClient needs direct access.
		internal var msgType:uint;

		// Request body while it is being constructed. Set to null when perform() is called.
		private var body:ByteArray;

		// Request body is moved to this field when request is sent, to support re-sending the request.
		private var requestMsg:ByteArray;

		// Set to true when the request has been retried (if it fails a second time it fails for good).
		// If RpcClientBase.disableRetryAsGet is true, we set this from the start to prevent any retry from being sent.
		// This is internal rather than private, as RpcClientBase forces this to true for async poll requests.
		internal var triedGet:Boolean = RpcClientBase.disableRetryAsGet;

		// Initial response timeout.
		// This is stored with the request, and is internal rather than private, so that RpcClientBase can change this for an
		// individual request. This is used for asynchronous event polling requests, which may use a different timeout.
		internal var responseInitialTimeoutMillis:uint = RpcClientBase.responseInitialTimeoutMillis;

		// Fields used while request is active.
		private var urlLoader:URLLoader;
		private var timer:flash.utils.Timer;	// explicit package to work around bug in Flash CS3 linker

		// Callbacks, passed in at construction time.
		// These are internal rather than private, as the batch operation handling code in RpcClient needs direct access.
		internal var responseHandler:Function;
		internal var successCallback:Function;
		internal var errorCallback:Function;

		// The constructor takes no arguments, as all initialisation is done by the init() method.
		public function RpcRequestBase ()
		{
			// No operation.
		}

		// Initialise this request object.
		// This is not done in the constructor as then all subclasses would have to be kept synchronised with this parameter list.
		// responseHandler must be a function taking 2 args - response:RpcResponse and successCallback:Function, and returning
		// a function taking no arguments and returning void. If anything goes wrong while parsing the response, it should throw
		// an error. If all goes to plan, it should return a closure that will call the original successCallback with the values
		// parsed out of the response.
		internal function init (
			client:RpcClientBase, partOfBatch:Boolean, numResourceCopies:uint, msgType:uint,
			responseHandler:Function, successCallback:Function, errorCallback:Function):void
		{
			this.client = client;
			this.partOfBatch = partOfBatch;
			this.numResourceCopies = numResourceCopies;
			this.msgType = msgType;

			this.body = new ByteArray ();
			this.body.endian = Endian.BIG_ENDIAN;

			this.responseHandler = responseHandler;
			this.successCallback = successCallback;
			this.errorCallback = errorCallback;

// XXX this would be cleaner if the header and encapsulation were assembled in perform() rather than here.
			if (!partOfBatch) {
				// Write encapsulation format.
				writeUint8 (RpcClientBase.ENCAPSULATION_NULL);

// XXX make space for any encapsulation prefix here, or just build the body and sort the whole thing in perform().

				// Write message header, inside encapsulation.
				writeUint8 (msgType);
				writeString (client.sessionId);
			}
		}

		// Actually perform the request.
		public function perform ():void
		{
RpcClientBase.debug ("perform: type=" + msgType + " length=" + body.length + " partOfBatch=" + partOfBatch + " body=\n" + dumpByteArray (body));

			if (partOfBatch) {
RpcClientBase.debug ("perform: request is part of a batch: no operation in perform()");
				return;
			}

			requestMsg = body;
			body = null;
			sendRequest (client.url, requestMsg);
		}

		// Write uint8 value to request body. Illegal once perform() called.
		public function writeUint8 (value:uint):void
		{
			body.writeByte (value);
		}

		public function writeBitSet(value:BitSet):void
		{
			writeUintvar32  (value.bits.length);
			body.writeBytes (value.bits);
		}

		// Write uintvar32 value to request body. Illegal once perform() called.
		public function writeUintvar32 (value:uint):void
		{
			var shift:uint;

			if ((value & 0xF0000000) != 0) {
				shift = 28;		// 5-octet format.
			} else if ((value & 0x0FE00000) != 0) {
				shift = 21;		// 4-byte format.
			} else if ((value & 0x001FC000) != 0) {
				shift = 14;		// 3-octet format.
			} else if ((value & 0x00003F80) != 0) {
				shift = 7;		// 2-octet format.
			} else {
				shift = 0;		// 1-octet format.
			}

			for (; shift>0; shift-=7) {
				body.writeByte ((value >>> shift) | 0x80);
			}

			body.writeByte (value & 0x7F);
		}

		// Write uintvar31 value to request body. Illegal once perform() called.
		public function writeUintvar31 (value:uint):void
		{
			if ((value & 0x80000000) != 0) {
				throw new Error ();
			}

			writeUintvar32 (value);
		}

		// Write int32 value to request body. Illegal once perform() called.
		public function writeIntvar32 (value:int):void
		{
			var uvalue:uint;

			if (value < 0) {
				uvalue = ((~value) << 1) | 1;
			} else {
				uvalue = value << 1;
			}

			writeUintvar32 (uvalue);
		}

		// Write float32 value to request body. Illegal once perform() called.
		public function writeFloat32 (value:Number):void
		{
			body.writeFloat (value);
		}

		// Write float64 value to request body. Illegal once perform() called.
		public function writeFloat64 (value:Number):void
		{
			body.writeDouble (value);
		}

		// Write boolean value to request body. Illegal once perform() called.
		public function writeBoolean (value:Boolean):void
		{
			body.writeByte (value ? 1 : 0);
		}

		// Write string value to request body. Illegal once perform() called.
		public function writeString (value:String):void
		{
			writeUintvar32 (value.length);
			body.writeUTFBytes (value);
		}

		// Write bytearray value to request body. Illegal once perform() called.
		public function writeByteArray (value:ByteArray):void
		{
			writeUintvar32 (value.length);
			body.writeBytes (value);
		}

		// Write date value to request body. Illegal once perform() called.
		public function writeDate (value:Date):void
		{
			writeUintvar32 (value == null ? 0 : (value.getTime () / 1000));
		}

		// Write NetworkUid value to request body. Illegal once perform() called.
		public function writeNetworkUid (value:NetworkUid):void
		{
			if (value == null) {
				writeUintvar31 (0);
			} else {
				writeUintvar31 (value._network);
				writeString (value._networkUid);
				writeUintvar31 (value._playfishUid);
			}
		}

		// Write TimingData value to request body. Illegal once perform() called.
		public function writeTimingData (value:TimingData):void
		{
			writeByteArray (value.token);
			writeUintvar32 (value.rtt);
		}

		// Write array value to request body. Illegal once perform() called.
		// The writeElement function must be one of the other write*() methods from this class.
		public function writeArray (value:Array, writeElement:Function):void
		{
			var length:uint = value.length;

			writeUintvar32 (length);

			for (var i:uint = 0; i<length; i++) {
				writeElement (value[i]);
			}
		}

		// Write sparse array value to request body. Illegal once perform() called.
		// The writeElement function must be one of the other write*() methods from this class.
		public function writeSparseArray (value:Array, writeElement:Function):void
		{
			var length:uint = value.length;

			writeUintvar32 (length);

			for (var i:String in value) {
				writeUintvar32 (uint (i));
				writeElement (value[i]);
			}
		}

		// Write the body of another RpcRequest as a batch sub-request to this request's body. Illegal once perform() called.
		internal function writeSubRequest (subRequest:RpcRequestBase):void
		{
			writeUint8 (subRequest.msgType);
			writeUintvar32 (subRequest.body.length);
			body.writeBytes (subRequest.body);
		}

		// Retry a request which has just failed, using GET method and hex-encoded message in URL parameters.
		private function retryRequestAsGet ():void
		{
			triedGet = true;

			var getUrl:String = client.url + "?msg=" + requestMsg.length + "-";

			for (var i:uint = 0; i<requestMsg.length; i++) {
				var x:uint = requestMsg[i];
				getUrl += "0123456789ABCDEF".charAt ((x>>4) & 0xF) + "0123456789ABCDEF".charAt ((x) & 0xF);
			}

			sendRequest (getUrl, null);
		}

		// Send HTTP request, handling response and any errors that may occur.
		private function sendRequest (requestUrl:String, data:ByteArray):void
		{
			urlLoader = new URLLoader ();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener (Event.COMPLETE, completeHandler);
			urlLoader.addEventListener (Event.OPEN, progressHandler);
			urlLoader.addEventListener (ProgressEvent.PROGRESS, progressHandler);
// XXX should we have different types of errors?
			urlLoader.addEventListener (IOErrorEvent.IO_ERROR, errorHandler);
			urlLoader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, errorHandler);

			var urlRequest:URLRequest = new URLRequest (requestUrl);

			if (data != null) {
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.contentType = "application/octet-stream";
				urlRequest.data = data;
			}

			timer = new Timer (responseInitialTimeoutMillis, 1);
			timer.addEventListener (TimerEvent.TIMER_COMPLETE, timeoutHandler);

			// Start the timeout and send the request.
			timer.start ();
			urlLoader.load (urlRequest);
		}

		// Handler for 'open' and 'progress' events - both of these indicate that some progress has been made with the response.
		private function progressHandler (event:Event):void
		{
			// Some progress has occurred, so reset the timeout. This occurs on every progress event.
			timer.reset ();
			timer.delay = RpcClientBase.responseProgressTimeoutMillis;
			timer.start ();
		}

		// Handler for 'load complete' event.
// XXX must handle batch mode:
// - batch responses must share resourceRequests array
// - must loop over responses
// - must have access to list of requests in order
// - on error or timeout, must fail ALL requests in batch
// - maybe we simulate this with a response handler, and success/error callbacks, in RpcClient???

// XXX maybe move resourceRequests array into this class, and pass reference to response constructor???
		private function completeHandler (event:Event):void
		{
			timer.reset ();

			try {
				var responseBody:ByteArray = urlLoader.data;
				var encapsulationType:uint = responseBody.readUnsignedByte ();
RpcClientBase.debug ("response: encapsulationType=" + encapsulationType);
// XXX we need better encapsulation than this
				var responseType:uint = responseBody.readUnsignedByte ();
//RpcClientBase.debug ("response: type=" + responseType + " body=\n" + dumpByteArray (responseBody));

				if (responseType == RpcClientBase.ERROR_RESPONSE) {
					var errorReason:uint = responseBody.readUnsignedByte ();
					if (errorReason == RpcClientBase.ERROR_REASON_FORMAT && !triedGet) {
						retryRequestAsGet ();
						return;
					} else {
						errorCallback ();
						return;
					}
				} else if (responseType != msgType) {
					// Response not of expected type.
RpcClientBase.debug ("ERROR: unexpected response type: got=" + responseType + " expected=" + msgType);
					errorCallback ();
					return;
				}
			} catch (e:Error) {
				// Something went wrong trying to read the message encapsulation or error reason.
				errorCallback ();
				return;
			}

			var response:RpcResponseBase = client.createResponse ();
			response.init (
				client, responseBody, responseBody.bytesAvailable, new Array (), numResourceCopies
			);

			try {
				var wrappedSuccessCallback:Function = responseHandler (response, successCallback);
			} catch (e:Error) {
RpcClientBase.debug ("ERROR: caught error calling response handler: " + e);
RpcClientBase.debug ("ERROR: stackTrace: " + e.getStackTrace());
				errorCallback ();
				return;
			}

			if (!response.isDone ()) {
RpcClientBase.debug ("ERROR: response handler returned but response.isDone() is false");
				errorCallback ();
				return;
			}

			if (response.resourceRequests.length != 0) {
// XXX todo: load images, calling successCallback when finally done
// note: errors in image loading do NOT cause the RPC call to fail!
RpcClientBase.debug ("response: need to load " + response.resourceRequests.length + " resources to complete request");
				loadResources (response.resourceRequests, wrappedSuccessCallback);
				return;
			}
else { RpcClientBase.debug ("response: no images need to be loaded"); }

RpcClientBase.debug ("RPC: calling success callback");
			wrappedSuccessCallback ();
		}

		// Handler for 'load error' events.
		private function errorHandler (event:Event):void
		{
RpcClientBase.debug ("ERROR: error event during network operation: " + event);
			timer.reset ();

			// XXX if we have calls that cannot be safely retried, we need to check for them here.
			if (!triedGet) {
				retryRequestAsGet ();
				return;
			}

			errorCallback ();
		}

		// Handler for 'load timeout' events.
		private function timeoutHandler (event:Event):void
		{
RpcClientBase.debug ("ERROR: timeout during network operation");
			try {
				urlLoader.close ();
			} catch (e:Error) {
RpcClientBase.debug ("ERROR: caught exception in URLLoader.close(): " + e);
				// ignored
			}

			errorCallback ();
		}

		// Attempt to load a list of resources. Call the doneCallback (with no arguments) when done.
		private static function loadResources (resourceRequests:Array, doneCallback:Function):void
		{
RpcClientBase.debug ("loadResources: count=" + resourceRequests.length + ":");
for each (var xxxrr:ResourceRequest in resourceRequests) { RpcClientBase.debug ("\t" + xxxrr); }

			var remain:uint = resourceRequests.length;

			var resourceTimer:flash.utils.Timer = new flash.utils.Timer (RpcClientBase.resourceLoadTimeoutMillis, 1);
			resourceTimer.addEventListener (TimerEvent.TIMER_COMPLETE, resourceTimeout);

			for each (var rr:ResourceRequest in resourceRequests) {
				rr.load (resourceDone);
			}

			resourceTimer.start ();

			// Callback invoked when a single resource finishes loading (successfully or otherwise).
			// This simply decrements the counter of resources remaining, and calls doneCallback when none remain.
			function resourceDone ():void
			{
RpcClientBase.debug ("loadResources: resourceDone: remain: " + remain + " -> " + (remain-1));
				remain--;

				if (remain == 0) {
					resourceTimer.reset ();
					doneCallback ();
				}
			}

			// Callback invoked if resource loading times out.
			function resourceTimeout (event:TimerEvent):void
			{
RpcClientBase.debug ("loadResources: resourceTimeout: remain=" + remain);
				for each (var rr:ResourceRequest in resourceRequests) {
					rr.cancel ();
				}

				doneCallback ();
			}
		}

// XXX DEBUG ONLY
		private static const HEX_CHARS:String = "0123456789ABCDEF";
		internal static function dumpByteArray (bytes:ByteArray):String
		{
			var result:String = "";
			var len:uint = bytes.length;

			for (var i:uint = 0; i<len; i+=16) {
				var hex:String= "";
				var chars:String = "";

				for (var j:uint = 0; j<16 && i+j<len; j++) {
					var x:uint = bytes[i+j];

					hex += ' ' + HEX_CHARS.charAt (x >> 4) + HEX_CHARS.charAt (x & 0xF);
					chars += (x >= 32 && x <= 126) ? String.fromCharCode (x) : '\u2022';
				}

				while (hex.length < 48) {
					hex += ' ';
				}

				while (chars.length < 16) {
					chars += ' ';
				}

				result += HEX_CHARS.charAt ((i>>12)&0xF) + HEX_CHARS.charAt ((i>>8)&0xF) + HEX_CHARS.charAt ((i>>4)&0xF) + HEX_CHARS.charAt (i&0xF) + ':  ' + hex + '    ' + chars + '\n';
			}

			return result;
		}
	}
}

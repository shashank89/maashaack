package com.playfish.rpc.share
{
	import flash.events.TimerEvent;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import flash.utils.getTimer;

	/**
	 * Base class of objects handling communication with the RPC server.
	 *
	 * <p>All of the methods in this class (and subclasses) that perform any network communication generally take two callback
	 * functions as parameters. If the operation succeeds, the "success" callback is invoked, and if the operation returns any
	 * values, these are passed as parameters to this callback. If the operation fails, the "error" callback is invoked. This
	 * takes no parameters. Neither callback may return a value.</p>
	 *
	 * <p>This class supports the concept of a <i>batch operation</i>. 
	 */
	public class RpcClientBase
	{
		/**
		 * Debug callback function.
		 */
		public static var debug:Function = trace;

		/**
		 * Timeout on initial server response, in milliseconds.
		 * This covers the time to perform DNS lookups, connect to the server, send the request to the server, process the request
		 * on the server, and receive the first buffer of response data. This timeout should not be affected by response size.
		 */
		public static var responseInitialTimeoutMillis:uint = 30000;

		/**
		 * Timeout on response progress, in milliseconds.
		 * This covers the time to receive a single buffer of response data. This timeout should not be affected by response size.
		 */
		public static var responseProgressTimeoutMillis:uint = 15000;

		/**
		 * Timeout on resource loading, in milliseconds.
		 * Any resources that fail to complete loading within this time are ignored.
		 */
		public static var resourceLoadTimeoutMillis:uint = 15000;

		/**
		 * Flag to control the automatic retry (using GET method) performed by the RPC client.
		 * If this is set to true, the RPC client will not perform any implicit retries.
		 */
		public static var disableRetryAsGet:Boolean = false;

		/**
		 * The maximum number of times that the RPC client will retry background event polling before giving up and calling
		 * the startEventDelivery() errorCallback. This value should NOT be changed without input from the server developer.
		 */
		public static var asyncPollErrorMaxRetryCount:uint = 3;

		/**
		 * The default delay before retrying a failed background poll request.
		 * The RPC client may choose to use a different value than this.
		 * This value should NOT be changed without input from the server developer.
		 */
		public static var asyncPollErrorDefaultRetryInterval:uint = 5000;

		/**
		 * Alternative timeout on initial server response used for asynchronous event poll requests, in milliseconds.
		 * This covers the time to perform DNS lookups, connect to the server, send the request to the server, process the request
		 * on the server, and receive the first buffer of response data. This timeout should not be affected by response size.
		 * Note that this timeout only applies to the first pollEvents() call sent - the server controls subsequent timeouts.
		 */
		public static var asyncPollDefaultResponseInitialTimeoutMillis:uint = 30000;

		/**
		 * Flash parameters.
		 */
		private var loaderParameters:Object;

		/**
		 * Default value for _numResourceCopies.
		 */
		private var defaultNumResourceCopies:uint;

		/**
		 * @private
		 * Callback to create a request object (subclass of RpcRequestBase).
		 */
		internal var createRequest:Function;

		/**
		 * @private
		 * Callback to create a response object (subclass of RpcResponseBase).
		 */
		internal var createResponse:Function;

		/**
		 * @private
		 * URL to which to post, extracted from Flash parameters.
		 */
		internal var url:String;

		/**
		 * @private
		 * Session ID, extracted from Flash parameters.
		 */
		public var sessionId:String;

		/**
		 * @private
		 * Base URL for profile pages, extracted from Flash parameters. The user ID is appended to this.
		 */
		internal var profileBase:String;

		/**
		 * @private
		 * Base URL for purchase pages, extracted from Flash parameters.
		 */
		internal var purchaseBase:String;

		/**
		 * @private
		 * Map of event type to response handler, initialised by calls to <code>registerEventType()</code>.
		 * The array index is the event type as an integer.
		 */
		private var eventTypeResponseHandlers:Array = new Array ();

		/**
		 * @private
		 * Map of event type to event handler, initialised by calls to <code>setEventHandler()</code>.
		 * The array index is the event type as an integer.
		 */
		private var eventHandlers:Array = new Array ();

		/**
		 * @private
		 * Array of IDs of events which have been received but not yet successfully acknowledged.
		 */
		private var mustAckEventIds:Array = new Array ();

		/**
		 * @private
		 * Flag set to true on the first call to pollEvents() or startEventDelivery().
		 * Once this is set, registerEventType() is no longer allowed to be called.
		 */
		private var eventInitDone:Boolean = false;

		/**
		 * @private
		 * Timer for asynchronous event polling.
		 * This field is set to null when asynchronous event delivery stops for any reason.
		 */
		private var asyncEventTimer:flash.utils.Timer;	// explicit package to work around bug in Flash CS3 linker

		/**
		 * @private
		 * Current error callback if asynchronous polling fails.
		 */
		private var asyncEventErrorCallback:Function = null;

		/**
		 * @private
		 * Current number of asynchronous poll errors that have been internally retried since the last success.
		 */
		private var asyncPollErrorCount:uint = 0;

		/**
		 * @private
		 * Current interval before retrying a failed asynchronous pollEvents() request.
		 * This is initialised to <code>pollErrorDefaultRetryInterval</code> but may be changed based on returned
		 * <code>minPollInterval</code>.
		 */
		private var asyncPollErrorRetryInterval:uint = asyncPollErrorDefaultRetryInterval;

		/**
		 * @private
		 * Current "initial response" timeout for asynchronous pollEvents() requests.
		 * This is initialised to <code>asyncPollDefaultResponseInitialTimeoutMillis</code> but will be changed based on
		 * returned <code>newClientRequestTimeout</code>.
		 */
		private var asyncPollResponseInitialTimeoutMillis:uint = asyncPollDefaultResponseInitialTimeoutMillis;

		/**
		 * The number of copies of each resource to load. Reset to default after each RPC method.
		 */
		private var _numResourceCopies:uint = defaultNumResourceCopies;

		/**
		 * Current batch mode, or <code>BATCHMODE_NONE<code> if there is no batch in progress.
		 */
		private var batchMode:uint = BATCHMODE_NONE;

		/**
		 * Array of requests within the current batch, or <code>null</code> if there is no batch in progress.
		 */
		private var subRequests:Array;

		/**
		 * Callback to get client times used in time tokens. This must take no arguments and return a value castable to
		 * <code>uint</code>, giving the number of milliseconds since some fixed reference point.
		 */
		private var timeCallback:Function;

		/**
		 * Epoch for times used in time tokens. This is reset to the current time whenever <code>resetTimes()</code> is called.
		 */
		private var epoch:Number;

		/**
		 * Array of timing data collected by <code>noteTime()</code>.
		 */
		private var _timingData:Array;

		/**
		 * @private
		 * Time as reported by getTimer() at the point that the init() RPC succeeded.
		 */
		protected var initResponseTime:uint = 0;

		/**
		 * Batch mode constant indicating that there is no batch in progress.
		 * This constant is private, as it's not a legal value to pass to <code>beginBatch()</code>.
		 */
		private static const BATCHMODE_NONE:uint = 0;

		/**
		 * Batch mode constant indicating that operations within the batch may be performed in any order, and can all succeed and
		 * fail independently of any other operations within the batch. This mode should only be used if there are no dependencies
		 * between any of the operations in the batch. This mode is roughly equivalent to the behaviour if no batch operation was
		 * in progress, and a number of operation methods were invoked without waiting for the previous ones to complete.
		 */
		public static const BATCHMODE_ASYNC:uint = 1;

		/**
		 * Batch mode constant indicating that operations within the batch must be performed in the order that the methods were
		 * called, but that processing of the batch should continue even if one operation fails. This mode should be used if
		 * operations must be performed in order, but later operations do not rely upon all earlier ones having succeeded.
		 */
		public static const BATCHMODE_INORDER:uint = 2;

		/**
		 * Batch mode constant indicating that tasks within the batch must be performed in the order that the methods were called,
		 * and that if any task fails, none of the following tasks within the batch should even be attempted. This mode should be
		 * used if any tasks within the batch rely upon some earlier tasks having succeeded. If any task fails, all later tasks
		 * will be abandoned, and the <code>errorCallback</code> will be called for each abandoned task. Note that this mode does
		 * <em>not</em> imply that earlier operations will be rolled back if later operations fail.
		 */
		public static const BATCHMODE_CONDITIONAL:uint = 3;

		/**
		 * Event type for <code>recordGameEvent</code> meaning that an ad impresssion has occurred.
		 */
		public static const GAME_EVENT_AD_IMPRESSION:uint = 0xFF;

		/**
		 * Event type for <code>recordGameEvent</code> meaning the user has visited the game sell page
		 */
		public static const GAME_EVENT_SELL_PAGE:uint = 0xFE;

		/**
		 * Event type for <code>recordGameEvent</code> meaning the user is playing the game.
		 */
		public static const GAME_EVENT_IS_PLAYING:uint = 0xFA;

		/**
		 * Constant indicating that item purchase was successful.
		 */
		public static const PURCHASE_CASH_OK:uint                 = 0;

		/**
		 * Constant indicating that item purchase was unsuccessful due to insufficient credit.
		 */
		public static const PURCHASE_CASH_FAIL_NOT_ENOUGH_CREDIT:uint     = 1;

		/**
		 * Constant indicating item delivery failed due to an offline shard
		 */
		public static const DELIVERY_FAILED_OFF_LINE_SHARD:uint     = 7;

		/**
		 * The first event type available for game-specific events.
		 */
		public static const GAME_SPECIFIC_EVENT_TYPE_MIN:uint = 0x01;

		/**
		 * The first event type available for game-specific events.
		 */
		public static const GAME_SPECIFIC_EVENT_TYPE_MAX:uint = 0x7F;

		/**
		 * Constant to pass to <code>setEventHandler()</code> and <code>getEventHandler()</code> to specify the handler for
		 * warnings caused by event processing.
		 * The <code>WARNING_EVENT</code> handler takes one argument: a message to assist in debugging the warning condition.
		 * Note that this message is not localised and may contain internal technical details, so should not be displayed to
		 * normal users. It should only be displayed as part of debug output.
		 */
		public static const WARNING_EVENT:uint = 0xFFFFFFFF;

		// Internal constants.

		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const ENCAPSULATION_NULL:uint               = 0x00;

		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_init:uint                   = 0x01;

		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getPricepoints:uint         = 0xF6;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_pollEvents:uint             = 0xF7;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getCashBalance:uint         = 0xF8;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getServerTime:uint          = 0xF9;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getPurchasableItems:uint    = 0xFA;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_recordGameEvent:uint        = 0xFB;
//		/** @private For some reason, asdoc thinks this is public, not internal. */
//		internal static const CALL_TYPE_getTimeToken1:uint          = 0xFC;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_getTimeToken0:uint          = 0xFD;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_ping:uint                   = 0xFE;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const CALL_TYPE_batchOperation:uint         = 0xFF;

		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const ERROR_RESPONSE:uint                   = 0x00;

		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const ERROR_REASON_UNKNOWN:uint             = 0x00;
		/** @private For some reason, asdoc thinks this is public, not internal. */
		internal static const ERROR_REASON_FORMAT:uint              = 0x01;

		// Maximum number of attempts to get a time token in noteTime().
		private static const NOTE_TIME_MAX_ATTEMPTS:uint = 3;

		// Maximum round-trip time of getTimeToken() call in noteTime(), in milliseconds. An RTT over this will trigger a retry.
		// This value should be no greater than the rejection threshold (MAX_TIME_RTT) on the server, and ideally equal to it.
		private static const NOTE_TIME_MAX_RTT:uint = 5000;
		
		/**
		 * @private
		 *
		 * Create a new RpcClient.
		 *
		 * Note that this simply creates the object. No network communication is initiated until the init() method is called.
		 *
		 * @param	the value of loaderInfo.parameters for the top-level Sprite or MovieClip
		 * @param	the default number of resource copies to load
		 * @param	a function to create RpcRequestBase subclasses
		 * @param	a function to create RpcResponseBase subclasses
		 * @param	
		 */
		public function
		RpcClientBase (loaderParameters:Object, defaultNumResourceCopies:uint, createRequest:Function, createResponse:Function)
		{
			this.loaderParameters = loaderParameters;
			this.defaultNumResourceCopies = defaultNumResourceCopies;
			this.createRequest = createRequest;
			this.createResponse = createResponse;

			this.url = loaderParameters['pf_url'];
			this.sessionId = loaderParameters['pf_session_id'];
			this.profileBase = loaderParameters['pf_profile_base'];
			this.purchaseBase = loaderParameters['pf_purchase_base'];

			debug (
				"RpcClientBase: url=" + url + " session=" + sessionId + " profileBase=" + profileBase
				+ " purchaseBase=" + purchaseBase
			);

			// XXX todo: fail if url or sessionId not set?
		}

		/**
		 * The number of copies of each referenced resource to load for the next RPC method.
		 *
		 * <p>Due to the Flash security model, it is often not possible to access the loaded resource, other than by adding it
		 * to the display. This causes a problem if the loaded resource must be displayed in more than one place at the same
		 * time, as the security restrictions prevent it from being copied.</p>
		 *
		 * <p>Setting this property to a value greater than 1 will cause multiple copies of each resource to be loaded. This
		 * property is reset back to 1 after each call to an RPC method, so it will only have an effect for the next call.
		 * This also applies to operations within a batch: this value must be set individually for each operation within the
		 * batch. It is valid to set this property to zero, meaning to not load any resources for the next RPC call.</p>
		 *
		 * <p><code>beginBatch()</code> and <code>endBatch()</code> calls do not use or reset this property.</p>
		 *
		 * @default		set by defaultNumResourceCopies constructor parameter
		 */
		public function get numResourceCopies ():uint
		{
			return _numResourceCopies;
		}

		public function set numResourceCopies (numCopies:uint):void
		{
			_numResourceCopies = numCopies;
		}

		/**
		 * Initialise the RPC client and attempt to connect to the server.
		 *
		 * <p> The other methods in this class must not be called until this method has returned successfully.</p>
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	successCallback
		 *			a function called if initialisation succeeds
		 * @param	errorCallback
		 *			a function called if initialisation fails
		 */
		public function init (
			successCallback:Function, errorCallback:Function):void
		{
			var fbParams:URLVariables = new URLVariables ();

			for (var name:String in loaderParameters) {
				if (name.match (/^fb_sig(_.*)?$/)) {
					fbParams[name] = loaderParameters[name];
				}
			}

			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_init, initResponseHandler, successCallback, errorCallback);

			request.writeString (Capabilities.serverString);
			request.writeString (String (fbParams));

			request.perform ();
		}

		/**
		 * Get current server time.
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with the following
		 * parameter:
		 * <ol>
		 * <li> a Date object representing current server time </li>
		 * </ol>
		 * </p>
		 *
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	successCallback
		 *			a function called if the operation succeeds
		 * @param	errorCallback
		 *			a function called if the operation fails
		 */
		public function getServerTime (
			successCallback:Function, errorCallback:Function): void
		{
			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_getServerTime, getServerTimeResponseHandler, successCallback, errorCallback);

			// There is no request-specific data.

			request.perform ();
		}

		/**
		 * Record a game event on the server.
		 *
		 * <p>This method simply requests that the specified event be recorded in the server logs. No processing is applied to
		 * the event, and no checks are made that the event is appropriate.</p>
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with no parameters.</p>
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	eventType
		 *			one of the <code>GAME_EVENT_~~</code> constants, indicating the type of event to record
		 * @param	detail
		 *			an extra detail string for the event (may be null or empty string if there is no extra detail required)
		 * @param	successCallback
		 *			a function called if the operation succeeds
		 * @param	errorCallback
		 *			a function called if the operation fails
		 */
		public function recordGameEvent (
			eventType:uint, detail:String,
			successCallback:Function, errorCallback:Function):void
		{
			if (detail == null) {
				detail = "";
			}

			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_recordGameEvent, emptyResponseHandler, successCallback, errorCallback);

			request.writeUint8 (eventType);
			request.writeUintvar32 (getTimer () - initResponseTime);
			request.writeString (detail);

			request.perform ();
		}

		/**
		 * Note the current client and server times. This information is stored internally to the <code>RpcClient</code>, and
		 * later used for anti-cheating measures when a score is uploaded. This method should be called at convenient points
		 * in the game, ideally just before and just after each mini-game. The client time used in this method is read from the
		 * <code>timeCallback</code> passed to the last call to <code>resetTimes()</code>.
		 */
		public function noteTime ():void
		{
			var attemptsRemaining:uint = NOTE_TIME_MAX_ATTEMPTS;
			var sendTime:uint;
			var client:RpcClientBase = this;	// 'this' does not work properly inside the nested function.

			noteTimeSendRequest ();

			function noteTimeSendRequest ():void
			{
				if (attemptsRemaining == 0) {
					debug ("noteTime: no attempts remaining");
					return;
				}

				attemptsRemaining--;

				sendTime = timeCallback () - epoch;
				debug ("noteTime: about to send; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS + "; sendTime=" + sendTime + " (abs=" + (sendTime+epoch) + ")");

				var request:RpcRequestBase = createRequest ();
				request.init (
					client, false, 0, CALL_TYPE_getTimeToken0,
					getTimeTokenResponseHandler,
					noteTimeSuccess,
					noteTimeError
				);

				request.writeUintvar32 (sendTime);
				// second field not used, as we're using getTimeToken0
//				timeRequest.writeUintvar32 (0xFFFF);

				request.perform ();
			}

			function noteTimeSuccess (token:ByteArray):void
			{
				var rtt:uint = timeCallback () - epoch - sendTime;
				debug ("noteTime: success callback; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS + "; rtt=" + rtt + " (abs=" + (rtt+sendTime+epoch) + ") token.length=" + token.length);

				// Always note the token: it may be later ignored by the server, but it's useful information.
				_timingData.push (new TimingData (token, Math.min(rtt, 0x7FFFFFFF) ));

				// Retry if RTT was excessive.
				if (rtt > NOTE_TIME_MAX_RTT) {
				debug ("noteTime: excessive RTT; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS);
					noteTimeSendRequest ();
				}
			}

			function noteTimeError ():void
			{
				debug ("noteTime: error callback; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS);
				noteTimeSendRequest ();
			}
		}

		/**
		 * Get a list of all purchasable items available to the current user.
		 *
		 * <p style="color:red;">Please note that this call is now deprecated.
		 * New code should use <code>getPricepoints()</code> instead.</p>
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with the following
		 * parameter:
		 * <ol>
		 * <li> an Array of PurchasableItem objects, each specifying an available product </li>
		 * </ol>
		 * </p>
		 *
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	successCallback
		 *			a function called if the operation succeeds
		 * @param	errorCallback
		 *			a function called if the operation fails
		 */
		public function getPurchasableItems (
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_getPurchasableItems, getPurchasableItemsResponseHandler, successCallback, errorCallback);

			// There is no request-specific data.

			request.perform ();
		}

		/**
		 * Get a list of all pricepoints available to the current user.
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with the following
		 * parameters:
		 * <ol>
		 * <li> a boolean, which will be <code>true</code> if the billing system is currently undergoing maintenance </li>
		 * <li> an Array of <code>Pricepoint</code> objects, each specifying an available product </li>
		 * </ol>
		 * </p>
		 *
		 * <p>Note that if the maintenance flag is <code>true</code>, the pricepoint array should be ignored (and will probably
		 * be empty). In these cases, billing-related features should not be shown to the user.</p>
		 *
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	an override for the detected user country. This should ONLY be used for debugging and QA testing, NEVER in
		 *			normal use by non-internal users. In normal cases, this should be passed as null, meaning no override.
		 * @param	a function called if the operation succeeds
		 * @param	a function called if the operation fails
		 */
		public function getPricepoints (
			countryOverride:String,
			successCallback:Function, errorCallback:Function):void
		{
			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_getPricepoints, getPricepointsResponseHandler, successCallback, errorCallback);

			request.writeString (countryOverride == null ? "" : countryOverride);

			request.perform ();
		}

		/**
		 * Get current users's Playfish cash.
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with the following
		 * parameter:
		 * <ol>
		 * <li> the user's current credit balance</li>
		 * </ol>
		 * </p>
		 *
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param	successCallback
		 *			a function called if the operation succeeds
		 * @param	errorCallback
		 *			a function called if the operation fails
		 */
		public function getCashBalance (
			successCallback:Function, errorCallback:Function): void
		{
			var request:RpcRequestBase =
				newRpcRequest (CALL_TYPE_getCashBalance, getCashBalanceResponseHandler, successCallback, errorCallback);

			// There is no request-specific data.

			request.perform ();
		}

		/**
		 * Reset the times collected by <code>noteTime()</code>.
		 *
		 * <p>This method should be called just before the start of each game session, before any calls to <code>noteTime()</code>
		 * within the game session. All of the information collected by earlier <code>noteTime()</code> calls is discarded.</p>
		 *
		 * <p>The anti-cheating code relies on this method having been called within 49 days before an <code>uploadScore()</code>
		 * call. If this is called immediately before starting the game session, this should not be a problem.</p>
		 *
		 * <p>Note that the function <code>flash.utils.getTimer()</code> can be passed directly as the <code>timeCallback</code>:
		 * <code>resetTimes (flash.utils.getTimer);</code></p>
		 *
		 * @param		timeCallback
		 *				a function (taking no arguments, and returning a value castable to <code>uint</code>) which returns
		 *				the number of milliseconds since some fixed reference point; the reference point must not change before
		 *				the next call to <code>resetTimes()</code>
		 */
		public function resetTimes (timeCallback:Function):void
		{
			this.timeCallback = timeCallback;
			this.epoch = timeCallback ();		// reset epoch
			this._timingData = new Array ();	// destroy any old timing data, since it's no longer valid
		}

		/**
		 * Set a handler for asynchronous events.
		 *
		 * Event handlers are functions returning no value, with arguments defined by the particular event type.
		 *
		 * @param	the event type, or <code>WARNING_EVENT</code> to set the handler for warning events
		 * @param	the event handler function, or <code>null</code> to remove any existing handler
		 *
		 * @return	the previous event handler, or <code>null</code> if there was no previous event handler
		 *
		 * @throws	Error
		 *			if the <code>eventType</code> is not known
		 */
		public function setEventHandler (eventType:uint, handler:Function):Function
		{
			if (eventTypeResponseHandlers[eventType] == null && eventType != WARNING_EVENT) {
				throw new Error ("invalid event type " + eventType);
			}

			var oldHandler:Function = eventHandlers[eventType];
			eventHandlers[eventType] = handler;
			return oldHandler;
		}

		/**
		 * Get a current event handler function.
		 *
		 * @param	the event type, or <code>WARNING_EVENT</code> to get the handler for warning events
		 *
		 * @return	the current event handler, or <code>null</code> if there is none set
		 *
		 * @throws	Error
		 *			if the <code>eventType</code> is not known
		 */
		public function getEventHandler (eventType:uint):Function
		{
			if (eventTypeResponseHandlers[eventType] == null && eventType != WARNING_EVENT) {
				throw new Error ("invalid event type " + eventType);
			}

			return eventHandlers[eventType];
		}

		/**
		 * Start asynchronous event delivery. If asynchronous event delivery is already running, this has no effect.
		 *
		 * <p>This should only be called if the game needs asynchronous events from this <code>RpcClient</code> instance, and if
		 * the server with which this client communicates has support for them.</p>
		 *
		 * <p>This must not be called before the <code>init()</code> RPC call succeeds. A suitable place to put this call is in
		 * the <code>init()</code> success callback.</p>
		 *
		 * <p>Asynchronous event delivery may stop running (or indeed fail to ever start) - for example, if server errors occur.
		 * Additionally, event delivery can be explicitly stopped by calling the <code>stopEventDelivery</code> function.
		 * If delivery stops for any reason other than a call to <code>stopEventDelivery</code>, the <code>errorCallback</code>
		 * will be called. Event delivery can be restarted (whether explicitly stopped, or stopped due to an error) by calling
		 * <code>startEventDelivery</code> again.</p>
		 *
		 * @param		a callback (taking no arguments, and returning no result) which will be called if asynchronous event
		 *				delivery stops running for any reason other than a call to <code>stopEventDelivery</code>
		 *
		 * @return		true if event delivery started as a result of the call; false if it was already running
		 */
		public function startEventDelivery (errorCallback:Function):Boolean
		{
			eventInitDone = true;

			if (asyncEventTimer == null) {
				// Create the asyncEventTimer now, though it won't be required until the initial poll succeeds or fails.
				// This field being non-null is used to indicate that background polling is occurring.
				// Timer completion always simply triggers a new asynchronous poll.
				// The delay on this timer is always explicitly set before it is started, as the delay depends on the context.
				asyncEventTimer = new Timer (asyncPollErrorRetryInterval, 1);
				asyncEventTimer.addEventListener (
					TimerEvent.TIMER_COMPLETE,
					function (event:TimerEvent):void {
						debug ("async event timer fired: " + event);
						pollEventsInternal (false, asyncPollSuccessHandler, asyncPollErrorHandler);
					}
				);

				// Remember the error callback, and clear the error count.
				asyncEventErrorCallback = errorCallback;
				asyncPollErrorCount = 0;

				// Send the initial pollEvents RPC.
				pollEventsInternal (false, asyncPollSuccessHandler, asyncPollErrorHandler);

				return true;
			} else {
				return false;
			}
		}

		/**
		 * Stop asynchronous event delivery. If asynchronous event delivery is not currently running, this has no effect.
		 *
		 * <p>Once this call returns, <code>isEventDeliveryRunning</code> will return <code>false</code>, and none of the
		 * registered event callbacks will be called unless <code>startEventDelivery</code> is called to restart asynchronous
		 * delivery, or <code>pollEvents</code> is called to perform a synchronous check for pending events.</p>
		 *
		 * <p>Note that no events will be lost by stopping event delivery running. Events will remain queued on the server and
		 * can be retrieved by restarting asynchronous delivery, or by sending synchronous <code>pollEvents</code> calls.
		 * A corollary of this is that games must define some explicit mechanism to tear down the game session and free up server
		 * resources when the user permanently leaves the game.</p>
		 *
		 * @return		true if event delivery stopped as a result of the call; false if it was not already running
		 */
		public function stopEventDelivery ():Boolean
		{
			eventInitDone = true;

			// Simply reset the timer (so no further timed actions occur), and set the timer field to null (which indicates that
			// asynchronous delivery is disabled). Also clear the error callback, since there's no need for it.
			if (asyncEventTimer != null) {
				asyncEventTimer.reset ();
				asyncEventTimer = null;
				asyncEventErrorCallback = null;
				asyncPollErrorCount = 0;

				return true;
			} else {
				return false;
			}
		}

		/**
		 * Check if asynchronous event delivery is currently running.
		 *
		 * <p>Asynchronous event delivery is started by a call to <code>startEventDelivery</code>. It can be explicitly stopped
		 * by a call to <code>stopEventDelivery</code>, and it may also stop if errors occur. This method returns true once
		 * <code>startEventDelivery</code> has been called, until either an error occurs or delivery is explicitly stopped.</p>
		 *
		 * @return	true if asynchronous event delivery is currently running
		 */
		public function isEventDeliveryRunning ():Boolean
		{
			return asyncEventTimer != null;
		}

		/**
		 * Synchronously poll for events from the server.
		 *
		 * <p>Any events which are available on the server will be delivered via the event handlers registered with
		 * <code>setEventHandler()</code>. Nothing is ever returned from this function directly.</p>
		 *
		 * <p>This method should normally be called as part of a batch operation, after some regular RPC method.</p>
		 *
		 * <p>If the operation succeeds, the <code>successCallback</code> will be called at some point, with no parameters.</p>
		 * <p>If the operation fails, the <code>errorCallback</code> will be called at some point, with no parameters.</p>
		 *
		 * @param		a function to be called if the operation succeeds
		 * @param		a function to be called if the operation fails
		 */
		public function pollEvents (successCallback:Function, errorCallback:Function):void
		{
			eventInitDone = true;

			// We don't care about the minPollInterval or newClientResponseTimeout that are passed to the pollEventsInternal
			// success callback, so we ignore them.
			pollEventsInternal (
				true,
				function (minPollInterval:uint, newClientResponseTimeout:uint, events:Array, ackEvents:Array):void {
					handleEventDelivery (events, ackEvents);
					successCallback ();
				},
				errorCallback
			);
		}

		// Register a response handler for an event type.
		// This must be called from the constructor for the game-specific RpcClient as many times as necessary.
		// The eventType must be in the game-specific range (0x01 - 0x7F).
		// Event responseHandler function follows the same pattern as RPC response handlers as are passed to
		// RpcClientBase.newRpcRequest() or RpcRequestBase.init():
		//   function exampleResponseHandler (response:RpcResponseBase, eventCallback:Function):Function
		//    - response is the RpcResponseBase from which the response should be read (exactly as for an RPC response handler)
		//    - eventCallback is the event callback that should be included in the return closure
		//      (exactly as for the successCallback parameter to an RPC response handler)
		//    - The returned function should be a closure that takes no arguments, returns no values, and calls the eventCallback
		//      with the event data parsed from the response (exactly as for an RPC response handler)
		/** @private */
		public function registerEventType (eventType:uint, responseHandler:Function):void
		{
			if (eventType < GAME_SPECIFIC_EVENT_TYPE_MIN || eventType > GAME_SPECIFIC_EVENT_TYPE_MAX) {
				throw new Error ("invalid event type " + eventType);
			}

			if (eventInitDone) {
				throw new Error ("can't register events now");
			}

			eventTypeResponseHandlers[eventType] = responseHandler;
			trace("Register Event Type" + eventType + " " + responseHandler);
		}

		// Create and send a pollEvents() RPC.
		// This method, and the success callback, do not directly correspond to the underlying network-level RPC.
		// If 'synchronous' is false, the RPC will be sent to the server immediately, even if a batch is currently active.
		// The 'synchronous' flag is also passed to the server as the 'immediate' flag.
		// This method copies the current state of mustAckEventIds on entry. This copy is passed to the server as the "ackEvents"
		// parameter, and is also passed as the fourth parameter to the successCallback.
		// This method does NOT update internal state (e.g. mustAckEventIds) or deliver any events. The successCallback is
		// responsible for passing its 'events' and 'ackEvents' parameters to handleEventDelivery() to perform these functions.
		private function pollEventsInternal (synchronous:Boolean, successCallback:Function, errorCallback:Function):void
		{
			// If this is an asynchronous request, we always ignore any batch in progress.
			var partOfBatch:Boolean = synchronous && (batchMode != BATCHMODE_NONE);

			// Ensure that array of acknowledged IDs is copied - we want a snapshot at the point this request is sent.
			var ackEventsCopy:Array = mustAckEventIds.concat ();

			// Note that we wrap the successCallback to pass the copied array of ack-events.
			var request:RpcRequestBase = createRequest ();
			request.init (
				this, partOfBatch, 0, CALL_TYPE_pollEvents,
				pollEventsResponseHandler,
				function (minPollInterval:uint, newClientRequestTimeout:uint, events:Array):void {
					successCallback (minPollInterval, newClientRequestTimeout, events, ackEventsCopy);
				},
				errorCallback
			);

			// Ensure that this request is never retried as a GET.
			request.triedGet = true;

			// Allow asynchronous poll request timeout to be changed independently of regular RPC timeout.
			if (!synchronous) {
				request.responseInitialTimeoutMillis = asyncPollResponseInitialTimeoutMillis;
			}

			request.writeBoolean (synchronous);		// Request immediate mode if synchronous, not if asynchronous.
			request.writeUintvar31 (request.responseInitialTimeoutMillis);
			request.writeArray (ackEventsCopy, request.writeUintvar31);

			if (partOfBatch) {
				subRequests.push (request);
			}

			request.perform ();
		}

		// RPC response handler for the pollEvents() RPC.
		// This simply reads the result including the array of events. It does not handle the received events in any way.
		private function pollEventsResponseHandler (response:RpcResponseBase, successCallback:Function):Function
		{
			var minPollInterval:uint = response.readUintvar31 ();
			var newClientRequestTimeout:uint = response.readUintvar31 ();
			var events:Array = response.readArray (readEvent);

			return function ():void {
				successCallback (minPollInterval, newClientRequestTimeout, events);
			};

			// Read a single AsyncEvent from the response.
			function readEvent ():AsyncEvent
			{
				var event:AsyncEvent = new AsyncEvent ();
				event.id = response.readUintvar31 ();
				event.type = response.readUint8 ();

				// Note that events never load any resource copies.
				var dataLength:uint = response.readUintvar31 ();
				var subResponse:RpcResponseBase = createResponse ();
				subResponse.initAsSubResponse (response, dataLength, 0);

				event.deliveryCallback = readEventBody (subResponse, event.type);
				subResponse.skipToEnd ();

				return event;
			}
		}

		// Read event body from sub-response. This looks up the correct response handler based on eventType.
		// This returns a function taking no arguments and returning no result.
		// Calling this returned function will cause the event to be delivered.
		// Note that the returned function may actually deliver a WARNING_EVENT rather than the specified event type.
		// If no WARNING_EVENT handler is registered, it may simply call the debug function as a final fallback!
		private function readEventBody (subResponse:RpcResponseBase, eventType:uint):Function
		{
			var eventResponseHandler:Function = eventTypeResponseHandlers[eventType];
			if (eventResponseHandler == null) {
				// Event type unknown.
				return warningEvent ("unknown event type " + eventType);
			}

			var eventHandler:Function = eventHandlers[eventType];
			if (eventHandler == null) {
				return warningEvent ("no handler set for event type " + eventType);
			}

			try {
				var result:Function = eventResponseHandler (subResponse, eventHandler);
			} catch (e:Error) {
				return warningEvent ("malformed event of type " + eventType + " received: " + e);
			}

			if (!subResponse.isDone ()) {
				return warningEvent ("malformed event of type " + eventType + " received: spurious data in event body");
			}

			return result;
		}

		// If a WARNING_EVENT handler is registered, return a closure that calls it with the specified message.
		// Otherwise, return a closure that prints a debug message.
		private function warningEvent (msg:String):Function
		{
			var warningHandler:Function = eventHandlers[WARNING_EVENT];

			if (warningHandler != null) {
				return function ():void {
					warningHandler (msg);
				}
			}

			return function ():void {
				debug ("event warning: " + msg);
			}
		}

		// Handle event delivery.
		// 'events' is the array of events just received from a poll call.
		// 'ackEvents' is the array of event IDs that were successfully acknowledged by the call.
		private function handleEventDelivery (events:Array, ackEvents:Array):void
		{
			// The request was successful, so we can assume the acknowledgements we sent were received.
			for each (var id:uint in ackEvents) {
				removeSetValue (mustAckEventIds, id);
			}

			// If we've received any events, their IDs will need acknowledging, so add to the list needing acknowledgement.
			for each (var event:AsyncEvent in events) {
				addSetValue (mustAckEventIds, event.id);
			}

			// If we've received any events, deliver them! Catch any exceptions that are thrown.
			for each (event in events) {
				try {
					event.deliveryCallback ();
				} catch (e:Error) {
					debug ("caught exception delivering event: id=" + event.id + " type=" + event.type + ": " + e);
				}
			}
		}

		// pollEvents RPC success handler for asynchronous event polling.
		private function asyncPollSuccessHandler (
			minPollInterval:uint, newClientRequestTimeout:uint, events:Array, ackEvents:Array):void
		{
			if (asyncEventTimer == null) {
				// Asynchronous event delivery is not currently running - presumably stopEventDelivery() was called while
				// the pollEvents RPC was active. The result of the call is simply ignored. Ideally, we would have a way to
				// cancel an in-flight RPC, and we could cancel the poll rather than simply ignoring it when it comes in.
				// (Note that we could choose to handle the ackEvents array here.)
				return;
			}

			asyncEventTimer.reset ();
			asyncPollErrorCount = 0;		// Error count is since the last successful poll.

			asyncPollResponseInitialTimeoutMillis = newClientRequestTimeout;

			handleEventDelivery (events, ackEvents);

			if (minPollInterval == 0) {
				// We can issue the next poll immediately.
				pollEventsInternal (false, asyncPollSuccessHandler, asyncPollErrorHandler);
			} else {
				// Delay before issuing next poll.
				// XXX Maybe we should adjust error delay based on last received minPollInterval?
				asyncEventTimer.delay = minPollInterval;
				asyncEventTimer.start ();
			}
		}

		// pollEvents RPC error handler for asynchronous event polling.
		private function asyncPollErrorHandler ():void
		{
			if (asyncEventTimer == null) {
				// Asynchronous event delivery is not currently running - presumably stopEventDelivery() was called while
				// the pollEvents RPC was active. The result of the call is simply ignored. Ideally, we would have a way to
				// cancel an in-flight RPC, and we could cancel the poll rather than simply ignoring it when it comes in.
				return;
			}

			asyncEventTimer.reset ();

			// Increment error count and check against threshold.
			asyncPollErrorCount++;
			if (asyncPollErrorCount > asyncPollErrorMaxRetryCount) {
				// There have been too many errors in a row. Stop asynchronous polling, and notify the game via error callback.
				asyncEventTimer = null;
				asyncEventErrorCallback ();
				asyncEventErrorCallback = null;
				return;
			}

			// Delay for the current error retry delay, then issue another poll.
			asyncEventTimer.delay = asyncPollErrorRetryInterval;
			asyncEventTimer.start ();
		}

		/**
		 * Start a 'batch' operation.
		 *
		 * <p>After this method is called, calls to any of the operation methods will not be sent to the RPC server immediately.
		 * Instead, they will be collected together, and sent in one batch when endBatch() is called. This allows for more
		 * efficient network communication, as the client knows that more requests are coming, and can make fewer server
		 * connections to perform the requests.</p>
		 *
		 * <p>Each method can still succeed or fail independently, and each method's <code>successCallback</code> or
		 * <code>errorCallback</code> will be invoked as appropriate.</p>
		 *
		 * @param	batchMode
		 *			the batch mode: one of the <code>BATCHMODE_</code>~~ constants.
		 *
		 * @see		RpcClient#BATCHMODE_ASYNC
		 * @see		RpcClient#BATCHMODE_INORDER
		 * @see		RpcClient#BATCHMODE_CONDITIONAL
		 * @see		RpcClient#endBatch()
		 *
		 * @throws	Error
		 *			if the batchMode value is not one of the <code>BATCHMODE_</code>~~ constants defined in this class,
		 *			or if there is already a batch operation in progress
		 */
		public function beginBatch (batchMode:uint = BATCHMODE_ASYNC):void
		{
			if (batchMode < BATCHMODE_ASYNC || batchMode > BATCHMODE_CONDITIONAL || this.batchMode != BATCHMODE_NONE) {
				throw new Error ();
			}

			this.batchMode = batchMode;
			this.subRequests = new Array ();
		}

		/**
		 * End a 'batch' operation.
		 *
		 * <p>This method ends a batch operation begun by an earlier beginBatch() call. All of the batched operations will be sent
		 * to the server, and their callbacks will be called as appropriate.</p>
		 *
		 * <p>If there is no batch operation in progress, or no operation methods have been invoked since the beginBatch() call,
		 * this method has no effect.</p>
		 *
		 * @see		RpcClient#beginBatch()
		 */
		public function endBatch ():void
		{
			// Copy and clear batchMode and subRequests, so that there is no longer a batch operation in progress.
			// This also has the effect of creating a private reference to subRequests that will be valid in the closures
			// passed to the request, even after these fields have been cleared.
			var batchMode:uint = this.batchMode;
			var subRequests:Array = this.subRequests;
			this.batchMode = BATCHMODE_NONE;
			this.subRequests = null;

			if (subRequests.length == 0) {
				debug ("endBatch: batch is empty!");
				return;
			}

			// Note that we pass null for the successCallback.
			// The batchResponseHandler() method below uses the success callbacks from the sub-requests directly.
			// Note that we ignore _numResourceCopies and pass then value 0, since the sub-requests have their own count.
			var batch:RpcRequestBase = createRequest ();
			batch.init (
				this, false, 0, CALL_TYPE_batchOperation, batchResponseHandler, null, batchErrorCallback
			);

			batch.writeUint8 (batchMode);
			batch.writeUintvar32 (subRequests.length);

			for each (var subRequest:RpcRequestBase in subRequests) {
				batch.writeSubRequest (subRequest);
			}

			batch.perform ();

			function batchResponseHandler (response:RpcResponseBase, successCallback:Function):Function
			{
				debug ("batch response: subRequests.length=" + subRequests.length);

				var responseCount:uint = response.readUintvar32 ();

				if (responseCount != subRequests.length) {
					debug ("batch response: response count " + responseCount + " mismatch with request count " + subRequests.length);
					throw new Error ();
				}

				var subCallbacks:Array = new Array (responseCount);

				for (var i:uint = 0; i<responseCount; i++) {
					subCallbacks[i] = subRequests[i].errorCallback;
				}

				for (i=0; i<responseCount; i++) {
					var subRequest:RpcRequestBase = subRequests[i];
					var subResponseMsgType:uint = response.readUint8 ();
					var subResponseLength:uint = response.readUintvar32 ();
					debug ("batch response: sub response: msgType=" + subResponseMsgType + " length=" + subResponseLength);

					if (subResponseMsgType == ERROR_RESPONSE) {
						debug ("batch response: got error response to sub-operation " + i);

						if (subResponseLength == 0) {
							continue;
						} else {
	 						debug ("batch response: error response has length " + subResponseLength + " != 0");
							throw new Error ();
						}
					}

					if (subResponseMsgType != subRequest.msgType && subResponseMsgType != ERROR_RESPONSE) {
						debug ("batch response: sub response message type " + subResponseMsgType + " mismatch with sub request type " + subRequest.msgType);
						throw new Error ();
					}

					// Note that the sub-response gets the numResourceCopies from the corresponding sub-request, NOT from the batch.
					var subResponse:RpcResponseBase = createResponse ();
					subResponse.initAsSubResponse (response, subResponseLength, subRequest.numResourceCopies);

					// Call the sub-request's responseHandler to parse the response.
					var subSuccessCallback:Function = subRequest.responseHandler (subResponse, subRequest.successCallback);

					if (!subResponse.isDone ()) {
						debug ("batch response: sub response handler returned, but isDone() is false");
						throw new Error ();
					}

					subCallbacks[i] = subSuccessCallback;
				}

				// Note that we ignore the passed successCallback (which should be null), and use the real callbacks directly.
				return function ():void {
					for each (var callback:Function in subCallbacks) {
						try {
							callback ();
						} catch (e:Error) {
							debug ("batch response: sub response handler threw error: " + e);
							// ignored
						}
					}
				};
			}

			function batchErrorCallback ():void
			{
				for each (var subRequest:RpcRequestBase in subRequests) {
					try {
						subRequest.errorCallback ();
					} catch (e:Error) {
						// ignored
					}
				}
			}
		}

		// Create a new RPC request object, and record it as part of the current batch if appropriate.
		/** @private */
		protected function newRpcRequest (
			callType:uint, responseHandler:Function, successCallback:Function, errorCallback:Function):RpcRequestBase
		{
			var partOfBatch:Boolean = (batchMode != BATCHMODE_NONE);

// XXX pass null for url and sessionId if part of batch? could use this rather than explicit flag to detect batch mode?
			var request:RpcRequestBase = createRequest ();
			request.init (
				this, partOfBatch, _numResourceCopies, callType,
				responseHandler, successCallback, errorCallback
			);

			if (partOfBatch) {
				subRequests.push (request);
			}

			_numResourceCopies = defaultNumResourceCopies;

			return request;
		}

		/** @private **/
		protected function get timingData ():Array
		{
			return _timingData;
		}

		// Response handler function for any response that has no body and requires no processing other than reporting success.
		/** @private **/
		public static function emptyResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			// There is nothing to read from the response, and nothing to pass to the successCallback.
			// Furthermore, the successCallback already takes no arguments and returns no value.
			return successCallback;
		}

		// Response handler for the init() operation.
		// Note that this response handler is not static, as it needs access to the 'sessionId' field.
		private function initResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			// If the response includes a new session ID, use it.
			var newSessionId:String = response.readString ();

			if (newSessionId != '') {
				sessionId = newSessionId;
			}

			initResponseTime = getTimer ();

			return successCallback;
		}

		// Response handler for the getTimeToken() operation. (The same handler applies to getTimeToken0 and getTimeToken1.)
		private static function getTimeTokenResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			var timeToken:ByteArray = response.readByteArray ();

			return function ():void {
				successCallback (timeToken);
			};
		}

		// Response handler for the getPurchasableItems() operation.
		private static function getPurchasableItemsResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			var purchasableItems:Array = response.readArray (response.readPurchasableItem);

			return function ():void {
				successCallback (purchasableItems);
			};
		}

		// Response handler for the getPricepoints() operation.
		private static function getPricepointsResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			var isMaintenance:Boolean = response.readBoolean ();
			var pricepoints:Array = response.readArray (response.readPricepoint);

			return function ():void {
				successCallback (isMaintenance, pricepoints);
			};
		}

		// Response handler for the getServerTime() operation.
		private static function getServerTimeResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			var time:Date = response.readDate ();

			return function ():void {
				successCallback (time);
			};
		}

		// Response handler for the getCashBalance() operation.
		private static function getCashBalanceResponseHandler (
			response:RpcResponseBase, successCallback:Function):Function
		{
			var credit:uint = response.readUintvar31 ();

			return function ():void {
				successCallback (credit);
			};
		}

		// Add a value to an array used as a set of uints.
		// If the value is already in the array, this does nothing. Otherwise, it is added.
		private static function addSetValue (set:Array, value:uint):void
		{
			if (set.indexOf (value) < 0) {
				set.push (value);
			}
		}

		// Remove a value from an array used as a set of uints.
		// If the value is present in the array, it is removed. Otherwise, this does nothing.
		private static function removeSetValue (set:Array, value:uint):void
		{
			var index:uint = set.indexOf (value);
			if (index >= 0) {
				set.splice (index, 1);
			}
		}
	}
}

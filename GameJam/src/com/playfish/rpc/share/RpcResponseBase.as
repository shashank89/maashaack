package com.playfish.rpc.share
{
	import flash.display.DisplayObject;
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/** @private **/
	public class RpcResponseBase
	{
		
		// The RpcClientBase to which this belongs.
		private var client:RpcClientBase;
		
		private var body:ByteArray;
		private var endPosition:uint;

		// Array of ResourceRequest objects, added to by registerResourceUrl().
		// This is passed in at construction time, and this class only ever adds to it - processing the list is done elsewhere.
		// This list may be shared with other RpcResponse objects.
		internal var resourceRequests:Array;

		// The number of copies to create of each referenced resource.
		private var numResourceCopies:uint;

		// The constructor takes no arguments, as all initialisation is done by the init() method.
		public function RpcResponseBase ()
		{
			// No operation.
		}

		// Initialise this RpcResponse.
		// This is not done in the constructor as then all subclasses would have to be kept synchronised with this parameter list.
		internal function init (
			client:RpcClientBase,
			body:ByteArray, length:uint, resourceRequests:Array, numResourceCopies:uint):void
		{
			this.client = client;
			
			this.body = body;
			this.body.endian = Endian.BIG_ENDIAN;

			this.endPosition = body.position + length;
			this.resourceRequests = resourceRequests;
			this.numResourceCopies = numResourceCopies;
RpcClientBase.debug ("RpcResponse: create: position=" + body.position + " length=" + length + " endPosition=" + endPosition + " numResourceCopies=" + numResourceCopies);
		}

		// Initialise this RpcResponse to read part of the body of a batch response.
		// The new object will share the same body and resourceRequests.
		// The new object's body will start at the current position and have the specified length.
		internal function initAsSubResponse (batch:RpcResponseBase, length:uint, numResourceCopies:uint):void
		{
			init (batch.client, batch.body, length, batch.resourceRequests, numResourceCopies);
		}

		internal function isDone ():Boolean
		{
if (body.position != endPosition) { RpcClientBase.debug ("RpcResponse: isDone: position=" + body.position + " endPosition=" + endPosition); }

			return body.position == endPosition;
		}

		internal function skipToEnd ():void
		{
			RpcClientBase.debug ("RpcResponse: skipToEnd: position=" + body.position + " endPosition=" + endPosition);
			body.position = endPosition;
		}

		public function readUint8 ():uint
		{
			if (body.position >= endPosition) {
				throw new EOFError ();
			}

			return body.readUnsignedByte ();
		}

		public function readUintvar32 ():uint
		{
			var value:uint = 0;

			do {
				var read:uint = readUint8 ();
				value = (value << 7) | (read & 0x7F);
				// XXX we don't actually bother checking for overflow or redundant leading 0x80's.
			} while ((read & 0x80) != 0);

			return value;
		}

		public function readUintvar31 ():uint
		{
			var value:uint = readUintvar32 ();

			if ((value & 0x80000000) != 0) {
				throw new Error ();
			}

			return value;
		}

		public function readIntvar32 ():int
		{
			var uvalue:uint = readUintvar32 ();

			if ((uvalue & 1) != 0) {
				return ~(uvalue >>> 1);
			} else {
				return uvalue >>> 1;
			}
		}

		public function readFloat32 ():Number
		{
			return body.readFloat ();
		}

		public function readFloat64 ():Number
		{
			return body.readDouble ();
		}

		public function readBoolean ():Boolean
		{
			var octet:uint = readUint8 ();

			if (octet == 0) {
				return false;
			} else if (octet == 1) {
				return true;
			} else {
				throw new Error ();
			}
		}

		public function readString ():String
		{
			var length:uint = readUintvar32 ();
			var str:String = "";

			for (var i:uint = 0; i<length; i++) {
				var c:uint = readUint8 ();

				switch (c >>> 4) {
					// 1-byte form: 0xxxxxxx.
					case 0x00: case 0x01: case 0x02: case 0x03: case 0x04: case 0x05: case 0x06: case 0x07:
						// We don't even need to mask!
						break;

					// 2-byte form: 110xxxxx 10xxxxxx.
					case 0x0C: case 0x0D:
						c &= 0x1F;
						c = (c << 6) | readUtf8Extension ();
						break;

					// 3-byte form: 1110xxxx 10xxxxxx 10xxxxxx.
					case 0x0E:
						c &= 0x0F;
						c = (c << 6) | readUtf8Extension ();
						c = (c << 6) | readUtf8Extension ();
						break;

					// XXX We don't handle the 4-byte form (Unicode code points past U+FFFF).
					default:
RpcClientBase.debug ("malformed UTF-8: found char beginning with octet " + c);
						throw new Error ();
				}

				str += String.fromCharCode (c);
			}

			return str;
		}

		public function readBitSet():BitSet
		{
			var value:BitSet = new BitSet();
			value.setArray(readByteArray());

			return value;
		}

		public function readByteArray ():ByteArray
		{
			var length:uint = readUintvar32 ();

			if (body.position+length > endPosition) {
				throw new EOFError ();
			}

			var value:ByteArray = new ByteArray ();
			body.readBytes (value, 0, length);

			return value;
		}

		public function readDate ():Date
		{
			// Dates are transmitted as a 32-bit count of seconds since the epoch.
			var timestamp:uint = readUintvar32 ();
			return (timestamp == 0) ? null : new Date (timestamp * 1000.0);
		}

		public function readNetworkUid ():NetworkUid
		{
			var network:uint = readUintvar31 ();
			if (network == 0) {
				return null;
			}
			var uid:String = readString ();
			var playfishUid:uint = readUintvar31 ();
			return new NetworkUid (network, uid, playfishUid);
		}

		// Read array value from response body.
		// The readElement function must be one of the other read*() methods from this class.
		public function readArray (readElement:Function):Array
		{
			var length:uint = readUintvar32 ();
			var value:Array = new Array (length);

			for (var i:uint = 0; i<length; i++) {
				value[i] = readElement ();
			}

			return value;
		}

		// Read sparse array value from response body.
		// The readElement function must be one of the other read*() methods from this class.
		public function readSparseArray (readElement:Function):Array
		{
			var count:uint = readUintvar32 ();
			var value:Array = new Array ();

			for (; count>0; count--) {
				var index:uint = readUintvar32 ();
				value[index] = readElement ();
			}

			return value;
		}
		
		// Read a ServerInfo value from response body.
		public function readServerInfo ():ServerInfo
		{
			var url:String = readString ();
			var future:Array = readSparseArray (readString);	// For future expansion; currently ignored.

			var serverInfo:ServerInfo = new ServerInfo ();

			serverInfo.url = url;
			serverInfo.sessionId = client.sessionId;
			serverInfo.profileBase = client.profileBase;
			serverInfo.purchaseBase = client.purchaseBase;

			return serverInfo;
		}

		// Register a resource URL as requiring loading.
		// This method does not actually initiate the resource load, but notes it in the resourceRequests array.
		// The returned array will be filled in later on, with up to numResourceCopies copies of the resource.
		public function registerResourceUrl (resourceUrl:String):Array
		{
			var result:Array = new Array ();
RpcClientBase.debug ("registerResourceUrl: url=\"" + resourceUrl + "\" numResourceCopies=" + numResourceCopies);

			if (resourceUrl != "") {
				for (var i:uint = 0; i<numResourceCopies; i++) {
					resourceRequests.push (new ResourceRequest (resourceUrl, result));
				}
			}
else { RpcClientBase.debug ("registerResourceUrl: url is empty string: skipping image"); }

			return result;
		}

		// Get the profile base URL.
		public function get profileBase ():String
		{
			return client.profileBase;
		}

		// Read PurchasableItem value from response body.
		internal function readPurchasableItem ():PurchasableItem
		{
			var skuId:uint = readUintvar32 ();
			var amount:uint = readUintvar32 ();
			var currency:String = readString ();
			var token:String = readString ();

			return new PurchasableItem (client.purchaseBase, skuId, amount, currency, token);
		}

		// Read Pricepoint value from response body.
		internal function readPricepoint ():Pricepoint
		{
			var productType:uint = readUintvar31 ();
			var payoutParameter:uint = readUintvar31 ();
			var paymentProvider:uint = readUintvar31 ();
			var price:uint = readUintvar31 ();
			var currency:String = readString ();
			var currencyScale:uint = readUintvar31 ();
			var clientData:String = readString ();
			var token:String = readString ();

			return new Pricepoint (
				client.purchaseBase,
				productType, payoutParameter, paymentProvider, price, currency, currencyScale, clientData,
				token
			);
		}

		// Private function to read a single UTF-8 extension byte.
		// Such bytes must have the form 10xxxxxx, and this function returns the 6 bits xxxxxx.
		private function readUtf8Extension ():uint
		{
			var x:uint = readUint8 ();

			if ((x & 0xC0) != 0x80) {
RpcClientBase.debug ("malformed UTF-8: found invalid extension octet " + x);
				throw new Error ();
			}

			return (x & 0x3F);
		}
	}
}

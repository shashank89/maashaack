package com.playfish.rpc.share
{
	import flash.utils.ByteArray;

	/**
	 * Representation of a user ID.
	 * Note that these objects cannot be created outside the RPC client.
	 */
	public class NetworkUid
	{
		/** @private */
		internal var _network:uint;

		/** @private */
		internal var _networkUid:String;

		/** @private */
		internal var _playfishUid:uint;

//		public static const PLAYFISH:uint = 1;

		/**
		 * Network ID for Facebook users.
		 */
		public static const FACEBOOK:uint = 2;

		/**
		 * Network ID for MySpace users.
		 */
		public static const MYSPACE:uint = 3;

		/**
		 * Network ID for Bebo users.
		 */
		public static const BEBO:uint = 4;

		/**
		 * Network ID for Yahoo users.
		 */
		public static const YAHOO:uint = 5;

		/**
		 * Network ID for Netlog users.
		 */
		public static const NETLOG:uint = 6;

		/**
		 * Network ID for iGoogle users.
		 */
		public static const IGOOGLE:uint = 7;

		/**
		 * Special network ID that will never be used for a real network.
		 * This should be used if a game needs to create reserved UIDs that will never be equal to any real user.
		 * Note that NetworkUid objects with this network cannot ever be sent to the server, as this value is out of range.
		 */
		public static const INTERNAL_USER:uint = 0xFFFFFFFF;

		/** @private */
		function NetworkUid (_network:uint, _networkUid:String, _playfishUid:uint)
		{
			this._network = _network;
			this._networkUid = _networkUid;
			this._playfishUid = _playfishUid;
		}

		/**
		 * The network for which the user ID is valid.
		 * Most applications should not need to use this.
		 */
		public function get network ():uint
		{
			return _network;
		}

		/**
		 * The network-specific user ID, as a string.
		 * Most applications should not need to use this.
		 */
		public function get networkUid ():String
		{
			return _networkUid;
		}

		/**
		 * The Playfish user ID.
		 * This may be zero for users who do not have the application installed.
		 */
		public function get playfishUid ():uint
		{
			return _playfishUid;
		}

		/**
		 * A hash value derived from the network UID.
		 * This value will always be the same for the same UID. This can be used to seed a PRNG for cases where a game needs
		 * to assign random values to users (for example, default avatar customisation) yet have these random values stay the
		 * same for any single user.
		 */
		public function get seed ():uint
		{
			// 0x58370C09 is an arbitrary starting value.
			// 3571 and 23 are prime numbers.
			var value:uint = 0x58370C09 + (_network * 3571);

			for (var i:uint = 0; i<_networkUid.length; i++) {
				value = (value * 23) + _networkUid.charCodeAt (i);
			}

			return value;
		}

		/**
		 * Return a string representation of this NetworkUid. The representation consists of the <code>network</code>, a colon,
		 * and the <code>networkUid</code>. Note that <code>uid1.toString() == uid2.toString()</code> if and only if
		 * <code>NetworkUid.areEqual(uid1,uid2)</code>. As a result, this string form is useful as an index in a hash table.
		 */
		// The string form is designed to be useful as an index in a hash.
		public function toString ():String
		{
			return _network + ":" + _networkUid;
		}

		/**
		 * Check if two NetworkUid objects are equal to one another. They are considered equal if and only if
		 * <code>uid1.network == uid2.network</code> and <code>uid1.networkUid == uid2.networkUid</code>.
		 */
		public static function areEqual (uid1:NetworkUid, uid2:NetworkUid):Boolean
		{
			return uid1._network == uid2._network && uid1._networkUid == uid2._networkUid;
		}

		/**
		 * Static factory method to create <code>NetworkUid</code> objects.
		 * The <code>playfishUid</code> field of the created object will be zero.
		 * <p>
		 * Please note that this function must only be used to create <code>NetworkUid</code> objects from user IDs read
		 * from some external source (for example, from flashvars). Most games will have no need for this feature. If a user
		 * ID was received in an RPC response, simply pass it around as the original <code>NetworkUid</code> object.
		 * </p><p>
		 * To create <code>NetworkUid</code> objects that do not refer to a real user, pass <code>INTERNAL_USER</code> for the
		 * network.
		 * </p>
		 *
		 * @param	the network ID
		 * @param	the network-specific user ID
		 *
		 * @return	a <code>NetworkUid</code> encapsulating the values
		 */
		public static function create (network:uint, networkUid:String):NetworkUid
		{
			return new NetworkUid (network, networkUid, 0);
		}
	}
}
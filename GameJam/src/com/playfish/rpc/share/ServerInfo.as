package com.playfish.rpc.share
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Opaque object representing the details required to connect to an RPC server.
	 *
	 * An instance of this object can be passed to RpcClient / RpcClientBase constructors in place of Flash loader parameters.
	 * It contains all of the information required to initialise the client.
	 */
	public class ServerInfo
	{
		/**
		 * @private
		 * URL to which to post.
		 */
		internal var url:String;

		/**
		 * @private
		 * Session ID.
		 */
		internal var sessionId:String;

		/**
		 * @private
		 * Base URL for profile pages. The user ID is appended to this.
		 */
		internal var profileBase:String;

		/**
		 * @private
		 * Base URL for purchase pages.
		 */
		internal var purchaseBase:String;
	}
}

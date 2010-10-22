package com.playfish.rpc.share
{
	import flash.utils.ByteArray;

	/**
	 * Internal class used to store timing data recorded by <code>RpcClientBase.noteTime()</code>.
	 */
	internal class TimingData
	{
		internal var token:ByteArray;
		internal var rtt:uint;

		function TimingData (token:ByteArray, rtt:uint)
		{
			this.token = token;
			this.rtt = rtt;
		}
	}
}
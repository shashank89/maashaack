package com.playfish.rpc.share
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Object representing an item available to purchase within the game.
	 *
	 * <p style="color:red;">Please note that this class is now deprecated. New code should be using the
	 * <code>getPricepoints()</code> call (which returns <code>Pricepoint</code> objects) rather than
	 * <code>getPurchasableItems()</code>.</p>
	 *
	 * <p>Note that the price specified by this object is specified as an integer, in the "minor unit" of the relevant currency.
	 * For example, a price in Euros would be specified here as the number of Euro cents. The relation between the "major unit"
	 * and "minor unit" is a standard property of the currency. ISO 4217 represents this as a "currency exponent" giving the
	 * number of digits after the decimal point: here, all prices are multiplied by 10 to the power of this currency exponent.</p>
	 *
	 * @see http://en.wikipedia.org/wiki/ISO_4217
	 */
	public class PurchasableItem
	{
		private var baseUrl:String;
		private var _skuId:uint;
		private var _price:uint;
		private var _currency:String;
		private var token:String;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by PayPal.
		 */
		public static const PAYMENT_PROVIDER_PAYPAL:uint = 1;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by TrialPay.
		 */
		public static const PAYMENT_PROVIDER_TRIALPAY:uint = 2;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by Paymo.
		 */
		public static const PAYMENT_PROVIDER_PAYMO:uint = 3;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by PayByCash.
		 */
		public static const PAYMENT_PROVIDER_PAYBYCASH:uint = 4;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by OneBip.
		 */
		public static const PAYMENT_PROVIDER_ONEBIP:uint = 5;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by Moneybookers.
		 */
		public static const PAYMENT_PROVIDER_MONEYBOOKERS:uint = 6;

		/**
		 * Payment provider constant to pass to getPurchaseLink() to indicate payment by SuperRewards.
		 */
		public static const PAYMENT_PROVIDER_SUPERREWARDS:uint = 7;

		/** @private */
		function PurchasableItem (baseUrl:String, skuId:uint, price:uint, currency:String, token:String)
		{
			this.baseUrl = baseUrl;
			this._skuId = skuId;
			this._price = price;
			this._currency = currency;
			this.token = token;
		}

		/**
		 * The SKU ID for this purchasable item.
		 */
		public function get skuId ():uint
		{
			return _skuId;
		}

		/**
		 * The price of this item in the "minor unit" of the relevant currency.
		 * For example, if <code>currency</code> is "EUR", then this value is specified in Euro cents, not Euros.
		 */
		public function get price ():uint
		{
			return _price;
		}

		/**
		 * The currency in which this item must be purchased. This is a 3-letter ISO 4217 currency code.
		 * @see http://en.wikipedia.org/wiki/ISO_4217
		 */
		public function get currency ():String
		{
			return _currency;
		}

		/**
		 * Get a <code>URLRequest</code> object that can be passed to <code>navigateToURL()</code> to begin the
		 * purchase of this item.
		 *
		 * @param		the ID of the payment provider to use for the purchase
		 * @param		a special string value that will be passed through the whole purchase process, and will be available
		 *				in the <code>pf_purchase_passthrough</code> loader parameter when the game restarts after purchase
		 * @param		the quantity of the item that is required
		 *
		 * @return		a <code>URLRequest</code> object to be passed to <code>navigateToURL()</code>
		 */
		public function getPurchaseLink (paymentProvider:uint, passthrough:String = null, quantity:uint = 1):URLRequest
		{
			if (quantity < 1) {
				throw new Error ("quantity cannot be less than 1");
			}

			var link:URLRequest = new URLRequest (baseUrl);
			var params:URLVariables = new URLVariables ();

			params['token'] = this.token;
			params['pp'] = String (paymentProvider);

			if (passthrough != null) {
				params['x'] = passthrough;
			}

			if (quantity != 1) {
				params['qty'] = String (quantity);
			}

			link.method = URLRequestMethod.POST;
			link.data = params;

			return link;
		}
	}
}

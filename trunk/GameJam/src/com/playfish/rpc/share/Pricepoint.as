package com.playfish.rpc.share
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Object representing a pricepoint for something available to purchase within the game.
	 *
	 * <p>Some payment providers do not directly use price information. For example, "get X free" providers generally have the
	 * price listed with currency XXX and price zero, indicating that the price is zero. For some providers, the actual amount
	 * is not known until the user clicks through to the provider site. For example, premium SMS has so many different prices
	 * and rules that it is easiest to list one price point with no price shown, and have the provider deal with the complexity.
	 * In these cases, the price will be zero and the currency will be the empty string.</p>
	 *
	 * <p>Note that the price specified by this object is specified as an integer, in the "minor unit" of the relevant currency.
	 * For example, a price in Euros would be specified here as the number of Euro cents. The relation between the "major unit"
	 * and "minor unit" is a standard property of the currency. ISO 4217 represents this as a "currency exponent" giving the
	 * number of digits after the decimal point: here, all prices are multiplied by 10 to the power of this currency exponent.
	 * The <code>currencyScale</code> field explicitly passes this scale factor.</p>
	 *
	 * @see http://en.wikipedia.org/wiki/ISO_4217
	 */
	public class Pricepoint
	{
		private var baseUrl:String;
		private var _productType:uint;
		private var _payoutParameter:uint;
		private var _paymentProvider:uint;
		private var _price:uint;
		private var _currency:String;
		private var _currencyScale:uint;
		private var _clientData:String;
		private var token:String;

		/**
		 * Payment provider constant: payment by PayPal.
		 */
		public static const PAYMENT_PROVIDER_PAYPAL:uint = 1;

		/**
		 * Payment provider constant: payment by TrialPay.
		 */
		public static const PAYMENT_PROVIDER_TRIALPAY:uint = 2;

		/**
		 * Payment provider constant: payment by Paymo.
		 */
		public static const PAYMENT_PROVIDER_PAYMO:uint = 3;

		/**
		 * Payment provider constant: payment by PayByCash.
		 */
		public static const PAYMENT_PROVIDER_PAYBYCASH:uint = 4;

		/**
		 * Payment provider constant: payment by OneBip.
		 */
		public static const PAYMENT_PROVIDER_ONEBIP:uint = 5;

		/**
		 * Payment provider constant: payment by Moneybookers.
		 */
		public static const PAYMENT_PROVIDER_MONEYBOOKERS:uint = 6;

		/**
		 * Payment provider constant: payment by SuperRewards.
		 */
		public static const PAYMENT_PROVIDER_SUPERREWARDS:uint = 7;

		/** @private */
		function Pricepoint (
			baseUrl:String,
			productType:uint, payoutParameter:uint, paymentProvider:uint, price:uint, currency:String, currencyScale:uint,
			clientData:String, token:String)
		{
			this.baseUrl = baseUrl;
			this._productType = productType;
			this._payoutParameter = payoutParameter;
			this._paymentProvider = paymentProvider;
			this._price = price;
			this._currency = currency;
			this._currencyScale = currencyScale;
			this._clientData = clientData;
			this.token = token;
		}

		/**
		 * The product type ID for this pricepoint.
		 *
		 * <p>Product type IDs represent a particular type of item that can be purchased. For example, "Playfish Cash" is one
		 * product type. There will usually be many pricepoints for a single product type.</p>
		 *
		 * <p>Product types can be parameterised by the <code>payoutParameter</code> value. For example, a product type
		 * representing something like "Playfish Cash" or (game-specific) "Coins" may be parameterised by the quantity of that
		 * product that is offered for purchase at this price.</p>
		 */
		public function get productType ():uint
		{
			return _productType;
		}

		/**
		 * The payout parameter qualifying the product type for this pricepoint.
		 *
		 * <p>The meaning of this value is entirely dependent on the product type. For example, a product type representing
		 * something like "Playfish Cash" or (game-specific) "Coins" is likely to interpret this value to indicate the quantity
		 * of that product that is offered for purchase at this price. Alternatively, a product type like "Extra Level Unlock"
		 * might interpret this value to indicate which of a fixed number of levels will be unlocked by this purchase. Some
		 * product types may ignore this value altogether (for example, product types that represent legacy SKUs).</p>
		 */
		public function get payoutParameter ():uint
		{
			return _payoutParameter;
		}

		/**
		 * The payment provider to be used for this pricepoint.
		 */
		public function get paymentProvider ():uint
		{
			return _paymentProvider;
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
		 * The scale factor for the currency. For example, if <code>currency</code> is "EUR", then this will be 100.
		 * Note that this may be zero, for prices that do not involve a currency (where <code>currency</code> is "XXX"
		 * or "").
		 */
		public function get currencyScale ():uint
		{
			return _currencyScale;
		}

		/**
		 * Client-specific data for this pricepoint.
		 *
		 * <p>Note that this returns multiple fields in a <code>URLVariables</code> object.</p>
		 */
		public function get clientData ():URLVariables
		{
			return _clientData == "" ? null : new URLVariables (_clientData);
		}

		/**
		 * Get a <code>URLRequest</code> object that can be passed to <code>navigateToURL()</code> to begin the
		 * purchase of this item.
		 *
		 * @return		a <code>URLRequest</code> object to be passed to <code>navigateToURL()</code>
		 */
		public function getPurchaseLink ():URLRequest
		{
			var link:URLRequest = new URLRequest (baseUrl);
			var params:URLVariables = new URLVariables ();

			params['token'] = this.token;

			link.method = URLRequestMethod.POST;
			link.data = params;

			return link;
		}
	}
}

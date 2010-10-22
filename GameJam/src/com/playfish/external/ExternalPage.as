package com.playfish.external
{
	import flash.external.ExternalInterface;
	import flash.events.*;
	import flash.net.*;
	import flash.display.*;
	import flash.system.Security;
		
	/**
	 * Object handling the communication with the javascript to open 
	 * pop-up or redirect call on some pages like invite friends or pay
	 *
	 */
	public class ExternalPage
	{

		/**Use to test if an String is a POPUP*/
		internal static const POPUP:String = "popup:";
		internal static const HTTP:String  = "http://";
		
		/**Use to define where the page should be open in case of redirection*/
		internal static const POSITION:String = "_top";
		
		/**Use to test if an String is an URL*/
		internal static const PF:String  = "pf_";
		
		internal static const URL:String = "_url";

		/**This Parameter get the Hostname that flash need to allow to communicate with*/
		internal static const HOSTNAME_PARAMETER:String = "pf_url";
		
		/**Event dispatcher*/
		private static var pcDispatcher:EventDispatcher = new EventDispatcher();
		
		/**The page or function the object will try to call*/
		private var psNavigateTo:String;
		
		/**Type of event on CallBack*/
		private var psEventType:String;
		
		/**
		 * Constructor
		 * @param	sNavigate
		 *			Type of navigation 
		 *		
		 * @param   aFlashvars 
		 *			The flashvars array
		 */
		public function ExternalPage(sNavigate:String, aFlashvars:Object)
		{
			psNavigateTo = aFlashvars[PF+sNavigate+URL];
			psEventType = sNavigate;
			
			ExternalInterface.addCallback("sendToActionScript", JSCallBack);
		}
		
		public static function addSecurityDomain(aFlashvars:Object):void
		{
			var iColumn:int = aFlashvars[HOSTNAME_PARAMETER].indexOf(":",HTTP.length + 1)-HTTP.length;
			var iSlash:int = aFlashvars[HOSTNAME_PARAMETER].indexOf("/",HTTP.length + 1)-HTTP.length;
			
			if(iColumn < 0 && iSlash < 0)
				iSlash = aFlashvars[HOSTNAME_PARAMETER].length - HTTP.length;
			
			var sSecurityDomain:String = aFlashvars[HOSTNAME_PARAMETER].substr(HTTP.length, (iColumn > -1 && iColumn < iSlash) ? iColumn : iSlash);
			
			trace("Security Added" + sSecurityDomain);
		    Security.allowDomain(sSecurityDomain);
		}

		/**
		 * Open function either call the page to open or the JS function to run
		 */
		public function show(... args):void
		{
			if(psNavigateTo.substr(0,POPUP.length) == POPUP)//check  for popup:*
			{
				ExternalInterface.call(psNavigateTo.substring(POPUP.length),args);	
			}
			else	
				{
					var cUrlRequest:URLRequest = new URLRequest(psNavigateTo);
					navigateToURL(cUrlRequest,POSITION);
				}
				
		}
		
		/**
		 * Open function either call the page to open or the JS function to run
		 *
		public function show():void
		{
			if(psNavigateTo.substr(0,POPUP.length) == POPUP)//check  for popup:*
			{
				ExternalInterface.call(psNavigateTo.substring(POPUP.length));	
			}
			else	
				{
					var cUrlRequest:URLRequest = new URLRequest(psNavigateTo);
					navigateToURL(cUrlRequest,POSITION);
				}
				
		}*/
		
		/**
		 * Hide a popup windows Open with the ExternalPageObject
		 *
		 */
		public function hide():void
		{
			ExternalInterface.call("hide"+psEventType+"IFrame");
		}
		
		/**
		 * Reply from JS.
		 * Dispatch an Event if this has been specify
		 * @param	aValues
		 *			Parameters return by the call to JS function
		 */
		public function JSCallBack(aValues:Array):void
		{
			if(psEventType != null)
			{
				var cExternalPage:ExternalPageEvent = new ExternalPageEvent(ExternalPageEvent.COMPLETE, aValues, psEventType);
				this.dispatchEvent(cExternalPage);
			}
		}

		/**
		 * Add a event listener to this class.
		 * 
		 * @param	sType
		 *			Event Type (JSCall.Invite) for the time
		 * @param fListener
		 * 		    Call back function
		 */
		public function addEventListener(sType:String, fListener:Function):void
		{
			pcDispatcher.addEventListener(sType, fListener);
		}
		
		/**
		 * Dispatch an event
		 * @param event
		 *			The event to dispatch
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return pcDispatcher.dispatchEvent(event);
		}
		
	}
	
}
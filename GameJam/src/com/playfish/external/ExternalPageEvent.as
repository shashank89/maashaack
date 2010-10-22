package com.playfish.external
{
	import flash.events.Event;
	import flash.system.Security;

	/**
	 * The Event class link to the JS call back.
	 *
	 */
	public class ExternalPageEvent extends Event 
	{
		/**
		 * Invite Event
		 */
		public static const COMPLETE:String = "external_page_event_complete";

		private var poData:*;
		
		private var psTypePage:String;
		
		/**
		 * Constructor
		 * @param type
		 *			Type of the event
		 * @param oData
		 *			Object containing the data response from the JS
		 */
		public function ExternalPageEvent(sType:String, oData:*, sTypePage:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(sType, bubbles, cancelable);
			poData = oData
			psTypePage= sTypePage;
		} 
		
		public override function clone():Event 
		{ 
			return new ExternalPageEvent(type, poData, psTypePage, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ExternalPageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * Return the data 
		 */
		public function get data():*
		{
			return poData;
		}
		
		/**
		 * Return the Type of call back
		 */
		public function get typePage():String
		{
			return psTypePage;
		}
	}
	
}
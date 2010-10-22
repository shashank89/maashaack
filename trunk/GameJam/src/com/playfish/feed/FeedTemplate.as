package com.playfish.feed 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class FeedTemplate 
	{
		public static var FEED_ARRAYS:Array = new Array(); 
		
		private var psId:String;
		private var psDefault:String;
		private var psFlash:String;
		private var psQuestion:String;
		private var psFlashImage:String;
		private var paFlashParameter:Map;
		
		//This Map contains all the data which need to be send for EACH FEED
		public static var feedData:Map= new Map();
		
		public function FeedTemplate() 
		{
		}
		
		public function get defaultMsg():String
		{
			return psDefault;
		}
		
		public function get id():String
		{
			return psId;
		}
		
		public function get question():String
		{
			return psQuestion;
		}
		
		public function get flash():String
		{
			return psFlash;
		}
		
		public function get flashImage():String
		{
			return psFlashImage;
		}
		
		public static function loadXML(url:String):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			var xmlData:XML = new XML();
			 
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			 
			xmlLoader.load(new URLRequest(url));
			 
			function LoadXML(e:Event):void {

			xmlData = new XML(e.target.data);
			parseFeed(xmlData);

			}
		}
		
		public static function parseFeed(xml:XML):void
		{
			var feedList:XMLList  = xml.Feed;
 
			for each (var feedXML:XML in feedList) 
			{
				trace(feedXML);
				var feedT:FeedTemplate = new FeedTemplate();
				
				feedT.psId = feedXML.@id;
				feedT.psDefault = feedXML.@response;
				feedT.psQuestion = feedXML.@question;
				feedT.psFlash = feedXML.@flash;
				feedT.psFlashImage = feedXML.@pic;
				
				
				FEED_ARRAYS[feedXML.@type] =  feedT;
				
				trace(feedXML.@id+ " "+feedXML.@pic);
			}
			
			var tokenList:XMLList  = xml.Tokens.Token;
			for each (var dataXML:XML in tokenList) 
			{
				feedData.put(dataXML.@key, dataXML.@value);
				
			}

		}

		
	}
	
}
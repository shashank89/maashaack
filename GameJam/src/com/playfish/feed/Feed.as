package com.playfish.feed 
{
	import com.playfish.external.ExternalPage;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Feed 
	{
		
		private var piFeedId:String;
		private var psQuestionMsg:String;
		private var psDefaultresponse:String;
		private var psFlashSrc:String = null;
		private var psImgSrc:Array;
		
		private var piWidth:Number;
		private var piHeight:Number;
		
		private var psSendTo:String;
		
		private var paParameters:Map;
		private var paFlashParameters:Map;
		private var psFolderPath:String;
		
		public function Feed(type:String) 
		{
			paFlashParameters = new Map();
			psImgSrc = new Array();
			
			paParameters = FeedTemplate.feedData;
			piFeedId = FeedTemplate.FEED_ARRAYS[type].id;
			psQuestionMsg = FeedTemplate.FEED_ARRAYS[type].question;
			psDefaultresponse = FeedTemplate.FEED_ARRAYS[type].defaultMsg;
			psFlashSrc = FeedTemplate.FEED_ARRAYS[type].flash;
			//FeedTemplate.FEED_ARRAYS[type].flashImage;

			var flashImg:String = FeedTemplate.FEED_ARRAYS[type].flashImage.length ;
		
			if(flashImg.length>0 && flashImg.search(".")>0)
				psImgSrc.push(FeedTemplate.FEED_ARRAYS[type].flashImage);
			else
				psFolderPath = FeedTemplate.FEED_ARRAYS[type].flashImage;
		}
		
		public function generateJSon():String
		{
			var jsString:String="{";
			
			if (psFlashSrc.length > 0)
			{
				var first:Boolean = true;
				
				for (var e:Number = 0; e < paFlashParameters.length; e++)
				{
					if (first)
						psFlashSrc += "?";
					else
						psFlashSrc += "&";
						
					psFlashSrc += paFlashParameters.getKeyAt(e) + "=" + paFlashParameters.get(paFlashParameters.getKeyAt(e)) 
					
					first = false;
				}

				jsString += "\"flash\":{\"swfsrc\":\"" + psFlashSrc + "\",\"imgsrc\":\"" + psImgSrc + "\",\"width\":\""+piWidth+"\", \"height\":\""+piHeight+"\"}";
			}
			else if (psImgSrc.length > 0)
			{
				jsString += "\"images\":[";
				var firstPic:Boolean = true;
				
					for each(var s:String in psImgSrc) {
						
						if (!firstPic)
						   jsString += ",";
						   
						jsString += "{\"src\":\"" +s+ "\", \"href\":\"" + paParameters.get("gameLink") + "\"}";
						
						firstPic = false;
					}
				
				jsString += "]";
			}
			
			
			if (jsString.length > 2)
				jsString += ",";
			
			var bFirst:Boolean = true;
			
			for (var i:Number = 0; i < paParameters.length; i++)
			{
				if (!bFirst)
					jsString += ",";
				
					
				jsString += "\"" + paParameters.getKeyAt(i) + "\":\"" + paParameters.get(paParameters.getKeyAt(i)) + "\"";
				
				bFirst = false;
			}
			
			jsString += "}";
			
			trace("Js StringA " + jsString);
			
			return jsString;
		}
		
		public function set questionMsg(question : String) : void
		{
			this.psQuestionMsg = question;
		} 
		
		public function addImgSrc(src:String):void
		{
			this.psImgSrc.push(src);
		}
		
		public function get imgSrc():Array
		{
			return this.psImgSrc;
		}
		
		public function set height(height:Number):void
		{
			this.piHeight = height;
		}
		
		public function set width(height:Number):void
		{
			this.piWidth = height;
		}
		
		public function set defaultResponse(response:String):void
		{
				this.psDefaultresponse = response;
		}
		
		public function set sendTo(uid:String):void
		{
			this.psSendTo = uid;
		}
		
		public function get folderPath():String
		{
			return psFolderPath ;
		}
		
		public function toArray():Array 
		{
			var feedArray:Array = new Array();
			trace("piFeedId " + piFeedId + " " + psQuestionMsg + " " + " " + psDefaultresponse);
			feedArray.push(piFeedId);
			feedArray.push(psQuestionMsg);
		    feedArray.push(psDefaultresponse);
			feedArray.push(generateJSon());
			feedArray.push(this.psSendTo);
			
			return feedArray;
		}
		
		public function addParameters(key:String, value:String):void
		{
			paParameters.put(key, value);
		}
		
		public function addFlashParameters(key:String, value:String):void
		{
			paFlashParameters.put(key, value);
		}

	}
	
}
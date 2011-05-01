package com.ggshily.game.util
{
	public class XmlUtil
	{
		public function XmlUtil()
		{
		}
		
		public static function getAttributeAsString(xml : XML, attribute : String, defaultValue : String = null, recursive : Boolean = false) : String
		{
			var xmlList : XMLList = recursive ? recursiveAttribute(xml, attribute) : xml.attribute(attribute);
			return xmlList != null && xmlList.length() > 0 ? xmlList.toString() : defaultValue;
		}
		
		public static function getAttributeAsNumber(xml : XML, attribute : String, defaultValue : Number = Number.MIN_VALUE, recursive : Boolean = false) : Number
		{
			var xmlList : XMLList = recursive ? recursiveAttribute(xml, attribute) : xml.attribute(attribute);
			return xmlList != null && xmlList.length() > 0 ? Number(xmlList.toString()) : defaultValue;
		}
		
		private static function recursiveAttribute(xml : XML, attribute : String) : XMLList
		{
			var xmlList : XMLList = xml.attribute(attribute);
			if(xmlList.length() > 0)
			{
				return xmlList;
			}
			else
			{
				var parent : XML = xml.parent();
				if(parent)
				{
					return recursiveAttribute(parent, attribute);
				}
				else
				{
					return null;
				}
			}
		}
	}
}
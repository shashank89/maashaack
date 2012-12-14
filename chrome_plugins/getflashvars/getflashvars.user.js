// ==UserScript==
// @name              get flashvars
// @namespace         shily
// @description       automaticly set jira comments when resolved bug with next version number
// @include           http://apps.facebook.com/*
// @version           0.1
/* @reason
@end*/

(function() {

	var versionUrl = "http://dev-static.fishonomics.com/game/simcity/c/LIVE_VERSION";
	var versionNumber;

	function $(w){
		return document.getElementById(w.substring(1));
	};
	
	function xpath(query, context){
		return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
	};
	
	console.log("start");
	if (window.clipboardData) // IE
    {  
		console.log("set");
        window.clipboardData.setData("Text", text);
    }
		
})();
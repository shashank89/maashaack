// ==UserScript==
// @name              remove_weibo_recommed
// @namespace         weibo
// @description       remove weibo recommed
// @include           weibo.com/*
// @version           0.01

// ==/UserScript==

(function() {
	function $(w){
		return document.getElementById(w.substring(1));
	};
	
	function xpath(query, context){
		return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
	};
	
	var firstResult = xpath('//*[@node-type="feed_list_recommend"]', document).snapshotItem(0);//first result
	
	if(firstResult != null)
	{
		console.log(firstResult);
		firstResult.parentNode.removeChild(firstResult);
	}
	
})();
// ==UserScript==
// @name              Auto Jira Resolved Comment
// @namespace         shily
// @description       automaticly set jira comments when resolved bug with next version number
// @include           *.fishonomics.com/*
// @include           *.playfish.com/*
// @include           *.amazonaws.com/*
// @version           0.2
/* @reason
@end*/

(function() {

	//var versionUrl = "http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa02/c/LIVE_VERSION?" + (new Date()).toString();
	var versionUrl = "http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa00/c/LIVE_VERSION?" + (new Date()).getTime();
	var versionNumber;

	function $(w){
		return document.getElementById(w.substring(1));
	};
	
	function xpath(query, context){
		return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
	};
	
	function getNextVersion(versionTxt){
		var list = versionTxt.split("&");
		//console.log(list);
		for (i in list)
		{
			//console.log(list[i]);
			if(list[i].indexOf("version=") >= 0)
			{
				var versions = list[i].split("=")[1].split(".");
				//console.log(versions);
				
				versions[versions.length - 1] = (Number(versions[versions.length - 1]) + 1).toString();
				
				return versions.join(".");
			}
		}
		return "0.0.1";
	}
	
	function setComments(){
		var firstResult = xpath('//*[@id="workflow-transition-5-dialog"]', document).snapshotItem(0);//first result
	
		if(firstResult != null)
		{
			//console.log(firstResult);
		
			//var textfield = xpath('//*[@class="textarea long-field wiki-textfield"]', firstResult).snapshotItem(0);//first result
			var textfield = xpath('//*[@class="textarea long-field wiki-textfield mentionable"]', firstResult).snapshotItem(0);//first result
			if(textfield != null && textfield.value == "")
			{
				textfield.value = "fixed in version " + versionNumber + ", thanks!";
				//console.log("done");
			}
		}
	}
	
	GM_xmlhttpRequest({
		method: 'GET',
		url: versionUrl,
		onload: function(resp){
			versionNumber = getNextVersion(resp.responseText);
			console.log(versionNumber);
			setComments();
		}
	});
	
	
document.addEventListener("DOMNodeInserted",
	function(evt)
	{
		//console.log(evt.target);
		if(versionNumber != null)
			setComments();
	}
);
		
})();
// ==UserScript==
// @name              Jira Filters
// @namespace         shily.jirafilters
// @description       show all favorite jira filters
// @include           *.fishonomics.com/*
// @include           *.playfish.com/*
// @include           *.amazonaws.com/*
// @version           0.2
/* @reason
@end*/

(function() {

	//var versionUrl = "http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa02/c/LIVE_VERSION?" + (new Date()).toString();
	var versionUrl = "https://jira.svc.fishonomics.com/rest/api/1.0/menus/find_link?_=" + (new Date()).getTime();
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
	
	function createElement(url, title, className){
		var link = document.createElement("a");
		link.className = "lnk";
		link.href = url;
		link.textContent = title;
		
		var li = document.createElement("li");
		li.className = className;
		li.appendChild(link);
		
		return li;
	}
	
	function addFilters(resp){
		//console.log(resp);
		var result = eval('('+resp+')');
		//console.log(result);
		
		var current = result.sections[0].items[0].title;
		
		var items = result.sections[result.sections.length - 1].items;
		for(var i = 0; i < items.length; i++)
		{
			var className = "aui-dd-parent lazy";
			if(items[i].title == current)
				className = "aui-dd-parent lazy selected";
		
			document.getElementById("main-nav").appendChild(createElement(items[i].url, items[i].title, className));
		}
	}
	
	GM_xmlhttpRequest({
		method: 'GET',
		headers: {
			//"User-Agent": "Mozilla/5.0",    // If not specified, navigator.userAgent will be used.
			"Accept": "application/json, text/javascript, */*; q=0.01"            // If not specified, browser defaults will be used.
		},
		url: versionUrl,
		onload: function(resp){
			addFilters(resp.responseText);
		}
	});
	
	
// document.addEventListener("DOMNodeInserted",
	// function(evt)
	// {
		// //console.log(evt.target);
		// if(versionNumber != null)
			// setComments();
	// }
// );
		
})();
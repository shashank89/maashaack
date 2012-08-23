
console.log("start");

// if has subject
//console.log(document.getElementById(":qi"));
//console.log(document.getElementById(":qc"));
//console.log(document.getElementById(":pz"));

function xpath(query, context){
	return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
};

function nodeInsertedHandler(evt)
	{
		var element = document.getElementById(":qc");
		if(element)
		{
			console.log("intert:");
			console.log(evt.target);
			
			element.value = "change log by"; // NOTICE: the value is changed by other script later.
			console.log(element.value);
			
			document.removeEventListener("DOMNodeInserted", nodeInsertedHandler);
		}
	};

document.addEventListener("DOMNodeInserted", nodeInsertedHandler);

var t = setTimeout(function ()
	{
		var firstResult = xpath('//*[@id=":q0"]', document).snapshotItem(0);//first result
		var element = document.getElementById(":q0");
		if(firstResult)
		{
			console.log("get button");
			console.log(element);
			clearTimeout(t);
			if(document.createEvent)
			{
				var evtObj = document.createEvent('MouseEvents');
				evtObj.initEvent('click', true, false);
				element.dispatchEvent(evtObj);
				console.log(evtObj);
				console.log("send mail 1");
				
				
				var element1 = document.getElementById(":pz");
				element1.dispatchEvent(evtObj);
			}
			if(document.createEventObject)
			{
				element.fireEvent('onclick');
				console.log("send mail 2");
			}
		}
	}, 5000);

/*var path = [1, 1, 0, 0, 2,
			0, 1, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0];

var element = document.documentElement;
for(var i = 0; i < path.length; ++i)
{
	var index = path[i];
	console.log(i + " index:" + index);
	
	var children = element.childNodes;
	console.log("children" + children);
	console.log(children.length);
	
	element = children[index];
}

console.log(element);*/
//console.log(document.documentElement.children[1])

console.log("start");

function $(w){
	return document.getElementById(w.substring(1));
};

function xpath(query, context){
	return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
};

var savedId = window.localStorage.getItem('savedId');
console.log('savedId ' + savedId);

var currentId = $('#f').children[0].rows [1].cells[1].children[0].innerHTML;
console.log('currentId ' + currentId);

var newAmount = Number(currentId) - Number(savedId);

if(newAmount > 0)
{
	var message = "have new backup(s):" + newAmount + '<br>';
	for(var i = 0; i < newAmount; ++i)
	{
		message += (i + 1) + "." + $('#f').children[0].rows [1].cells[3].innerHTML + "," + $('#f').children[0].rows [1].cells[4].innerHTML + "<br>";
	}
	console.log(message);
	chrome.extension.sendRequest({msg: message}, function(response) { // optional callback - gets response
		console.log(response.returnMsg);
	});
	
	window.localStorage.setItem('savedId', currentId);
}

var queryString = window.top.location.search.substring(1);

//console.log(getParameter(queryString, 'subAction'));

if($('#f') != null && getParameter(queryString, 'subAction') == 'null')
{
	setInterval("window.location.reload()", 5000);
}


function getParameter ( queryString, parameterName ) {
// Add "=" to the parameter name (i.e. parameterName=value)
var parameterName = parameterName + "=";
if ( queryString.length > 0 ) {
// Find the beginning of the string
begin = queryString.indexOf ( parameterName );
// If the parameter name is not found, skip it, otherwise return the value
if ( begin != -1 ) {
// Add the length (integer) to the beginning
begin += parameterName.length;
// Multiple parameters are separated by the "&" sign
end = queryString.indexOf ( "&" , begin );
if ( end == -1 ) {
end = queryString.length
}
// Return the string
return unescape ( queryString.substring ( begin, end ) );
}
// Return "null" if no parameter has been found
return "null";
}
} 
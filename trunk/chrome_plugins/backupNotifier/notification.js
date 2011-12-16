
//function to get selected text from notification's querystring
function fromQString(){
	var selText = "";
	var qString = window.top.location.search.substring(1);
	
	console.log(qString);
	
	selText = getParameter(qString, "message");
	console.log(selText);
	
	//selText = qString.subStr(begin + 1);
	
	return selText;
}
//function to populate notification with selected text
function populate(){

	//console.log(document);
	var content = fromQString();
	//console.log(content);
	var target = document.getElementById("content");
	//console.log(target);
	target.innerHTML = content;
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

document.onclick = function(e){
	console.log(e);
	var URL = e.target.href;
	chrome.tabs.create({url:URL});
};

populate();
//setTimeout(populate, 1000);
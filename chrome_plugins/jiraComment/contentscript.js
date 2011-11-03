
console.log("start");

// if has subject

var versionNumber = "0.0.1";

chrome.extension.onRequest.addListener(
  function(request, sender, sendResponse) {
	versionNumber = request.versionNumber;
	console.log(versionNumber);
  });



console.log("add document event listener");
document.addEventListener("DOMNodeInserted",
	function(evt)
	{
		var commentTextarea = document.getElementsByName("comment");
		
		if(commentTextarea.length == 2 
			&& !commentTextarea[1].value
			&& getParentNode(commentTextarea[1], 9).id == "workflow-transition-5-dialog")
		{
			
			commentTextarea[1].value = "fixed in version " + versionNumber;
			
			console.log("setted");
		}
	});

var getParentNode = function(element, deep){

	for(var i = 0; i < deep; ++i)
	{
		element = element.parentNode;
	}
	
	return element;
}
		
/*var commentDiv = document.getElementById("workflow-transition-5-dialog");
console.log(commentDiv);

if(commentDiv)
{
	console.log("add event listener");
	commentdiv.addEventListener("DOMNodeInserted",
		function(evt)
		{
			console.log("Added");
		});
}*/


//console.log(document.documentElement.children[1])
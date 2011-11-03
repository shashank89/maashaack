
console.log("start");

// if has subject

var versionNumber;

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
		
		if(commentTextarea.length == 2 && !commentTextarea[1].value)
		{
			commentTextarea[1].value = "fixed in version " + versionNumber;
			
			console.log("setted");
		}
	});
		
		
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
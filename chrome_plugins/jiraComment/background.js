
chrome.extension.onRequest.addListener(
  function(request, sender, sendResponse) {
	console.log(sender.tab ?
				"from a content script:" + sender.tab.url :
				"from the extension");
	var vb = window.localStorage.getItem('versionNumber')
	sendResponse({versionNumber: vb});
  });
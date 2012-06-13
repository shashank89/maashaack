// JavaScript Document
const SERVER_URL="http://dev-"

function $(w){
	return document.getElementById(w.substring(1));
};


function getReports(callback){
	var xhr1 = new XMLHttpRequest();
	xhr1.open("GET", SERVER_URL, true);
	xhr1.onreadystatechange = function() {
	  if(xhr.readyState == 4) {
		console.log("int:" + xhr.responseText);
		
		callback(eval('(' + xhr.responseText + ')'));
	  }
	}
}

function showReports(reports){
	$('#table1').
}

window.onLoad = function(e) {
	getReports(showReports);
}
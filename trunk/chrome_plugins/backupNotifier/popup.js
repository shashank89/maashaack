const QA_VERSION_URL="http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa00/c/LIVE_VERSION?" + (new Date()).getTime();
const LIVE_QA_VERSION_URL="http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa02/c/LIVE_VERSION?" + (new Date()).getTime();
const QA01_VERSION_URL="http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa01/c/LIVE_VERSION?" + (new Date()).getTime();
const QA03_VERSION_URL="http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-qa03/c/LIVE_VERSION?" + (new Date()).getTime();
const INT_VERSION_URL="http://dev-static.fishonomics.com/game/simcity-int/c/LIVE_VERSION?" + (new Date()).getTime();
const MILESTONE_VERSION_URL="http://dev-static.playfish.com.s3.amazonaws.com/game/simcity/dev-simcity-int01/c/LIVE_VERSION?" + (new Date()).getTime();
const CB_VERSION_URL="https://d13px3umnb4fz8.cloudfront.net/game/simcity/c/LIVE_VERSION?" + (new Date()).getTime();


setVersion(QA_VERSION_URL, document.getElementById("content"), "qa00(ironfist)");

setVersion(QA01_VERSION_URL, document.getElementById("content"), "qa01(lightspeed)");

setVersion(LIVE_QA_VERSION_URL, document.getElementById("content"), "qa02(stable)");

setVersion(QA03_VERSION_URL, document.getElementById("content"), "qa03(hotfix)");
/*
var xhr = new XMLHttpRequest();
xhr.open("GET", QA_VERSION_URL, true);
xhr.onreadystatechange = function() {
  if (xhr.readyState == 4) {
    console.log("qa:" + xhr.responseText);
    document.getElementById("qa_version").innerHTML = "current qa version:" + getVersion(xhr.responseText);
  }
}
xhr.send();

var xhr1 = new XMLHttpRequest();
xhr1.open("GET", LIVE_QA_VERSION_URL, true);
xhr1.onreadystatechange = function() {
  if(xhr1.readyState == 4) {
    console.log("int:" + xhr1.responseText);
    document.getElementById("int_version").innerHTML = "current live-ops qa version:" + getVersion(xhr1.responseText);
  }
}
xhr1.send();

var xhr2 = new XMLHttpRequest();
xhr2.open("GET", MILESTONE_VERSION_URL, true);
xhr2.onreadystatechange = function() {
  if(xhr2.readyState == 4) {
    console.log("int:" + xhr2.responseText);
    document.getElementById("milestone_version").innerHTML = "current milestone version:" + getVersion(xhr2.responseText);
  }
}
xhr2.send();

var xhr3 = new XMLHttpRequest();
xhr3.open("GET", CB_VERSION_URL, true);
xhr3.onreadystatechange = function() {
  if(xhr3.readyState == 4) {
    console.log("int:" + xhr3.responseText);
    document.getElementById("cb_version").innerHTML = "current cb version:" + getVersion(xhr3.responseText);
  }
}
xhr3.send();*/

function getVersion(versionTxt){
  var list = versionTxt.split("&");
  //console.log(list);
  for (i in list)
  {
  //console.log(list[i]);
    if(list[i].indexOf("version=") >= 0)
    {
      return list[i].split("=")[1];
    }
  }
  return "0.0.0"
}

function setVersion(url, element, name){
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.onreadystatechange = function() {
	  if (xhr.readyState == 4) {
		console.log(name + ":" + xhr.responseText);
		element.innerHTML += name + ":" + getVersion(xhr.responseText) + "<br>";
	  }
	}
	xhr.send();
}

document.onclick = function(e){
	console.log(e);
	var URL = e.target.href;
	if(URL != null)
	{
		chrome.tabs.create({url:URL});
	}
};

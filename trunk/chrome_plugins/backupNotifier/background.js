
function $(w){
	return document.getElementById(w.substring(1));
};


/*chrome.extension.onRequest.addListener(
  function(request, sender, sendResponse) {

        // Create a simple text notification:
    var notify = webkitNotifications.createNotification(
      '48.png',  // icon url - can be relative
      'Hello!',  // notification title
      request.msg  // notification body text
    );

    notify.show();

    //setTimeout(function(){ notify.cancel(); },5000);
    sendResponse({returnMsg: "All good!"}); // optional response
  });*/
  
setInterval(function(){
		var xhr = new XMLHttpRequest();
		xhr.open("GET", "http://dev-simcity-qa00.fishonomics.com/SimcityQaTools/?action=autoBackup&id=0", true);
		xhr.onreadystatechange = function() {
		  if (xhr.readyState == 4) {
			//console.log(xhr.responseText);
			document.getElementById("backup").innerHTML = xhr.responseText;
			
			if($('#f') != null)
			{
				var savedId = window.localStorage.getItem('savedId');
				console.log('savedId ' + savedId);

				var currentId = savedId;
				if($('#f').children[0].rows.length > 1)
				{
					currentId = $('#f').children[0].rows [1].cells[1].children[0].innerHTML;
				}
				console.log('currentId ' + currentId);

				var newAmount = Math.min($('#f').children[0].rows.length - 1, Number(currentId) - Number(savedId));

				if(newAmount > 0)
				{
					var message = "have new backup(s):" + newAmount + '<br>';
					for(var i = 0; i < newAmount; ++i)
					{
						var row = $('#f').children[0].rows [i + 1];
						message += '<a href="http://dev-simcity-qa00.fishonomics.com/SimcityQaTools/?id=0&action=autoBackup&subAction=detail&backupId=' + row.cells[1].children[0].innerHTML + '">'
						+ (i + 1) + "." + row.cells[3].innerHTML + "," + row.cells[4].innerHTML + "</a><br>";
					}
					//console.log(message);
					
					message = "message"+ "=" + encodeURIComponent(message);
					console.log(message);
					var notify = webkitNotifications.createHTMLNotification(
						'notification.html?' + message
					);
					
					notify.ondisplay = function(){console.log(document);};
					
					notify.show();
					
					window.localStorage.setItem('savedId', currentId);
				}
			}
		  }
		}
		xhr.send();
	}, 5000);
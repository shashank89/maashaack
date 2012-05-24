chrome.extension.onRequest.addListener(
  function(request, sender, sendResponse) {

        // Create a simple text notification:
    var notify = webkitNotifications.createNotification(
      '48.png',  // icon url - can be relative
      'Hello!',  // notification title
      'have new auto backup(s) :' + request.msg  // notification body text
    );

    notify.show();

    //setTimeout(function(){ notify.cancel(); },5000);
    sendResponse({returnMsg: "All good!"}); // optional response
  });

		/*var xhr = new XMLHttpRequest();
		xhr.open("GET", "http://www.baidu.com", true);
		xhr.onreadystatechange = function() {
		  if (xhr.readyState == 4) {
			console.log(xhr.responseText);
		  }
		};
		
		
	wrequest("http://www.baidu.com", function(xhr) {
		console.log("state:" + xhr.readyState);
	  if (xhr.readyState == 4) {
		console.log(xhr.responseText);
	  }
	});
		
		*/
	
//*[@id="myorder"]/div[2]/div[2]/table/tbody
	
	wrequest("http://order.360buy.com/normal/list.action", function(xhr) {
		//console.log("state:" + xhr.readyState);
	  if (xhr.readyState == 4) {
		//console.log(xhr.responseText);
		
		html2dom(xhr.responseText, function(dom, url, xhr1){
			//console.log(dom);
			var orders = $x('.//*[@id="myorder"]/div[2]/div[2]/table/tbody/tr', dom)
			//console.log(orders);
			
			if(orders.length > 0)
			{
				for(var i = 0; i < orders.length; i++)
				{
					//console.log(i + ":" + orders[i].id);
					
					if(orders[i].id != "")
					{
						(function(){
							var orderUrl = $x(".//td[1]/a[1]", orders[i])[0].href;
							//console.log(orderUrl); //http://order.360buy.com/normal/item.action?orderid=284772793&PassKey=19DBAD5849B98C5AF3A1FB13868AD839
							wrequest(orderUrl, function(xhr2) {
								if(xhr2.readyState == 4)
								{
									//console.log(orderUrl);
									html2dom(xhr2.responseText, function(dom1, orderUrl, xhr2) {
										//console.log(dom1);
										var items = $x('.//*[@id="orderinfo"]/div[2]/dl[4]/dd/table/tbody/tr', dom1);
										//console.log(items);
										
										for(var j = 1; j < items.length; j++)
										{
											//console.log(items[j]);
											(function(){
												var itemUrl = $x(".//td[2]/div[1]/a[1]", items[j])[0].href;
												
												wrequest(itemUrl, function(xhr3) {
													if(xhr3.readyState == 4)
													{
														html2dom(xhr3.responseText, function(dom2, itemUrl, xhr3) {
															console.log(itemUrl);
															//console.log(dom2);
															var name = $x('.//*[@id="name"]', dom2);
															//console.log(name);
															
															var summary = $x('.//*[@id="summary"]', dom2);
															
															if(summary.length == 0)
															{
																summary = $x('.//*[@id="summary-english"]', dom2);
															}
															
															//console.log(summary[0]);
															
															if(summary[0] && summary[0].getAttribute("clstag") == "book|keycount|product|summary")
															{
																var isbn = $x('.//*[@id="summary"]/li[4]', dom2);
																if(isbn.length == 0)
																{
																	isbn = $x('.//*[@id="summary-english"]/li[4]', dom2);
																}
																
																console.log(isbn);
																	
																if(isbn.length > 0)
																{
																	console.log(name[0].innerText);
																	console.log(isbn[0].innerText);
																}
																else
																{
																	console.log("can not get isbn or not a book:" + itemUrl);
																}
															}
														}, itemUrl);
													}
												});
											})();
										}
										
									}, orderUrl);
								}
							});
						})();
						//var items = $x('.//*[@id="orderinfo"]/div[2]/dl[4]/dd/table/tbody/tr', 
					}
				}
			}
			
			
		}, xhr.url);
	  }
	});
		
		
function wrequest(url, cb) {
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.onreadystatechange = function(){cb(xhr);};
	xhr.send();
}
			// list nodes matching this expression, optionally relative to the node `root'
function $x( xpath, root ) {
  //console.log(xpath);
  var doc = root ? root.evaluate ? root : root.ownerDocument : document, next;
  var got = doc.evaluate( xpath, root||doc, null, 0, null ), result = [];
  //console.log(got.resultType);
  switch (got.resultType) {
    case got.STRING_TYPE:
      return got.stringValue;
    case got.NUMBER_TYPE:
      return got.numberValue;
    case got.BOOLEAN_TYPE:
      return got.booleanValue;
    default:
      while (next = got.iterateNext())
	result.push( next );
      return result;
  }
}

function $X( xpath, root ) {
  var got = $x( xpath, root );
  return got instanceof Array ? got[0] : got;
}


// Fetches url, $x slices it up, and then invokes cb(nodes, url, dom, xhr).
// If runGM is set to true and the url is on the same domain as location.href,
// the loaded document will first be processed by all GM scripts that apply. If
// div is set to true and runGM is not, the DOMization will be via a div instead
// of a frame (which munges the html, head and body tags), but saves resources.
// Note when using div: use xpath expressions starting in "./", not "/", as the
// root node is not connected. Also, the document passed to cb will be the div.
function wget$x( url, cb/*( [DOMNodes], url, dom, xhr )*/, xpath, runGM, div ) {
  wget(url, function(xml, url, xhr) {
    cb( $x( xpath, xml ), url, xml, xhr );
  }, runGM, div);
}

// Fetches url, $X slices it up, and then invokes cb(node, url, dom, xhr).
// If runGM is set to true and the url is on the same domain as location.href,
// the loaded document will first be processed by all GM scripts that apply.  If
// div is set to true and runGM is not, the DOMization will be via a div instead
// of a frame (which munges the html, head and body tags), but saves resources.
// Note when using div: use xpath expressions starting in "./", not "/", as the
// root node is not connected. Also, the document passed to cb will be the div.
function wget$X( url, cb/*( DOMNode, url, dom, xhr )*/, xpath, runGM, div ) {
  wget(url, function(xml, url, xhr) {
    cb( $X( xpath, xml ), url, xml, xhr );
  }, runGM, div);
}

// Fetches url, turns it into an HTML DOM, and then invokes cb(dom, url, xhr).
// If runGM is set to true and the url is on the same domain as location.href,
// the loaded document will first be processed by all GM scripts that apply.  If
// div is set to true and runGM is not, the DOMization will be via a div instead
// of a frame (which munges the html, head and body tags), but saves resources.
function wget( url, cb/*( dom, url, xhr )*/, runGM, div ) {
  //console.log("Loading %x", url);
  if (html2dom[url]) // cache hit?
    return html2dom(null, cb, url, null, runGM);
  var xhr = { method:'GET', url:url, onload:function( xhr ) {
    if (xhr.responseXML)
      cb( xhr.responseXML, url, xhr );
    else
      html2dom( xhr.responseText, cb, url, xhr, runGM, div );
  }};
  if (wget.xhr)
    wget.xhr(xhr);
  else
    GM_xmlhttpRequest(xhr);
}

function mayCommunicate(url1, url2) {
  function beforePath(url) {
    url = url.match(/^[^:]+:\/*[^\/]+/);
    return url && url[0].toLowerCase();
  }
  return beforePath(url1) == beforePath(url2);
}

// Well-behaved browers (Opera, maybe WebKit) could use this simple function:
// function html2dom( html, cb/*( xml, url, xhr )*/, url, xhr ) {
//   cb( (new DOMParser).parseFromString(html, "text/html"), url, xhr );
// }

// Firefox doesn't implement (new DOMParser).parseFromString(html, "text/html")
// (https://bugzilla.mozilla.org/show_bug.cgi?id=102699), so we need this hack:
function html2dom( html, cb/*( xml, url, xhr )*/, url, xhr, runGM, div ) {
  function loaded() {
    doc = cached.doc = iframe.contentDocument;
    iframe.removeEventListener("load", loaded, false);
    doc.removeEventListener("DOMContentLoaded", loaded, false);
    var callbacks = cached.onload;
    delete cached.onload;
    //console.log("DOMContentLoaded of %x: cb %x", url, callbacks);
    setTimeout(function() { // avoid racing with GM's DOMContentLoaded callback
      //console.log("Running %x callbacks", url);
      callbacks.forEach(function(cb,i) { cb( doc, url, xhr ); });
    }, 10);
  };
  function wipeJavascript(html) {
    return html.replace(/[\n\r]+/g, " "). // needed not freeze up(?!)
      replace(/<script.*?<\/script>/ig, ""). // no code execution on injection!
      replace(/<body(\s+[^="']*=("[^"]*"|'[^']*'|[^'"\s]\S*))*\s*onload=("[^"]*"|'[^']*'|[^"']\S*)/ig, "<body$1");
  };

  if (div && !runGM) {
    var parent = document.createElement("div");
    parent.innerHTML = wipeJavascript(html);
    return setTimeout(cb, 10, parent, url); // hopefully render it first
  }

  var cached = html2dom[url]; // cache of all already loaded and rendered DOM:s
  if (cached)
    if (cached.onload)
      return cached.onload.push(cb);
    else
      return cb(cached.doc, url, cached.xhr);

  var iframe = document.createElement("iframe");
  iframe.style.height = iframe.style.left = "0";
  iframe.style.width = (innerWidth - 32)+"px";
  iframe.style.visibility = "hidden";
  iframe.style.position = "absolute";
  document.body.appendChild(iframe);

  iframe.addEventListener("load", loaded, false);
  html2dom[url] = cached = { onload:[cb], xhr:xhr };
  if (runGM && mayCommunicate(url, location.href))
    return iframe.src = url; // load through GM (should be cached due to xhr)

  //console.log("May not communicate / GM scripts unwanted! (%x)", runGM);
  html = wipeJavascript(html);
  iframe.contentWindow.location.href = location.href; // for cross domain issues
  var doc = iframe.contentDocument;
  doc.open("text/html");
  doc.addEventListener("DOMContentLoaded", loaded, false);
  doc.write(html); // this may throw weird errors we can't catch or silence :-|
  doc.close();
}

html2dom.destroy = function() {
  for (var url in html2dom)
    if (html2dom.hasOwnProperty(url)) {
      var cache = html2dom[url];
      cache.doc = cache.onload = cache.xhr = null;
      delete html2dom[url];
    }
};

// functionally belongs to html2dom above (see location.href line for details)
try { // don't run this script recursively on wget() documents on other urls
  if (window.frameElement &&
      window.parent.location.href.replace(/#.*/, "") == location.href)
    throw (new Error("wget.js: Avoiding double firing on " + location.href));
} catch(e) {
  //console.error("Double fire check error: %x", e);
}

window.addEventListener("unload", html2dom.destroy, false);
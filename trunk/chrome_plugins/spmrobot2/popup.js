
		/*var xhr = new XMLHttpRequest();
		xhr.open("GET", "http://www.baidu.com", true);
		xhr.onreadystatechange = function() {
		  if (xhr.readyState == 4) {
			console.log(xhr.responseText);
		  }
		};*/
		
		document.getElementById('get_data').onclick = function(){
			document.getElementById('done').innerHTML = "正在查询...";
		
			var recps = document.getElementById('recps').value.split('\n');
			//console.log(recps);
			
			var current = 0;
			for(i = 0; i < recps.length; i++)
			{
				var newRow = document.getElementById('output_table').insertRow(-1);
				if((i + 1) % 2 == 1)
				{
					newRow.style.cssText = 'background-color:White;border-color:#F2F2F2;border-width:3px;border-style:Outset;font-size:9pt;';
				}
				else
				{
					newRow.style.cssText = 'background-color:#F2F2F2;border-color:#F2F2F2;border-width:3px;border-style:Outset;font-size:9pt;';
				}
				var newCell = newRow.insertCell(-1);
				newCell.innerHTML=recps[i];
				newRow.insertCell(-1);
				newRow.insertCell(-1);
				newRow.insertCell(-1);
				newRow.insertCell(-1);
				newRow.insertCell(-1);
				newRow.insertCell(-1);
				newRow.insertCell(-1);
					(function(){
						// 维修单追加查询
						var url = 'http://spm1.lenovo.com.cn/SV/SV_REPAIR/SV_REPAIR_SuperadditionList.aspx?REPAIRID=' + recps[i];
						var index = i;
						var row = newRow;
						var xhr = new XMLHttpRequest();
						xhr.open("GET", url, true);
						xhr.onreadystatechange = function() {
						  if (xhr.readyState == 4) {
							html2dom(xhr.responseText, function( dom, url, xhr ){
									//console.log('fenpei shijian');
									//console.log(dom.getElementById('Dg_Data'));
									if(dom.getElementById('Dg_Data').tBodies[0].rows.length > 1)
									{
										var cellIndex = 1;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[2].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[3].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[4].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[5].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[6].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[7].innerHTML;
										row.cells[cellIndex++].innerHTML = dom.getElementById('Dg_Data').tBodies[0].rows[1].cells[8].innerHTML;
									}
								},
								url, null, false, false);
								current++;
								if(current == recps.length)
								{
									document.getElementById('done').innerHTML = "查询完成";
								}
						  }
						};
						xhr.send();
						/*wget$X(url, function( DOMNode, url, dom, xhr )
						{
							// 设置分配时间
							// console.log("-----------------------");
							// console.log("url:" + url);
							// console.log(DOMNode);
							// console.log("i:" + index);
							// console.log(cell);
							cell.innerHTML = DOMNode.tBodies[0].rows[1].cells[9].innerHTML;
						}, '//*[@id="Dg_Data"]', false, false);*/
					})();
					
			}
		}
		
		
			// list nodes matching this expression, optionally relative to the node `root'
function $x( xpath, root ) {
  var doc = root ? root.evaluate ? root : root.ownerDocument : document, next;
  var got = doc.evaluate( xpath, root||doc, null, 0, null ), result = [];
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
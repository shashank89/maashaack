// ==UserScript==
// @name              Test
// @namespace         test
// @description       for test
// @require           http://js-addon.googlecode.com/files/autoupdatehelper.js
// @include           *.dangdang.com/*
// @include           *.amazon.cn/*
// @include           *.360buy.com/*
// @include           *.china-pub.com/*
// @include           *.vancl.com/*
// @include           *.newegg.com.cn/*
// @include           *.taobao.com/*
// @include           *.tmall.com/*
// @version           3.81
/* @reason
@end*/

(function() {
	function $(w){
		return document.getElementById(w.substring(1));
	};
	
	function xpath(query, context){
		return document.evaluate(context?(query.indexOf('.')==0?query:'.' + query):query, context || document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
	};
	
	function random15(){
		GM_getValue('random15', '') || GM_setValue('random15', Math.random().toString(16).slice(2,7)+Math.random().toString(16).slice(2,7)+Math.random().toString(16).slice(2,7));
		return GM_getValue('random15', '');
	};
	
	function getJDPrice(address){
		var price;
		console.log(address);
		GM_xmlhttpRequest({
			method: 'GET',
			url: address,
			onload: function(resp){
				var cont = document.createElement('div');
				console.log("resp.responseText" + resp.responseText);
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//*[@id="plist"]/ul/li[1]', cont).snapshotItem(0);//first result
				if (firstResult){
					
					// goods url
					var goodsURL = xpath('//*[@class="p-name"]/a', firstResult).snapshotItem(0).href;
					address = goodsURL;
					console.log("goodsURL" + goodsURL);
					
					GM_xmlhttpRequest({
						method: 'POST',
						url: 'http://gw.m.360buy.com/client.action?functionId=productDetail&uuid=000000000000000-'+random15()+'&clientVersion=1.0.2&client=android&osVersion=2.3.3&screen=800*480',
						data: 'body=%7B%22wareId%22%3A%22'+ goodsURL.match(/\/(\d+)\.html/)[1] +'%22%7D',
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded'
						},
						onload: function(response) {
							var rpon = eval('('+response.responseText+')');
							console.log(rpon);
							// goods price
							$('#360Price').textContent = '￥'+(rpon.productInfo.jdPrice||'[缺货]');
							
							// goods title
							$('#360Link').title  = rpon.productInfo.wname;
							
							// no store
							xpath('//a[@class="notice-store"]', firstResult).snapshotItem(0) && ($('#360Price').textContent += '[缺货]');
							
							// goods img
							// rpon.imagePaths.newpath
						}
					});
					
					// $('#360Link').title = xpath('//*[@class="p-name"]/a', firstResult).snapshotItem(0).textContent;//goods title
					
				}else{
					// if no result
					$('#360Price').textContent = '[未找到]';
				};
			}
		});
	};
	var keywords;
	
	switch (location.hostname){
		case 'product.dangdang.com':
			keywords = document.title
				.replace(/[,，].*|[【（\(][^\)）】]*[\)）】]/g, ' ')
				.replace(/['"“『][^'"”』]*['"”』]/g, ' ')
				.replace(/\s+/g, ' ')
				.replace(/^\s*|\s*$/, '');
				
			getJDPrice("http://search.360buy.com/Search?keyword=" + keywords + "&w=1");
		break;
		case 'www.360buy.com':
			keywords = document.getElementsByName('keywords')[0].content
				.match(/^[^,，]*[,，]([^,，]+)/)[1]// take the second keywords
				.replace(/[\u4E00-\u9FFF]/g, function(w){
					if(num > 9){return ' '};
					num++;
					return w;}
				)
				.replace(/\s+/g, ' ')
				.replace(/^\s*|\s*$/, '');
		break;
	};
	console.log(keywords);
	
	
})();
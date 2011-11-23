// ==UserScript==
// @name              Smarter Price
// @namespace         Book_Price
// @description       自动检测当当、卓越亚马逊、京东等网站的商品价格，把多方的价格直观显示在当前页面，方便比较！
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
1、修复获取价格失效问题
2、优化算法，提高百货商品识别率
3、改用网站Logo标识价格
4、增加识别京东进口英文原版书
5、调整卓越亚马逊价格显示位置，更方便比较价格
@end*/
// ==/UserScript==
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
	//UTF-8 to GB2312
	function UrlEncode(str) {
		var i, c, ret = "",
		strSpecial = "!\"#$%&'()*+,/:;<=>?@[\]^`{|}~%";
		for (i = 0; i < str.length; i++) {
			//alert(str.charCodeAt(i));
			c = str.charAt(i);
			if (c == " ") ret += "+";
			else if (strSpecial.indexOf(c) != -1) ret += "%" + str.charCodeAt(i).toString(16);
			if (z[str.charCodeAt(i)]　 != null) {
				d = z[str.charCodeAt(i)];
				try {
					ret += "%" + d.slice(0, 2) + "%" + d.slice( - 2);
				} catch(e) {
					// alert(" $$ error name = " + e.name + ", message = " + e.message + ", d " + i + "= " + str.charCodeAt(i))
				}
			} else ret += c;
		}
		return ret;
	};
	
	// function replace2GB(keyword ,fun){
		// GM_xmlhttpRequest({
			// method: 'GET',
			// url: 'http://www.baidu.com/s?ie=utf-8&wd=' + encodeURIComponent(keyword),
			// overrideMimeType: 'text/xml; charset=gb2312',
			// onload: function(resp){
				// if (resp.status < 200 || resp.status > 300) {
					// return;
				// };
				// fun(String(resp.responseText.match(/word=[^'"&]+['"&]/i)).replace(/word=|['"&]/ig,''));
			// },
			// onerror: function(){
				// return;
			// }
		// });
	// };

	// get isbn
	var tar, spu, beforeThis, bookLink, priceWord, imgUrl, thisPrice, thatPrice, selfName, otherName, priceBox = document.createElement('div');
		priceBox.id = 'priceBox';
	switch (location.hostname){
		case 'product.dangdang.com':
			tar = xpath('//div[@class="book_detailed"]/ul/li/span[contains(text(),"978")]').snapshotItem(0) || null;
			spu = $('#largePic');
			break;
		case 'www.amazon.cn':
			tar = xpath('//table//div[@class="content"]//li[contains(text(),"978")]').snapshotItem(0) || null;
			spu = $('#prodImageCell');
			break;
		case 'book.360buy.com':
			tar = xpath('//*[@id="summary" or @id="summary-english"]/li[contains(text(),"978")]').snapshotItem(0) || null;
			break;
		case 'www.360buy.com':
			spu = $('#spec-n1');
			break;
		case 'www.china-pub.com':
			break;
		case 'www.wl.cn':
			break;
		case 'www.99read.com':
			break;
		case 'www.bookschina.com':
			break;
	};
	var isbn = tar && tar.innerHTML.match(/978\d{10}/) || false;
	// alert(isbn);

	var img = '<img border="0" src="data:image/gif;base64,R0lGODlhEAAQALMPAHp6evf394qKiry8vJOTk83NzYKCgubm5t7e3qysrMXFxe7u7pubm7S0tKOjo////yH/C05FVFNDQVBFMi4wAwEAAAAh+QQJCAAPACwAAAAAEAAQAAAETPDJSau9NRDAgWxDYGmdZADCkQnlU7CCOA3oNgXsQG2FRhUAAoWDIU6MGeSDR0m4ghRa7JjIUXCogqQzpRxYhi2HILsOGuJxGcNuTyIAIfkECQgADwAsAAAAABAAEAAABGLwSXmMmjhLAQjSWDAYQHmAz8GVQPIESxZwggIYS0AIATYAvAdh8OIQJwRAQbJkdjAlUCA6KfU0VEmyGWgWnpNfcEAoAo6SmWtBUtCuk9gjwQKeQAeWYQAHIZICKBoKBncTEQAh+QQJCAAPACwAAAAAEAAQAAAEWvDJORejGCtQsgwDAQAGGWSHMK7jgAWq0CGj0VEDIJxPnvAU0a13eAQKrsnI81gqAZ6AUzIonA7JRwFAyAQSgCQsjCmUAIhjDEhlrQTFV+lMGLApWwUzw1jsIwAh+QQJCAAPACwAAAAAEAAQAAAETvDJSau9L4QaBgEAMWgEQh0CqALCZ0pBKhRSkYLvM7Ab/OGThoE2+QExyAdiuexhVglKwdCgqKKTGGBgBc00Np7VcVsJDpVo5ydyJt/wCAAh+QQJCAAPACwAAAAAEAAQAAAEWvDJSau9OAwCABnBtQhdCQjHlQhFWJBCOKWPLAXk8KQIkCwWBcAgMDw4Q5CkgOwohCVCYTIwdAgPolVhWSQAiN1jcLLVQrQbrBV4EcySA8l0Alo0yA8cw+9TIgAh+QQFCAAPACwAAAAAEAAQAAAEWvDJSau9WA4AyAhWMChPwXHCQRUGYARgKQBCzJxAQgXzIC2KFkc1MREoHMTAhwQ0Y5oBgkMhAAqUw8mgWGho0EcCx5DwaAUQrGXATg6zE7bwCQ2sAGZmz7dEAAA7">';

	// price box
	if (isbn){
		switch (location.hostname){
			case 'product.dangdang.com':
				beforeThis =  xpath('//p[@class="fraction"]').snapshotItem(0);
				priceBox.innerHTML = '\
					<a href="http://www.amazon.cn/s?url=search-alias%3Dstripbooks&field-keywords='+ isbn +'" id="amzLink" target="_blank" class="red" style="font-family:Arial;font-size:15px;" title="到卓越查看该书  by精明价格">\
						<img src="http://www.amazon.cn/favicon.ico" border="0" height="16px" width="16px"><span id="amzPrice">'+img+'</span></a>\
					<a href="http://search.360buy.com/Search?book=y&keyword='+ isbn +'" id="360Link" target="_blank" class="red" style="font-family:Arial;font-size:15px;" title="到京东查看该书  by精明价格">\
						<img src="http://www.360buy.com/favicon.ico" border="0" height="16px" width="16px"><span id="360Price">'+img+'</span></a>\
					<a href="#" id="cnpubLink" target="_blank" class="red" style="font-family:Arial;font-size:15px;display:none;" title="到china-pub查看该书  by精明价格">\
						<img src="http://www.china-pub.com/favicon.ico" border="0" height="16px" width="16px"><span id="cnpubPrice">'+img+'</span></a>\
					<a href="http://book.douban.com/isbn/' + isbn + '/" id="doubanRating" target="_blank" style="font-size:15px;" title="到豆瓣网查看该书  by精明价格">[豆瓣评论]</a>';
				beforeThis.parentNode.insertBefore(priceBox, beforeThis);
				break;
			case 'www.amazon.cn':
				beforeThis =   xpath('//*[@id="handleBuy"]/table[last()]/tbody/tr[2]').snapshotItem(0);
				priceBox.innerHTML = '\
					<a href="http://search.dangdang.com/search_pub.php?key='+ isbn +'" id="ddLink" target="_blank" style="color:#900;float:left;font-size:15px;" title="到当当网查看该书  by精明价格">\
						<img src="http://www.dangdang.com/favicon.ico" border="0" height="16px" width="16px"><span id="ddPrice">'+img+'</span></a>\
						<span style="float:left;font-size:15px;">&nbsp;</span>\
					<a href="http://search.360buy.com/Search?book=y&keyword='+ isbn +'" id="360Link" target="_blank" style="color:#900;float:left;font-size:15px;" title="到京东查看该书  by精明价格">\
						<img src="http://www.360buy.com/favicon.ico" border="0" height="16px" width="16px"><span id="360Price">'+img+'</span></a>\
						<span style="float:left;font-size:15px;">&nbsp;</span>\
					<a href="#" id="cnpubLink" target="_blank" style="color:#900;float:left;font-size:15px;display:none;" title="到china-pub查看该书  by精明价格">\
						<img src="http://www.china-pub.com/favicon.ico" border="0" height="16px" width="16px"><span id="cnpubPrice">'+img+'</span></a>\
						<span style="float:left;font-size:15px;">&nbsp;</span>\
					&nbsp;<a href="http://book.douban.com/isbn/' + isbn + '/" id="doubanRating" target="_blank" style="float:left;font-size:14px;" title="到豆瓣网查看该书  by精明价格">[豆瓣评论]</a>';
				beforeThis.parentNode.insertBefore(priceBox, beforeThis);
				break;
			case 'book.360buy.com':
				beforeThis = $('#pricediscount');
				priceBox.innerHTML = '<br>\
					<a href="http://www.amazon.cn/s?url=search-alias%3Dstripbooks&field-keywords='+ isbn +'" id="amzLink" target="_blank" style="color:#ec0000;" title="到卓越查看该书  by精明价格">\
						<img src="http://www.amazon.cn/favicon.ico" border="0" height="16px" width="16px"><span id="amzPrice">'+img+'</span></a>\
					<a href="http://search.dangdang.com/search_pub.php?key='+ isbn +'" id="ddLink" target="_blank" style="color:#ec0000;" title="到当当网查看该书  by精明价格">\
						<img src="http://www.dangdang.com/favicon.ico" border="0" height="16px" width="16px"><span id="ddPrice">'+img+'</span></a>\
					<a href="#" id="cnpubLink" target="_blank" style="color:#ec0000;display:none;" title="到china-pub查看该书  by精明价格">\
						<img src="http://www.china-pub.com/favicon.ico" border="0" height="16px" width="16px"><span id="cnpubPrice">'+img+'</span></a>\
					<a href="http://book.douban.com/isbn/' + isbn + '/" id="doubanRating" target="_blank" title="到豆瓣网查看该书  by精明价格">[豆瓣评论]</a>';
				beforeThis.appendChild(priceBox);
				break;
			case 'www.china-pub.com':
				break;
			case 'www.wl.cn':
				break;
			case 'www.99read.com':
				break;
		};
		

		//read amazon price
		$('#amzLink') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#amzLink').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//*[@id="result_0"]', cont).snapshotItem(0);//first result
				if (firstResult){

					//book url
					$('#amzLink').href = xpath('//a[@class="title"]', firstResult).snapshotItem(0).href;
					
					//book price
					var price = xpath('//span[@class="price"]', firstResult).snapshotItem(0);
					price
						&& ($('#amzPrice').textContent = price.textContent.replace(/\s*/g, ''))
						|| ($('#amzPrice').textContent = '[缺货]');
					
					//book status
					var status = xpath('//*[@class="fastTrack"]', firstResult).snapshotItem(0).textContent;//book status
					/现在有货/.test(status)
						|| (/通常需要(\S+)发货/.test(status) && ($('#amzPrice').textContent += '[延期'+ RegExp.$1+'发货]'))
						|| (/预售商品/.test(status) && ($('#amzPrice').textContent += '[预售]'))
						|| (/立即订购/.test(status) && ($('#amzPrice').textContent += '[订购]'))
						|| ($('#amzPrice').textContent = '[缺货]');

					//book title
					$('#amzLink').title = xpath('//a[@class="title"]', firstResult).snapshotItem(0).textContent;
					
					//book img
					// xpath('//img[@class="productImage"]', firstResult).snapshotItem(0).src

					// $('#amzLink').\u0068\u0072\u0065\u0066 = $('#amzLink').\u0068\u0072\u0065\u0066 + \u0061\u0074\u006f\u0062(['','JmluZGVzPTE1Mi00ODY3NzY0LTI3NTMxODUmc291cmNlPWR1b2h1emFpJnBhZ2VzdD00NTItOTI0ODc1Mi00ODIxNzI0'][1]);
				}else{
					// if no result
					$('#amzPrice').textContent = '[无货]';
				};
			}
		});

		
		//read dangdang price
		$('#ddLink') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#ddLink').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//div[@class="search_list public_list"]/ul[1]/li', cont).snapshotItem(0);//first result
				if (firstResult){
					
					//book url
					$('#ddLink').href = xpath('//a[@name="p_name"]', firstResult).snapshotItem(0).href;
					
					//book price
					var price = xpath('//span[@class="price_d"]', firstResult).snapshotItem(0);
					price
						&& ($('#ddPrice').textContent = price.textContent.replace(/\s*/g, ''))
						|| ($('#ddPrice').textContent = '[缺货]');
						
					//book status
					var status = xpath('//img[@alt="缺货登记"]', firstResult).snapshotItem(0);
					status && ($('#ddPrice').textContent = '[缺货]');
					
					//book title
					$('#ddLink').title = xpath('//a[@name="p_name"]', firstResult).snapshotItem(0).textContent;		

					//book img
					// xpath('//img[@class="lazy_img"]', firstResult).snapshotItem(0).src					
					
					// $('#ddLink').\u0068\u0072\u0065\u0066 = \u0061\u0074\u006f\u0062(['aHR0cDovL3VuaW9uLmRhbmdkYW5nLmNvbS90cmFuc2Zlci90cmFuc2Zlci5hc3B4P2Zyb209UC0yNjc5MDQmYmFja3VybD0=',''][0]) + $('#ddLink').\u0068\u0072\u0065\u0066;
				}else{
					// if no result
					$('#ddPrice').textContent = '[无货]';
				};
			}
		});

		
		// read 360buy price
		$('#360Link') && GM_xmlhttpRequest({
			method: 'POST',
			url: 'http://gw.m.360buy.com/client.action?functionId=search&uuid=000000000000000-'+random15()+'&clientVersion=1.0.2&client=android&osVersion=2.3.3&screen=800*480',
			data: 'body=%7B%22pagesize%22%3A%2210%22%2C%22page%22%3A%221%22%2C%22keyword%22%3A%22'+isbn+'%22%7D',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded'
			},
			onload: function(resp) {
				var firstResult = eval('('+resp.responseText+')').wareInfo[0];//first result
				if (firstResult){
					
					//book url
					$('#360Link').href = 'http://book.360buy.com/'+firstResult.wareId+'.html';
					
					//book price
					$('#360Price').textContent = '￥'+(firstResult.jdPrice||'[缺货]');
					
					//book title
					$('#360Link').title  = firstResult.wname;
					
					//book img
					// firstResult.imageurl
					
				}else{
					// if no result
					$('#360Price').textContent = '[无货]';
				};
			}
		});
		
		
		
		//read douban rating
		$('#doubanRating') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#doubanRating').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//strong[@property="v:average"]', cont).snapshotItem(0);//average number
				if (firstResult && firstResult.textContent){
					$('#doubanRating').innerHTML = '[豆瓣评分<span style="color:#ec0000;">'+ firstResult.textContent +'</span>]';
				};
			}
		});

	}else if(spu){//no ISBN, but SPU page

		var typeWord = '', keywords = '', num = 0;
		
		switch (location.hostname){
			case 'product.dangdang.com':
				keywords = document.title
					.replace(/[,，].*|[【（\(][^\)）】]*[\)）】]/g, ' ')
					.replace(/['"“『][^'"”』]*['"”』]/g, ' ')
					.replace(/\s+/g, ' ')
					.replace(/^\s*|\s*$/, '');
				
				beforeThis =  xpath('//p[@class="fraction"]').snapshotItem(0);
				priceBox.innerHTML = '\
					<a href="http://www.amazon.cn/s?url=search-alias%3Daps&field-keywords='+ keywords.replace(/(\d+G)(?!B)/gi, '$1B') +'" id="amzLink" target="_blank" class="red" style="font-family:Arial;font-size:15px;" title="到卓越查看该商品  by精明价格">\
						<img src="http://www.amazon.cn/favicon.ico"><span id="amzPrice">'+img+'</span></a>\
					<a href="http://search.360buy.com/Search?keyword='+ keywords +'&w=1" id="360Link" target="_blank" class="red" style="font-family:Arial;font-size:15px;" title="到京东查看该商品  by精明价格">\
						<img src="http://www.360buy.com/favicon.ico"><span id="360Price">'+img+'</span></a>\
					<a href="http://s.taobao.com/search?ie=utf-8&style=list&sort=sale-desc&q='+ keywords +'" id="tbLink" target="_blank" class="red" style="font-family:Arial;font-size:15px;" title="淘宝销量最高的该商品  by精明价格">\
						<img src="http://www.taobao.com/favicon.ico"><span id="tbPrice">'+img+'</span></a>';
				beforeThis.parentNode.insertBefore(priceBox, beforeThis);
				break;
				
			case 'www.amazon.cn':
				keywords = document.getElementsByName('keywords')[0].content
					.replace(/[,，].*|[【（\(][^\)）】]*[\)）】]/g, ' ')
					.replace(/[\u4E00-\u9FFF]/g, function(w){//if beyond 10 character, drop those after 10
						if(num > 9){return ' '};
						num++;
						return w;}
					)
					.replace(/\s+/g, ' ')
					.replace(/^\s*|\s*$/, '');
				var keyword = UrlEncode(keywords);
				
				beforeThis =  xpath('//*[@id="handleBuy"]/table[last()]/tbody/tr[2]').snapshotItem(0);
				priceBox.innerHTML = '\
					<a href="http://search.dangdang.com/search_mall.php?q='+ keyword +'" id="ddLink" target="_blank" style="color:#900;float:left;font-size:15px;" title="到当当网查看该商品  by精明价格">\
						<img src="http://www.dangdang.com/favicon.ico" border="0"><span id="ddPrice">'+img+'</span></a>\
						<span style="float:left;font-size:15px;">&nbsp;</span>\
					<a href="http://search.360buy.com/Search?keyword='+ keyword +'&w=1" id="360Link" target="_blank" style="color:#900;float:left;font-size:15px;" title="到京东查看该商品  by精明价格">\
						<img src="http://www.360buy.com/favicon.ico" border="0"><span id="360Price">'+img+'</span></a>\
						<span style="float:left;font-size:15px;">&nbsp;</span>\
					<a href="http://s.taobao.com/search?ie=utf-8&style=list&sort=sale-desc&q='+ keywords +'" id="tbLink" target="_blank" style="color:#900;float:left;font-size:15px;" title="淘宝销量最高的该商品  by精明价格">\
						<img src="http://www.taobao.com/favicon.ico" border="0"><span id="tbPrice">'+img+'</span></a>';
				beforeThis.parentNode.insertBefore(priceBox, beforeThis);
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
				
				beforeThis = xpath('//ul[@id="summary"]/li[2]').snapshotItem(0);
				priceBox.innerHTML = '\
					<br><a href="http://www.amazon.cn/s?url=search-alias%3Daps&field-keywords='+ keywords +'" id="amzLink" target="_blank" style="color:#ec0000;font-family:Arial;font-size:15px;" title="到卓越查看该商品  by精明价格">\
						<img src="http://www.amazon.cn/favicon.ico"><span id="amzPrice">'+img+'</span></a>\
					<a href="http://search.dangdang.com/search_mall.php?q='+ keywords +'" id="ddLink" target="_blank" style="color:#ec0000;font-family:Arial;font-size:15px;" title="到当当网查看该商品  by精明价格">\
						<img src="http://www.dangdang.com/favicon.ico"><span id="ddPrice">'+img+'</span></a>\
					<a href="http://s.taobao.com/search?ie=utf-8&style=list&sort=sale-desc&q='+ keywords +'" id="tbLink" target="_blank" style="color:#ec0000;font-family:Arial;font-size:15px;" title="淘宝销量最高的该商品  by精明价格">\
						<img src="http://www.taobao.com/favicon.ico"><span id="tbPrice">'+img+'</span></a>';
				beforeThis.appendChild(priceBox);
				break;
				
			case 'www.newegg.com.cn':
				break;
		};
		
		
		//read amazon price
		$('#amzLink') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#amzLink').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//*[@id="result_0"]', cont).snapshotItem(0);//first result
				var similarResult = xpath('//*[@id="result_0_fkmr-results0"]', cont).snapshotItem(0);//similar result
				if (firstResult){
					$('#amzLink').href = xpath('//a[@class="title"]', firstResult).snapshotItem(0).href;//goods url
					$('#amzLink').title = xpath('//a[@class="title"]', firstResult).snapshotItem(0).textContent;//goods title
					//load price
					var price = xpath('//span[@class="price"]', firstResult).snapshotItem(0);
					price
						&& ($('#amzPrice').textContent = price.textContent.replace(/\s*/g, ''))
						|| ($('#amzPrice').textContent = '[缺货]');
					var status = xpath('//*[@class="fastTrack"]', firstResult).snapshotItem(0).textContent;//goods status
					/现在有货/.test(status)
						|| (/通常需要(\S+)发货/.test(status) && ($('#amzPrice').textContent += '[延期'+ RegExp.$1+'发货]'))
						|| (/预售商品/.test(status) && ($('#amzPrice').textContent += '[预售]'))
						|| (/立即订购/.test(status) && ($('#amzPrice').textContent += '[订购]'))
						|| ($('#amzPrice').textContent = '[缺货]');
				}else if(similarResult){
					$('#amzLink').href = xpath('//a[1]', similarResult).snapshotItem(0).href;//goods url
					$('#amzLink').title = xpath('//a[1]', similarResult).snapshotItem(0).textContent;//goods title
					//load price
					var price = xpath('//div[@class="newPrice"]/span', similarResult).snapshotItem(0);
					price
						&& ($('#amzPrice').textContent =  price.textContent.replace(/\s*/g, ''))
						|| ($('#amzPrice').textContent = '[缺货]');
				}else{
					// if no result
					$('#amzPrice').textContent = '[无货]';
				};
			}
		});
		
		
		//read dangdang price
		$('#ddLink') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#ddLink').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//div[@class="search_goods_panel"]/ul[1]/li[1]', cont).snapshotItem(0);//first result
				var notMallResult = xpath('/script', cont).snapshotItem(0);//not mall result
				if (firstResult){
					$('#ddLink').href = xpath('//a[@name="b_name"]', firstResult).snapshotItem(0).href;//goods url
					$('#ddLink').title = xpath('//a[@name="b_name"]', firstResult).snapshotItem(0).textContent;//goods url
					//load price
					var price = xpath('//span[@class="price_d"]', firstResult).snapshotItem(0);
					price
						&& ($('#ddPrice').textContent =  price.textContent.replace(/\s*/g, ''))
						|| ($('#ddPrice').textContent = '[缺货]');
				}else if(notMallResult){
					GM_xmlhttpRequest({
						method: 'GET',
						url: notMallResult.innerHTML.match(/['"]([^'"]+)['"]/)[1],
						onload: function(resp){
							var cont = document.createElement('div');
							cont.innerHTML = resp.responseText;
							var firstResult = xpath('//div[@class="search_list search_list2"]/ul[1]/li[1]|//div[@class="resultlist"]/ul[1]/li[1]', cont).snapshotItem(0);//first result
							if (firstResult){
								$('#ddLink').href = xpath('//a[@name="mh_name"]|//li[@class="maintitle"]/a', firstResult).snapshotItem(0).href;//goods url
								$('#ddLink').title = xpath('//a[@name="mh_name"]|//li[@class="maintitle"]/a', firstResult).snapshotItem(0).textContent;//goods title
								// load price
								var price = xpath('//span[@class="price_d"]', firstResult).snapshotItem(0);
								price
									&& ($('#ddPrice').textContent =  price.textContent.replace(/\s*/g, ''))
									|| ($('#ddPrice').textContent = '[缺货]');
								var status = xpath('//img[@alt="缺货登记"]', firstResult).snapshotItem(0);//no store
								status && ($('#ddPrice').textContent = '[缺货]');
							}else{
								// if no result
								$('#ddPrice').textContent = '[无货]';
							};
						}
					});
				}else{
					// if no result
					$('#ddPrice').textContent = '[未找到]';
				};
			}
		});

		
		//read 360buy price
		$('#360Link') && GM_xmlhttpRequest({
			method: 'GET',
			url: $('#360Link').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//*[@id="plist"]/ul/li[1]', cont).snapshotItem(0);//first result
				if (firstResult){
					
					//goods url
					var goodsURL = xpath('//*[@class="p-name"]/a', firstResult).snapshotItem(0).href;
					$('#360Link').href = goodsURL;
					
					GM_xmlhttpRequest({
						method: 'POST',
						url: 'http://gw.m.360buy.com/client.action?functionId=productDetail&uuid=000000000000000-'+random15()+'&clientVersion=1.0.2&client=android&osVersion=2.3.3&screen=800*480',
						data: 'body=%7B%22wareId%22%3A%22'+ goodsURL.match(/\/(\d+)\.html/)[1] +'%22%7D',
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded'
						},
						onload: function(response) {
							var rpon = eval('('+response.responseText+')');
							
							//goods price
							$('#360Price').textContent = '￥'+(rpon.productInfo.jdPrice||'[缺货]');
							
							//goods title
							$('#360Link').title  = rpon.productInfo.wname;
							
							//no store
							xpath('//a[@class="notice-store"]', firstResult).snapshotItem(0) && ($('#360Price').textContent += '[缺货]');
							
							//goods img
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

		
		//read taobao price
		$('#tbLink') && GM_xmlhttpRequest({
			method: 'GET',
			// url: 'http://s.taobao.com/search?ie=utf-8&sort=sale-desc&q='+keywords,
			url: $('#tbLink').href,
			onload: function(resp){
				var cont = document.createElement('div');
				cont.innerHTML = resp.responseText;
				var firstResult = xpath('//div[@id="list-content"]/ul/li[@class="list-item"]', cont).snapshotItem(0);//first result
				if (firstResult){
					// $('#tbLink').href = xpath('//a', firstResult).snapshotItem(0).href;//goods url
					$('#tbLink').href = xpath('//a', firstResult).snapshotItem(0).href;//goods url
					// $('#tbLink').title = xpath('//a', firstResult).snapshotItem(0).textContent;//goods title
					//load price
					var price = xpath('//li[@class="price"]/em', firstResult).snapshotItem(0);
					price && ($('#tbPrice').textContent = '￥'+price.textContent.replace(/\s*/g, ''));
				}else{
					// if no result
					$('#tbPrice').textContent = '[未找到]';
				};
			}
		});

	};//
	



	/* 加总
	$('#priceBox').innerHTML += ' <a href="javascript:void(0)" id="addPrice" title="把该商品价加总" style="color:#878787">[加总]</a> <span id="priceSum" style="display:none;color:#f90">'
		+ selfName +'￥<b id="selfName"></b> '+ otherName +'￥<b id="otherName"></b> <a href="javascript:void(0)" id="toZero" style="color:#878787">[清零]</a></span>';
	$('#addPrice').addEventListener('click', countSum, false);
	$('#toZero').addEventListener('click', function(){
		setCookie('thisPrice', 0);setCookie('thatPrice', 0);
		$('#selfName').innerHTML = 0;
		$('#otherName').innerHTML = 0;
	}, false); */

	// function countSum(){
		// var p = $('#priceBox').innerHTML;
		// var r = /价：￥([^<]*)</;
		// thisPrice = r.test(p) ? parseFloat(p.match(r)[1]) : 0;
		// if (thisPrice + thatPrice){
			// $('#selfName').innerHTML = sumIt('thisPrice', thisPrice);
			// $('#otherName').innerHTML = sumIt('thatPrice', thatPrice);
			// $('#priceSum').style.display = '';
		// }
	// };

	// function sumIt(w, p){
		// var o = parseFloat(getCookie(w)) || 0, n = o + p;
		// setCookie(w, n);
		// return n.toFixed(2);
	// };

})();
})();
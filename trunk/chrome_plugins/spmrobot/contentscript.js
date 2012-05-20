
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
	
	//if(window.location.href == "http://spm1.lenovo.com.cn/SQII/QUERY_REPAIR/SV_REPAIRQuery.aspx")
	{
		
		if($("#cFrame") != null && $("#dataFrame") == null)
		{
			console.log("keywords");
			var iframe = document.createElement("iframe");
			iframe.id = "dataFrame";
			$("#cFrame").appendChild(iframe);
			$("#cFrame").cols = "190,13,*,190";
		}
		
		console.log(window.location.href);
		console.log(parent);
		if($("#GridPage1_Lbl_U_Record") != null && parent != null)
		{
			parent.document.getElementById("dataFrame").appendChild($("#Dg_Data"));
		}
	}
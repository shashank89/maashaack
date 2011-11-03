var BrowserDetect={
	init:function(){
		this.browser=this.searchString(this.dataBrowser)||"An unknown browser";
		this.version=this.searchVersion(navigator.userAgent)||this.searchVersion(navigator.appVersion)||"an unknown version";
		this.OS=this.searchString(this.dataOS)||"an unknown OS"},
	searchString:function(d){
		for(var a=0;a<d.length;a++){
			var b=d[a].string;
			var c=d[a].prop;
			this.versionSearchString=d[a].versionSearch||d[a].identity;
			if(b){
				if(b.indexOf(d[a].subString)!=-1){
					return d[a].identity
				}
			}
			else{
				if(c){
					return d[a].identity
				}
			}
		}
	},
	searchVersion:function(b){
		var a=b.indexOf(this.versionSearchString);
		if(a==-1){
			return
		}
		return parseFloat(b.substring(a+this.versionSearchString.length+1))},
	dataBrowser:[{string:navigator.userAgent,subString:"Chrome",identity:"Chrome"}
		,{string:navigator.userAgent,subString:"OmniWeb",versionSearch:"OmniWeb/",identity:"OmniWeb"}
		,{string:navigator.vendor,subString:"Apple",identity:"Safari",versionSearch:"Version"}
		,{prop:window.opera,identity:"Opera"}
		,{string:navigator.vendor,subString:"iCab",identity:"iCab"}
		,{string:navigator.vendor,subString:"KDE",identity:"Konqueror"}
		,{string:navigator.userAgent,subString:"Firefox",identity:"Firefox"}
		,{string:navigator.vendor,subString:"Camino",identity:"Camino"}
		,{string:navigator.userAgent,subString:"Netscape",identity:"Netscape"}
		,{string:navigator.userAgent,subString:"MSIE",identity:"Explorer",versionSearch:"MSIE"}
		,{string:navigator.userAgent,subString:"Gecko",identity:"Mozilla",versionSearch:"rv"}
		,{string:navigator.userAgent,subString:"Mozilla",identity:"Netscape",versionSearch:"Mozilla"}
		],
	dataOS:[{string:navigator.platform,subString:"Win",identity:"Windows"}
		,{string:navigator.platform,subString:"Mac",identity:"Mac"}
		,{string:navigator.userAgent,subString:"iPhone",identity:"iPhone/iPod"}
		,{string:navigator.platform,subString:"Linux",identity:"Linux"}
		]
}
;
BrowserDetect.init();
var browser_name="none";
switch(BrowserDetect.browser){
	case"Chrome":browser_name="Chrome";
		break;
	case"Firefox":browser_name="Firefox";
		break;
	case"Safari":browser_name="Safari";
		break;
	default:browser_name="Other";
		break
}
var boomerangInstanceRunning;
var the_date=null;
var the_conditional_date=Date();
var previous_url="http://mail.google.com/mail/?shva=1#inbox";
var inbox_url="https://mail.google.com/mail/?shva=1#inbox";
var from_priority_inbox=false;
var warned_about_non_english_language=false;
var last_date_selected=null;
var BOOMERANG_URL="https://b4g.baydin.com/";
var last_action="none";
var possible_responses=["success","success","Boomerang encountered a problem during authentication. Ask Boomerang to send this message again, and we will log you back in.","Boomerang was not able to access the Sent Mail folder. Please enable IMAP. If you are using Advanced IMAP Controls, please allow Sent Mail to be shown in IMAP.","403 Not Authenticated","Boomerang was not able to access the Drafts folder. Please enable IMAP. If you are using Advanced IMAP Controls, please allow Drafts to be shown in IMAP.","Boomerang was not able to access the Boomerang-Outbox folder. Please enable IMAP. If you are using Advanced IMAP Controls, please allow Boomerang-Outbox to be shown in IMAP.","Boomerang was not able to access the Inbox. Please enable IMAP and ensure that the Gmail interface is set to English. If you are using Advanced IMAP Controls, please allow All Mail to be shown in IMAP.","Boomerang was not able to access the All Mail folder. Please enable IMAP and ensure that the Gmail interface is set to English. If you are using Advanced IMAP Controls, please allow All Mail to be shown in IMAP.","Boomerang cannot uniquely identify this email, because there is another draft with the same subject and recipient. Please change the subject and try again.","Boomerang cannot uniquely identify this email, because there is another email in the Boomerang-Outbox with the same subject and recipient. Please change the subject and try again.","Boomerang was unable to find this Draft. Please try again. If you are still unsuccessful and you don't mind sharing this message to help improve our product, please forward to support@baydin.com","Boomerang was not able to locate this email. Please try again. If you are still unsuccessful and you don't mind sharing this email to help us improve our product, please forward it to support@baydin.com.","We're sorry! You've reached the maximum number of messages that can be delivered at the time that you specified. Please adjust your delivery time to be at least two minutes apart from your other messages and try again.","Invalid date.","There is a conflict with Gmail Labs: Authentication icon for verified senders. If you do not have this Labs enabled, please let us know at support@baydin.com.","Boomerang encountered a problem while processing this email. Please try again. If you are still unsuccessful and you don't mind sharing this email to help us improve our product, please forward it to support@baydin.com","nag_screen_1","nag_screen_2","nag_screen_3","paywall","pro","personal","basic","none","error"];
var CHROME_OVERLAY="<div class='overlay' style='background:#bcbcbc;
 opacity:0.95;
 filter:alpha(opacity=95);
'><img id='blue-arrow' style='position:fixed;
top:50px;
right:100px;
visibility:hidden;
' width='200px' height='266px' src='https://b4g.baydin.com/site_media/bookmarklet/bluegiantarrow.gif' /><div id='dialog' style='height:auto;
'><div id='title-bar'>Authenticating...</div><div class='dialog-content' style='text-align:center;
'><img src='https://b4g.baydin.com/site_media/bookmarklet/auth-loader.gif'/></div></div></div>";
var AUTH_INSTRUCTIONS="If you did not see an authentication window, please allow pop-ups for mail.google.com. <ol><li>Click this icon in the upper right corner of your browser window: <img src='https://b4g.baydin.com/site_media/bookmarklet/popupblockericon.jpg' style='padding-top:5px;
padding-bottom:5px;
'/> </li><li>Select <strong>\"Always allow popups from mail.google.com\"</strong>.</li><li><a href='javascript: window.location.reload()'>Refresh</a> the page, and try again.</li></ol>";
var CANT_ACCESS_SENT_MAIL=3;
var UNAUTHENTICATED_RESPONSE=4;
var summary_text="";
var WEEK=new Array(7);
WEEK[0]="Monday";
WEEK[1]="Tuesday";
WEEK[2]="Wednesday";
WEEK[3]="Thursday";
WEEK[4]="Friday";
WEEK[5]="Saturday";
WEEK[6]="Sunday";
function nag_screen(f){
if(browser_name!="Safari"){
if(f=="nag_screen_1"){
show_nag_dialog("<p style='margin: 15px;
'>Hey, did you know that you’ve already scheduled more than 10 messages with Boomerang this month?</p> <a href='https://b4g.baydin.com/subscriptions' class=' button green' id='signup-button' target='_blank'>Upgrade</a>",false,"Give me 1 more message!")}
else{
if(f=="nag_screen_2"){
show_nag_dialog("<p style='margin: 15px;
'>You have already scheduled beyond the 10 messages Boomerang Basic provides for free.</p>  <img src='https://b4g.baydin.com/site_media/bookmarklet/coffecup.png' style='margin-left: 125px;
'/><p style='margin: 0 15px 15px 15px;
'>For not much more than a trip to Starbucks, you can schedule an unlimited number of messages and help us keep Boomerang running.</p> <a href='https://b4g.baydin.com/subscriptions' class=' button green' id='signup-button' target='_blank'>Upgrade</a>",false,"Give me 1 more message!")}
else{
if(f=="paywall"){
show_nag_dialog("<ul style='list-style-type: none;
'><li><i>Our dinner's not steak and fondue</i></li><li><i>Instead it's ramen and stew</i></li><li><i>If our users don't buy</i></li><li><i>We'll starve and then die</i></li><li><i>So no more messages for you!</i></li></ul><p style='margin: 0 15px;
'>You’ve hit your quota of messages for this month. Boomerang Basic provides for 10, but you’ve scheduled more than 15. <span style='color:red;
'><strong>Your message was NOT scheduled.</strong></span></p><p style='margin: 5px 0 0 15px;
'>Please upgrade your subscription to get unlimited message scheduling. </p> <a href='https://b4g.baydin.com/subscriptions' class=' button green' id='signup-button' target='_blank' style='margin-left: 50px;
'>Upgrade Subscription</a>",true)}
else{
if(f.indexOf("nag_screen_referral")!=-1){
var d=f.split("-");
var a=d[1];
var e=(a&1)==0;
var c=(a&2)==0;
var b="<div id='referral_success'></div><div id='referral_dialog'><p style='margin: 15px;
'>Boomerang Basic provides 10 messages per month for free. You’ve already scheduled 15 this month.</p><p style='margin: 0 15px;
'>It costs us money to provide Boomerang to you, so to continue scheduling messages, you can either buy a subscription, or share Boomerang with your followers and earn 25 more credits as thanks.</p> <p><a href='https://b4g.baydin.com/subscriptions' class=' button green' id='signup-button' target='_blank'>Upgrade</a>";
if(c){
b+="<g:plusone callback='Plus' href='http://www.boomeranggmail.com'></g:plusone>"}
if(e){
b+="<a class='button' id='tweet-button' target='_blank' onclick='Tweet();
'>Tweet Now</a>"}
b+="</p></div>";
show_nag_dialog(b,false,"<span id='referral_confirm' style='margin:0 0 20px 30px;
'>No! Give me 1 more message anyway.</span><br/> ");
(function(){
var g=document.createElement("script");
g.type="text/javascript";
g.async=true;
g.src="https://apis.google.com/js/plusone.js";
var h=document.getElementsByTagName("script")[0];
h.parentNode.insertBefore(g,h)}
)()}
}
}
}
}
else{
if(f=="nag_screen_1"){
alert("Hey, did you know that you’ve already scheduled more than 10 messages with Boomerang this month? That's okay. We've scheduled your message anyway.")}
else{
if(f=="nag_screen_2"){
alert("You have already scheduled beyond the 10 messages Boomerang Basic provides for free. For not much more than a trip to Starbucks a month, you can schedule an unlimited number of messages and help us keep Boomerang running. We've scheduled your message anyway. ")}
else{
if(f=="nag_screen_3"){
alert("Boomerang Basic provides 10 messages per month for free. You’ve already scheduled 15 this month. It costs us money to provide Boomerang to you, so to continue scheduling messages, please upgrade your subscription from Boomerang menu at the top right of your Gmail screen. We've scheduled your message anyway.")}
else{
alert("Our dinner's not steak and fondue. Instead it's ramen and stew. If our users don't buy. We'll starve and then die. So no more messages for you! You’ve hit your quota of messages for this month. Boomerang Basic provides for 10, but you’ve scheduled more than 15. Please upgrade your subscription to Boomerang Personal or Boomerang Professional. Your message was NOT scheduled. ")}
}
}
}
}
function Tweet(){
var a="http://twitter.com/home?status="+encodeURIComponent("Been using Boomerang http://boomeranggmail.com to schedule messages in Gmail or make emails go away until I'm ready. Highly recommended.");
window.open(a);
url="https://b4g.baydin.com/mailcruncher/tweet?tweet=yes";
send_image_request(url,function(f,e,h,g){
}
,"success");
$("#referral_dialog").css("display","none");
$("#referral_success").html("<p style='margin: 15px;
'>Thanks for Tweeting! We've scheduled your message.</p><p style='margin: 15px;
'> Also, we've given you 25 more messages as thanks for sharing Boomerang with your followers.</p>");
$("#referral_confirm").text("Click here to close this window.")}
function Plus(){
url="https://b4g.baydin.com/mailcruncher/plus?plus=yes";
send_image_request(url,function(f,e,h,g){
}
,"success");
$("#referral_dialog").css("display","none");
$("#referral_success").html("<p style='margin: 15px;
'>Thanks for +1'ing! We've scheduled your message.</p><p style='margin: 15px;
'> Also, we've given you 25 more messages as thanks for sharing Boomerang with your followers.</p>");
$("#referral_confirm").text("Click here to close this window.")}
var headID=document.getElementsByTagName("head")[0];
var cssNode=document.createElement("link");
cssNode.type="text/css";
cssNode.rel="stylesheet";
cssNode.href="https://b4g.baydin.com/site_media/bookmarklet/css/style.css";
cssNode.media="screen";
headID.appendChild(cssNode);
var cssNode=document.createElement("link");
cssNode.type="text/css";
cssNode.rel="stylesheet";
cssNode.href="https://b4g.baydin.com/site_media/bookmarklet/css/jqueryui.css";
cssNode.media="screen";
headID.appendChild(cssNode);
var loc=String(document.location);
if(loc.indexOf("ContactManager")<0&&loc.indexOf("mu/mp")<0){
var newScript=document.createElement("script");
newScript.type="text/javascript";
newScript.src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js";
headID.appendChild(newScript)}
if(document.location==top.location&&loc.indexOf("mu/mp")<0){
wait_for_jquery()}
function wait_for_jquery(){
loc=String(document.location);
if(typeof jQuery=="undefined"&&loc.indexOf("ContactManager")<0){
setTimeout(wait_for_jquery,500)}
else{
var a=document.createElement("script");
a.type="text/javascript";
a.src="https://b4g.baydin.com/site_media/bookmarklet/jquery-ui-b4g.js";
headID.appendChild(a);
setTimeout(wait_for_jquery_ui,1000)}
}
function wait_for_jquery_ui(){
if(typeof jQuery.ui=="undefined"){
setTimeout(wait_for_jquery_ui,500)}
else{
setTimeout(run_b4g,1000)}
}
function run_b4g(){
if(boomerangInstanceRunning){
return}
boomerangInstanceRunning=true;
setInterval(poll_url_change,500)}
function poll_url_change(){
inject_analytics_script();
loc=String(document.location);
if(loc.indexOf("mbox")>0){
from_priority_inbox=true}
if(loc.indexOf("inbox")>0){
from_priority_inbox=false}
if(loc.indexOf("ui=2")<0){
add_management_link()}
frameDoc=get_frame();
editWindowClasses=$(".dK",frameDoc);
subjectLineClasses=$(".hP",frameDoc);
if(editWindowClasses.length>0&&(loc.indexOf("compose")>0||loc.indexOf("drafts")>0||loc.indexOf("ui=2")>0)){
add_send_later_button_to_menu();
add_send_and_boomerang_checkbox()}
if(subjectLineClasses.length>0){
if(previous_url.indexOf(loc)==-1){
add_boomerang_button_to_menu()}
add_send_later_button_to_menu();
add_send_and_boomerang_checkbox()}
}
function show_dialog(b){
if(browser_name=="Safari"){
alert(b)}
else{
framedoc=get_frame();
$(".dialogdiv").remove();
var a="<div class='dialogdiv' style='display:none;
'>"+b+"</div>";
$("body",frameDoc).append($(a));
$(".dialogdiv",frameDoc).dialog({
title:" &nbsp &nbsp   Boomerang for Gmail",modal:true,closeOnEscape:true,buttons:{
Ok:function(){
$(this).dialog("destroy")}
}
}
)}
}
function show_nag_dialog(d,c,b){
if(browser_name=="Safari"){
alert(d)}
else{
framedoc=get_frame();
$(".dialogdiv").remove();
if(b){
var a="<div class='dialogdiv' style='display:none;
'>"+d+"  <a class='closeLink' href='#'>"+b+"</a></div>"}
else{
var a="<div class='dialogdiv' style='display:none;
'>"+d+"</div>"}
$("body",frameDoc).append($(a));
if(c){
$(".dialogdiv",frameDoc).dialog({
title:" &nbsp &nbsp   Boomerang for Gmail",modal:true,buttons:{
"Ok fine!":function(){
$(this).dialog("destroy")}
}
,closeOnEscape:true,width:350}
)}
else{
$(".dialogdiv",frameDoc).dialog({
title:"&nbsp &nbsp Boomerang for Gmail",modal:true,closeOnEscape:true,width:350}
)}
$(".closeLink").click(function(){
$(".dialogdiv").dialog("close")}
)}
}
function show_welcome_dialog(a){
var b="";
var d="";
switch(a){
case 1:b="<div id='wc_screen'> <div class='wc_header'>Thank you for installing Boomerang.</div> <div class='wc_text'>Let's take you on a tour of Boomerang features inside Gmail.</div> <div class='wc_img'><div style='margin-top: 15px;
 margin-bottom: 10px;
'><span style='margin-left: 70px;
'><strong>Return messages to inbox</strong></span><span style='margin-left:130px;
'><strong>Schedule messages</strong></span></div><img class='wc_screenshot' width='511px' height='209px' style='margin-left: 70px;
' src='https://b4g.baydin.com/site_media/bookmarklet/wc_intro.png' /></div><div class='wc_pg_no'>1 of 4 <span class='startButton button red'>START</span><a class='skipButton button' href='#'>SKIP</a> </div></div>";
d="This feature is only available in the Chrome and Firefox versions of Boomerang.";
break;
case 2:b="<div id='wc_screen'> <div class='wc_header'>Boomerang</div> <div class='wc_text'>Bring a message back to your inbox when you want it.</div> <div class='wc_img'><p class='wc_img_header'>Clicking on the Boomerang button will allow you to specify the time you want the message back in your inbox.</p><div align='center'><img class='wc_screenshot' width='432px' height='106px' src='https://b4g.baydin.com/site_media/bookmarklet/wc_boomerang_button.png' /></div><br/> <a class='wc_video_link' href='http://www.youtube.com/watch?v=sXblHwvU27g' target='_blank'><img src='https://b4g.baydin.com/site_media/bookmarklet/video.png'> View a video to learn more.</a></div><div class='wc_pg_no'>2 of 4 <span class='previousButton button'>BACK</span> <span class='nextButton button green'>NEXT</span><a class='skipButton button' href='#'>SKIP</a> </div></div>";
break;
case 3:b="<div id='wc_screen'> <div class='wc_header'>Send Later</div> <div class='wc_text'>Schedule a message to be sent anytime as long as it's in the future.</div> <div class='wc_img'><p class='wc_img_header'>Write a message in Gmail like you always do and then click Send Later menu to sepcify the time you want it sent. You don’t need to do anything else, we will handle the rest.</p><div align='center'><img class='wc_screenshot' width='400px' height='160px' src='https://b4g.baydin.com/site_media/bookmarklet/wc_send_later.png' /></div><a class='wc_video_link' href='http://www.youtube.com/watch?v=1zo430u8ju0' target='_blank'><img src='https://b4g.baydin.com/site_media/bookmarklet/video.png'> View a video to learn more.</a></div><div class='wc_pg_no'>3 of 4 <span class='previousButton button'>BACK</span><span class='nextButton button green'>NEXT</span><a class='skipButton button' href='#'>SKIP</a> </div></div>";
break;
case 4:b="<div id='wc_screen'> <div class='wc_header'>Manage Scheduled Messages</div> <div class='wc_text'>View, reschedule or cancel scheduled messages all in one place.</div> <div class='wc_img'><p class='wc_img_header'>Open the Boomerang  menu on the top right of Gmail screen. and click on  the Manage scheduled messages option. There, you will be able to see the list of all scheduled messages and reschedule or cancel them if you change your mind. You can also set your preferences for Booomerang.</p><div align='center'><img class='wc_screenshot' width='573px' height='134px' src='https://b4g.baydin.com/site_media/bookmarklet/wc_manage_menu.png' /></div><br/><a class='wc_video_link' href='http://www.youtube.com/watch?v=6hpsfdSQ_Rg' target='_blank'><img src='https://b4g.baydin.com/site_media/bookmarklet/video.png'> View a video to learn more.</a></div><div class='wc_pg_no'>4 of 4</div> <span class='previousButton button last'>BACK</span><a class='skipButton button green' href='#'>FINISH</a> </div></div>";
break}
if(browser_name=="Safari"){
alert(d)}
else{
framedoc=get_frame();
$(".dialogdiv").remove();
var c="<div class='dialogdiv' style='display:none;
'>"+b+"</div>";
$("body",frameDoc).append($(c));
$(".dialogdiv",frameDoc).dialog({
modal:true,closeOnEscape:true,width:770,dialogClass:"welcomeDialog"}
);
$(".startButton").click(function(){
show_welcome_dialog(2)}
);
$(".skipButton").click(function(){
$(".dialogdiv").dialog("close")}
);
$(".nextButton").click(function(){
show_welcome_dialog(a+1)}
);
$(".previousButton").click(function(){
show_welcome_dialog(a-1)}
)}
}
function show_recurring_dialog(){
if(browser_name=="Safari"){
alert("This feature is only available in the Chrome and Firefox versions of Boomerang. Want it in Safari? Please let us know at feedback@baydin.com")}
else{
var e=get_element_by_name("to").val();
e=(e==null||e=="")?"None":strip_email_addresses(e);
var d=get_element_by_name("cc").val();
d=(d==null||d=="")?"None":strip_email_addresses(d);
var b=get_element_by_name("bcc").val();
b=(b==null||b=="")?"None":strip_email_addresses(b);
if(e=="None"&&d=="None"&&b=="None"){
show_dialog("Please enter a recipient.");
return}
framedoc=get_frame();
$(".dialogdiv").remove();
var c="<div class='dialogdiv' style='display:none;
'><div id='recurring_dialog'><div id='recurring_header'> Schedule a recurring message</div><div id='start_date_time' class='recurring_field'>Starts<span id='start_date' class='recurring_right_col'> <input id='start_date_input' type='text' name='starts'/><span id='start_time'>Send Time: <input id='start_time_input' name='time'/></span></span> </div><div  class='recurring_field'> Repeats 	<select id='frequency'  class='recurring_right_col'><option value='day'> Daily</option><option value='week' selected='selected'>Weekly</option><option value='weekday' >Every Weekday</option><option value='month' >Monthly</option><option value='year'>Yearly</option> </select>	</div><div id='num_time_interval'  class='recurring_field'> Every <span class='recurring_right_col'> <input type='number' value='1' min='1' max='12' name='num_interval' id='num_interval'/><span id='interval'> week</span></span> </div><div id='days_of_week'  class='recurring_field'> On <span class='recurring_right_col' style='vertical-align: text-bottom;
 margin-right: 4px;
'> <input class='day_cb' type='checkbox' value='6' name='Sun'  > Sun</input><input class='day_cb' type='checkbox' value='0' name='Mon'> Mon</input><input class='day_cb' type='checkbox' value='1' name='Tue'> Tue</input><input class='day_cb' type='checkbox' value='2' name='Wed'> Wed</input><input class='day_cb' type='checkbox' value='3' name='Thur'> Thur</input><input class='day_cb' type='checkbox' value='4' name='Fri'> Fri</input><input class='day_cb' type='checkbox' value='5' name='Sat'> Sat</input></span> </div><div  class='recurring_field'> <span> Ends </span><span  class='recurring_right_col' style='vertical-align: middle;
 line-height: 24px;
'><input type='radio' id='radio_num_occurences' name='end_group'  checked/> After  <input type='number' value='10' min='1' max='100' id='num_occurences' name='num_occurences'/> messages <br/><input type='radio' id='radio_end_date' name='end_group'/> On  <input id='end_date' value='' name='end_date'/> <br/><input type='radio' id='radio_no_end' name='end_group'/> No end date <br/>  </span> </div> <br/> <br/><br/><div id='summary'  class='recurring_field'> Summary: <span id='recurring_feedback'  class='recurring_right_col'> </span> </div><div class='recurring_field'><button id='schedule_recurring' class='button red'> Schedule </button><button id='cancel_recurring'>Cancel</button> </div> <br /></div>";
$("body",frameDoc).append($(c));
$(".dialogdiv",frameDoc).dialog({
modal:true,closeOnEscape:true,width:600,dialogClass:"recurringDialog"}
);
$("#start_date_input").datepicker({
showOn:"button",buttonImage:"https://b4g.baydin.com/site_media/bookmarklet/calendar.gif",buttonImageOnly:true,constrainInput:false,defaultDate:0,minDate:0,}
);
$("#end_date").datepicker({
showOn:"button",buttonImage:"https://b4g.baydin.com/site_media/bookmarklet/calendar.gif",buttonImageOnly:true,constrainInput:false,defaultDate:0,minDate:0,onClose:function(g,f){
$("#radio_end_date").attr("checked",true)}
,}
);
load_recurring_ui();
$("#schedule_recurring").click(function(){
schedule_recurring()}
);
$("#cancel_recurring").click(function(){
$(".dialogdiv").dialog("close")}
);
var a=new Date().addMinutes(10);
$("#start_date_input").val(a.toString("MM/dd/yy"));
$("#start_time_input").val(a.toString("hh:mm tt"))}
}
function move_week_days_up(a){
return a.replace("6","7").replace("5","6").replace("4","5").replace("3","4").replace("2","3").replace("1","2").replace("0","1").replace("7","0")}
function move_week_days_down(a){
return a.replace("0","7").replace("1","0").replace("2","1").replace("3","2").replace("4","3").replace("5","4").replace("6","5").replace("7","6")}
function get_frequency(){
frequency=$("#frequency").val();
switch(frequency){
case"day":frequency="DAILY";
break;
case"week":frequency="WEEKLY";
break;
case"weekday":frequency="WEEKLY";
break;
case"month":frequency="MONTHLY";
break;
case"YEARLY":frequency="YEARLY";
break;
default:frequency="YEARLY";
break}
return frequency}
function get_utc_weekday(d){
var c=$(".day_cb:checked").map(function(e,f){
return $(f).val()}
).get();
var a="";
for(var b=0;
b<c.length;
b++){
if(a==""){
a+="("+c[b]}
else{
a+=","+c[b]}
}
if(a!=""){
a+=")"}
if(d.getUTCDay()>d.getDay()||(d.getUTCDay()==0&&d.getDay()==6)){
a=move_week_days_up(a)}
else{
if(d.getUTCDay()<d.getDay()||(d.getUTCDay()==6&&d.getDay()==0)){
a=move_week_days_down(a)}
}
return a}
function update_feedback(){
clear_output();
var c="";
try{
var k=get_frequency();
var d=$("#num_interval").val();
var m=$("#start_date_input").val()+" "+$("#start_time_input").val();
var b=Date.parse(m);
var e=b.getUTCMinutes();
var h=b.getUTCHours();
var l=b.getUTCDate();
var a=b.getUTCMonth()+1;
var f=get_utc_weekday(b);
c=make_schedule_readable(k,d,e,h,l,a,f)}
catch(g){
}
$("#recurring_feedback").text(c)}
function make_schedule_readable(n,c,e,g,p,b,f){
var l=Date.UTC(new Date().getFullYear(),b-1,p,g,e);
var k=new Date(l);
var d=f;
if(k.getUTCDay()>k.getDay()||(k.getUTCDay()==0&&k.getDay()==6)){
d=move_week_days_down(f)}
else{
if(k.getUTCDay()<k.getDay()||(k.getUTCDay()==6&&k.getDay()==0)){
d=move_week_days_up(f)}
}
var h="";
var m=d.replace("(","").replace(")","");
for(var o=0;
o<WEEK.length;
o++){
m=m.replace(o.toString(),WEEK[o])}
h+=m;
if(h==""){
return""}
var a="Every ";
if(c>1){
a+=c+" "}
switch(n){
case"DAILY":a+="day";
break;
case"WEEKLY":a+="week";
break;
case"MONTHLY":a+="month";
break;
case"YEARLY":a+="year";
break}
if(c>1){
a+="s"}
a+=", ";
if(n=="WEEKLY"){
a+="on "+h+" "}
if(n=="MONTHLY"){
a+="on day "+k.getDate();
if(k.getDate()>28){
a+="(or the last day of the month)"}
a+=" "}
if(n=="YEARLY"){
a+="on "+k.toString("MMM d")+" "}
a+="at "+k.toString("hh:mm tt");
return a}
function clear_output(){
$("#recurring_feedback").text("")}
function hide_days_of_the_week(){
$("input.day_cb").each(function(){
$(this).removeAttr("checked")}
);
$("#days_of_week").css("display","none")}
function show_days_of_the_week(){
$("#days_of_week").css("display","block")}
function load_recurring_ui(){
$("#frequency").change(function(){
$("#num_interval").val(1);
if($("#frequency").val()=="week"){
show_days_of_the_week();
$("input.day_cb").attr("checked",false);
$("#interval").text(" week")}
else{
if($("#frequency").val()=="weekday"){
show_days_of_the_week();
$("input.day_cb").filter("[value=0], [value=1], [value=2], [value=3], [value=4]").attr("checked",true);
$("input.day_cb").filter("[value=5], [value=6]").attr("checked",false);
$("#interval").text(" week")}
else{
hide_days_of_the_week();
$("input.day_cb").attr("checked",true);
$("#interval").text(" "+$("#frequency").val())}
}
update_feedback()}
);
$("#num_interval").change(function(){
update_feedback()}
);
$("#num_interval").click(function(){
update_feedback()}
);
$(".day_cb, #start_date, #start_time").change(function(){
update_feedback()}
);
$("#start_time").keyup(function(){
update_feedback()}
)}
function add_management_link(){
var e=get_frame();
var b=$("#manage",e);
if(b.length>0||get_gmail_user()==""){
return}
if($(".gbts",e).length>0){
var c=$(".gbtc",e).eq(1);
var g=BOOMERANG_URL+"managelogin?guser="+encodeURIComponent(get_gmail_user());
c.find("li").eq(0).before("<li class='gbt manage_menu' id='manage'> <a class='gbgt' href='#'><span class='gbtb2 manage_menu'></span><span class='gbts gbtsa manage_menu' id='top_menu_hover'><span class='manage_menu'>Boomerang</span><span class='gbma manage_menu'></span></span></a></li>");
$("#manage",e).mousedown(function(){
openTopMenu($(this))}
);
$("#top_menu_hover",e).mouseover(function(){
$(this).addClass("gbgt-hvr")}
).mouseleave(function(){
$(this).removeClass("gbgt-hvr")}
)}
else{
var h=$("#guser",e);
if(!(h.length>0&&h.get(0).firstChild)){
return}
var a=h.get(0).firstChild.firstChild;
var d=document.createElement("span");
d.setAttribute("id","manage");
var f=BOOMERANG_URL+"managelogin?guser="+encodeURIComponent(get_gmail_user());
d.innerHTML="<a target='_blank' title='Manage messages scheduled with Boomerang' class='management e' style = 'text-decoration:none;
' href='"+f+"'><img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/tinyboomlogo.png' style='margin: 1px 0px -1px 0px;
 border:none;
'/> <span style='text-decoration:underline;
'>Boomerang</span></a> | ";
a.parentNode.insertBefore(d,a)}
}
function openTopMenu(d){
track_event(["Top Menu","Open menu"]);
var b=$("#boomerang-menu",frameDoc);
if(b.length>0){
d.removeClass("gbto");
$(b).remove();
$("#manage",frameDoc).find(".gbts").css("border-bottom","none");
return}
$("#manage",frameDoc).find(".gbts").css("border-bottom","1px solid white");
var e="mail";
try{
var h=get_gmail_user()[0];
var k=h.substring(h.indexOf("@")+1,h.length);
if(k!="gmail.com"&&k!="googlemail.com"){
e="a/"+k}
}
catch(c){
}
d.addClass("gbto");
var g=document.createElement("div");
var a=BOOMERANG_URL+"managelogin?guser="+encodeURIComponent(get_gmail_user());
g.setAttribute("class","gbm manage_menu");
g.setAttribute("id","boomerang-menu");
var f=BOOMERANG_URL+"managelogin?guser="+encodeURIComponent(get_gmail_user());
g.innerHTML="<div class='gbmc'><ol class='gbmcc'> <li id='tmmanage' class='gbkc gbmtc '> <a href='"+a+"' class='gbmt top_menu_option' target='_blank' href='"+f+"'>Manage scheduled messages</a></li><li id='tmbuy' class='gbkc gbmtc'> <a href='http://boomeranggmail.com/subscriptions.html' class='gbmt top_menu_option' target='_blank'>Buy a subscription</a></li><li id='tmfaq' class='gbkc gbmtc'> <a href='http://boomeranggmail.com/faq.html' class='gbmt top_menu_option' target='_blank'>Help</a></li><li id='tmhowto' class='gbkc gbmtc'> <span class='gbmt top_menu_option' target='_blank'>How To</span></li><li if='tmfriend' class='gbkc gbmtc'><a href='https://mail.google.com/"+e+"/?view=cm&ui=2&tf=0&fs=1&su="+encodeURIComponent("Have you tried Boomerang for Gmail?")+"&body="+encodeURIComponent("I am using Boomerang for Gmail to schedule outgoing emails, remind myself about important messages, and track if I am getting responses. I really like it, and I think you might like it too. It is free to try, so check it out at http://www.boomeranggmail.com. ")+"' class='gbmt top_menu_option' target='_blank'>Tell a friend</a></li></ol></div>";
$("#manage",frameDoc).after($(g));
g.setAttribute("style","visibility: visible;
 width: 260px;
 left: 0px;
 top:30px;
 border-top-width: none;
");
$(".top_menu_option",frameDoc).mouseover(function(){
$(this).addClass("gbmt-hvr")}
).mouseleave(function(){
$(this).removeClass("gbmt-hvr")}
);
$("#tmmanage",frameDoc).click(function(l){
track_event(["Top Menu","Click manage scheduled messages"])}
);
$("#tmfaq",frameDoc).click(function(l){
track_event(["Top Menu","Click help"])}
);
$("#tmhowto",frameDoc).click(function(l){
display_welcome_screen();
track_event(["Top Menu","Click How To"])}
);
$("#tmfriend",frameDoc).click(function(l){
track_event(["Top Menu","Click tell a friend"])}
);
$(frameDoc).click(function(m){
var l=get_target(m);
if($(l).parents().andSelf().filter("#manage").length==0){
$("#manage",frameDoc).removeClass("gbto");
$(g).remove();
$("#manage",frameDoc).find(".gbts").css("border-bottom","none");
$(frameDoc).unbind("click")}
}
)}
function display_welcome_screen(){
show_welcome_dialog(1)}
function add_boomerang_button_to_menu(){
frameDoc=get_frame();
var f=$(".boomerang-button",frameDoc);
if(f.length>0){
return}
var h=$(".ii",frameDoc);
if(h.length<1){
return}
var e=document.createElement("div");
e.className="Pl J-J5-Ji boomerang-button";
e.innerHTML="<div aria-haspopup='true' style='-moz-user-select:none;
margin-bottom:0px;
margin-top:-2px;
' role='button' class='J-Zh-I J-J5-Ji Bq L3' tabindex='0'><img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/tinyboomlogo.png' /> Boomerang <img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/arrow.png' style='vertical-align: middle;
' /></div>";
var o=null;
var l=$(".iH > div",frameDoc);
for(i=0;
i<l.length;
i++){
o=e.cloneNode(true);
o.addEventListener("click",function(p){
toggle_boomerang_menu(p,{
owner:this,delegate:b4g_time_clicked,label:"Return Conversation to Inbox: "}
)}
,false);
l.get(i).appendChild(o)}
var a=grab_inbox_conversation_text();
a=remove_forwarded_quotes(a);
var g=voodoo(a,new Date(),6);
if(g.length>0&&g[0]>new Date()&&g[0]<new Date().addMonths(9)){
var n=extractTime(a)!=null;
var c="";
var b=new Date(g[0]);
if(n){
c="2 hours before";
b=b.addHours(-2)}
else{
c="1 day before";
b=b.addDays(-1)}
if(b>new Date()){
var m=" <img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/tinyboomlogo.png' style='margin: 1px 0px -1px 0px;
 vertical-align: middle;
'/> Boomerang this? ";
var k=g[0];
m+="<select style='padding: 1px  0;
line-height: 12px;
' name='magicChoice' id='magicChoice' >";
m+="<option value='the week before'>the week before</option><option value='the day before'>the day before</option><option value='the morning of'>the morning of</option><option value='2 hours before'>2 hours before</option><option value='the afternoon of'>the afternoon of</option><option value='the day after'>the day after</option><option value='the week after'>the week after</option></select>";
m+="<strong> "+k.toString("MMM d, yyyy")+" "+k.toString("h:mmtt")+"</strong>. ";
m+="<input type='submit' id='confirmMagic' value='Confirm'/>";
var d=$(".nH .if > .nH > .nH > .dJ",frameDoc);
d.attr("style","height: 25px;
 padding-top: 5px;
 margin-bottom: 5px;
 text-align:center;
");
d.html("<span class='vh boomerang' style='font-weight: normal !important;
 background-color: #FFC;
 padding: 5px 5px 5px 5px;
 font-size: 80%;
 color: rgb(42, 93, 176);
'>"+m+"</span> ");
if(n){
$("#magicChoice option[value='2 hours before']",frameDoc).attr("selected","selected")}
else{
$("#magicChoice option[value='the day before']",frameDoc).attr("selected","selected")}
$("#confirmMagic",frameDoc).click(function(){
var s=$("#magicChoice",frameDoc).val();
var q=6;
var p="";
switch(s){
case"the week before":p=new Date(k).clearTime().addDays(-7).addHours(q);
break;
case"the day before":p=new Date(k).clearTime().addDays(-1).addHours(q);
break;
case"the morning of":p=new Date(k).clearTime().addHours(q);
break;
case"2 hours before":p=new Date(k).addHours(-2);
break;
case"the afternoon of":p=new Date(k).clearTime().addHours(12);
break;
case"the day after":p=new Date(k).clearTime().addDays(1).addHours(q);
break;
case"the week after":p=new Date(k).clearTime().addDays(7).addHours(q);
break;
default:p=new Date(k).addHours(-2)}
b4g_time_clicked(p)}
)}
}
}
function add_send_later_button_to_menu(){
frameDoc=get_frame();
var c=$("#send-later-button",frameDoc);
var a=$(".dX",frameDoc);
if(c.length>0||a.length<1){
return false}
var b=document.createElement("div");
b.setAttribute("id","send-later-button");
b.setAttribute("style","position: inherit;
");
b.className="Pl J-J5-Ji";
b.innerHTML="<div aria-haspopup='true' style='-moz-user-select: none;
' class='J-Zh-I J-J5-Ji Bq L3' tabindex='0'><img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/tinyboomlogo.png' /> Send Later <img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/arrow.png' style='vertical-align: middle;
' /></div>";
var d=null;
for(i=0;
i<a.length;
i++){
d=b.cloneNode(true);
d.addEventListener("click",function(f){
toggle_boomerang_menu(f,{
owner:this,delegate:send_later,label:"Send Message:"}
)}
,false);
var e=a.get(i).firstChild.nextSibling;
e.parentNode.insertBefore(d,e)}
return a.length>0}
function add_send_and_boomerang_checkbox(){
frameDoc=get_frame();
var a=$("#boomerangSendWidget",frameDoc);
if(a.length>0){
return false}
the_conditional_date=Date.today().addDays(2).addHours(7).addMinutes(Math.floor(Math.random()*30)-15);
lastrow=$(".ee",frameDoc);
a="<tr><td class='eD'>&nbsp;
</td><td><div id='boomerangSendWidget'><form style='font-size:12px;
 float:left;
'><input type='checkbox' id='boomerangSendCheck' value='boomSend' style='float:left;
 margin: 4px 3px 0 0;
' /><label for='boomerangSendCheck'><span class='dT'> Boomerang this message </span></label><select style='padding: 2px  0;
' name='ifResponse' id='boomerangSendCondition' ><option value='conditional'>if I don't hear back</option><option value='always'>even if someone replies</option></select><div id='boomerangSendDelay' style='float:right;
'></div></form></div></td></tr>";
lastrow.before(a);
var f=document.createElement("div");
f.setAttribute("id","sendboomerang-button");
f.className="Pl J-J5-Ji";
f.innerHTML="<div id='conditional-caption' aria-haspopup='true' style='-moz-user-select:none;
 padding: 3px 3px;
 margin-left: 5px;
 font-size: 100%;
' role='button' class='J-Zh-I J-J5-Ji Bq L3' tabindex='0'> in 2 days <img class='f' src='https://b4g.baydin.com/site_media/bookmarklet/arrow.png' style='vertical-align: middle;
' /></div>";
var e=null;
e=f.cloneNode(true);
e.addEventListener("click",function(g){
toggle_send_boomerang_menu(g,{
owner:this,delegate:send_boomerang_menu_clicked,label:""}
)}
,false);
$("#boomerangSendDelay",frameDoc).append($(e));
$("#boomerangSendCheck",frameDoc).click(function(){
if($("#boomerangSendCheck",frameDoc).is(":checked")){
track_event(["Send and Boomerang","Toggle option","Check",1])}
else{
track_event(["Send and Boomerang","Toggle option","Uncheck",-1])}
}
);
$("#boomerangSendCondition",frameDoc).change(function(){
$("input#boomerangSendCheck",frameDoc).attr("checked",true);
check_authentication();
track_event(["Send and Boomerang","Change 'if i don't hear back' field"])}
);
var d=$(".dX",frameDoc);
for(i=0;
i<d.length;
i++){
var c=d.get(i).firstChild;
c.addEventListener("click",function(k){
var h=$("#boomerangSendCheck",frameDoc).attr("checked");
if(h){
var g=build_send_and_boomerang_url();
send_image_request(g,handle_send_b4g_response,"success")}
}
,false);
if(c.innerText!="Send"){
var b=null;
for(j in d.get(i).children){
if(d.get(i).children[j].innerText=="Send"){
b=d.get(i).children[j]}
}
if(b==null&&c.innerText.indexOf(" ")>0){
b=d.get(i).children[2]}
b.addEventListener("click",function(k){
var h=$("#boomerangSendCheck",frameDoc).attr("checked");
if(h){
var g=build_send_and_boomerang_url();
send_image_request(g,handle_send_b4g_response,"success")}
}
,false)}
}
$("#boomerangSendCheck",frameDoc).click(function(){
check_authentication()}
);
return d.length>0}
function check_authentication(){
if($("#boomerangSendCheck",frameDoc).attr("checked")){
$("#boomerangSendCheck",frameDoc).attr("checked",false);
var b=get_gmail_user();
var a="https://b4g.baydin.com/mailcruncher/checklogin?guser="+b;
send_image_request(a,handle_auth_response,a,"success")}
}
function build_send_and_boomerang_url(){
frameDoc=get_frame();
var c=get_gmail_user();
subjectLineClasses=frameDoc.getElementsByClassName("hP");
if(subjectLineClasses.length>0){
subjectLineChildren=subjectLineClasses[0].childNodes;
g="";
for(i=0;
i<subjectLineChildren.length;
i++){
val=subjectLineChildren[i].nodeValue;
if(val!=null){
g=g+val}
}
senderClasses=frameDoc.getElementsByClassName("gD");
var m=new Array();
var l=new Array();
for(i=0;
i<senderClasses.length;
i++){
senderEmail=senderClasses[i].getAttribute("email");
if(senderEmail==null&&senderClasses[i].childNodes.length>0){
senderEmail=senderClasses[i].firstChild.getAttribute("email")}
timeClasses=frameDoc.getElementsByClassName("g3");
timeStamp=timeClasses[i].getAttribute("alt");
newTimeStamp=timeStamp.replace(" at","");
emailDate=Date.parse(newTimeStamp);
m.push(senderEmail);
l.push(emailDate.valueOf())}
}
else{
var g=get_element_by_name("subject").val();
var m=new Array();
var l=new Array();
var h=get_element_by_name("from");
if(h.length>0){
h=strip_email_addresses(h.val());
m.push(h)}
else{
h=c;
m=h}
}
var k=get_element_by_name("to").val();
k=(k==null||k=="")?"None":strip_email_addresses(k);
var d=get_element_by_name("cc").val();
d=(d==null||d=="")?"None":strip_email_addresses(d);
var e=get_element_by_name("bcc").val();
e=(e==null||e=="")?"None":strip_email_addresses(e);
url="https://b4g.baydin.com/mailcruncher/schedulereturndelay";
url=url+"?subject="+encodeURIComponent(g);
url=url+"&senders="+encodeURIComponent(JSON.stringify(m));
url=url+"&guser="+encodeURIComponent(c);
url=url+"&sentDates="+encodeURIComponent(JSON.stringify(l));
url=url+"&threadId="+encodeURIComponent(get_thread_id());
var b=$("#boomerangSendCondition",frameDoc).val();
var a=the_conditional_date;
var f;
switch(b){
case"conditional":f="True";
break;
case"always":f="False";
break;
default:f="False"}
url=url+"&offset="+encodeURIComponent(a.valueOf());
url=url+"&conditional="+encodeURIComponent(f);
if(get_element_by_name("^i").length>0){
url=url+"&inbox=True"}
else{
url=url+"&inbox=False"}
url+="&to="+encodeURIComponent(k);
url+="&cc="+encodeURIComponent(d);
url+="&bcc="+encodeURIComponent(e);
return url}
function toggle_boomerang_menu(q,v){
var k=v.label=="Send Message:";
var u=get_target(q);
if(u.className.indexOf("J-Zh-I")==-1&&u.className!="f"){
return}
var w=get_frame();
var a=null;
if(typeof(v.owner)=="undefined"){
a=this}
else{
a=v.owner}
var n=w.getElementById("b4g_menu");
if(n){
if(n.parentNode==a){
$("div",a).removeClass("J-Zh-I-JO");
$("div",a).removeClass("J-Zh-I-Kq");
a.removeChild(n);
$(".ui-datepicker").css("display","none")}
}
else{
if(!warned_about_non_english_language){
var h=$(".mj",w);
if(h.length>0&&h.get(0).textContent.indexOf("You are")==-1&&h.get(0).textContent.indexOf("Using")==-1){
show_dialog("Warning: Boomerang for GMail may not work in non-English clients");
warned_about_non_english_language=true}
$(w).unbind("click")}
$("div",a).addClass("J-Zh-I-JO");
$("div",a).addClass("J-Zh-I-Kq");
if(k){
track_event(["Send Later","Open menu"])}
else{
track_event(["Boomerang","Open menu"])}
var n=document.createElement("ul");
n.setAttribute("id","b4g_menu");
n.setAttribute("class","b4g_menu SK AX AW");
n.setAttribute("style","position:absolute;
margin-top:-1px;
margin-left:-1px;
z-index:999;
list-style:none;
width:16em;
");
if(k){
n.innerHTML="<li class='menu-caption' style='list-style-type:none;
margin-left:0;
padding: 2px 2.5px 2px 6px;
color:gray;
 padding-bottom:5px;
'>"+v.label+"</li>"}
else{
n.innerHTML="<li class='menu-caption' style='list-style-type:none;
margin-left:0;
padding: 2px 2.5px 2px 6px;
color:gray;
 padding-bottom:5px;
'>"+v.label+"<img class='b4g_menu' id='notes_toggle' src='https://b4g.baydin.com/site_media/bookmarklet/notes_off.png' style='cursor:pointer;
' title='Click to enter a note for this message'/></li>"}
var d;
if(!k){
d=document.createElement("div");
$(d).append("<h3 class='b4g_menu'>Enter your note below.</h3><textarea cols='30' rows='15' id='note_entry' class='b4g_menu' style='border: 1px solid #999;
'>Some text</textarea><div class='b4g_menu'>This note will come back with your message.<br/></div><button class='b4g_menu' id='notes_save_button' style='margin: 15px 20px 0 90px;
'>Save</button><span class='b4g_menu' id='notes_cancel_button' style='text-decoration:underline;
 cursor:pointer;
 color:#15C'>Cancel</span>");
d.setAttribute("class","b4g_menu SK AX AW");
d.setAttribute("id","notes_menu");
d.setAttribute("style","display:none;
 position:absolute;
 height: 300px;
 left:2px");
n.appendChild(d);
d=document.createElement("div");
var o=document.createElement("input");
o.setAttribute("style","margin: 0 3px 5px 3px;
 border-bottom:1px solid #dcdcdc;
");
o.type="checkbox";
o.name="condBoomerang";
o.id="conditionalBoomerang";
o.value=false;
o.setAttribute("class","b4g_menu");
d.appendChild(o);
$(d).append("Only if nobody responds");
d.setAttribute("class","b4g_menu");
n.appendChild(d);
n.appendChild(d)}
n.appendChild(build_b4g_menu_item("In 1 hour",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 2 hours",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 4 hours",v.delegate,null,null,true,k));
n.appendChild(build_b4g_menu_item("Tomorrow morning",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("Tomorrow afternoon",v.delegate,null,null,true,k));
n.appendChild(build_b4g_menu_item("In 2 days",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 4 days",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 1 week",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 2 weeks",v.delegate,null,null,false,k));
n.appendChild(build_b4g_menu_item("In 1 month",v.delegate,null,null,true,k));
var l=document.createElement("li");
l.setAttribute("class","menu-caption");
l.innerHTML="At a specific time";
l.setAttribute("style","margin-left:3px");
n.appendChild(l);
d=document.createElement("li");
d.setAttribute("style","color: #333;
 font-style: italic;
 font-weight: bold;
 font-size: 0.8em;
 margin-top: 3px;
 margin-left: 3px;
");
d.setAttribute("class","b4g_menu");
d.innerHTML="Examples: 'Monday 9am', 'Dec 23'<br/>";
n.appendChild(d);
var m=document.createElement("form");
m.setAttribute("onsubmit","return false;
");
d=document.createElement("div");
d.setAttribute("style","padding-top:3px;
 vertical-align: middle;
");
d.setAttribute("class","b4g_menu");
if(last_date_selected==null||last_date_selected<new Date()){
the_date=Date.today().addDays(2).addHours(8)}
else{
the_date=last_date_selected}
var f=the_date.toString("M/d/yyyy h:mm tt");
var g=document.createElement("input");
g.setAttribute("style","margin-left: 3px");
g.setAttribute("class","b4g_menu");
g.type="text";
g.name="time";
g.id="datepicker";
g.value=f;
g.addEventListener("keyup",update_date_preview,false);
g.addEventListener("focus",update_date_preview,false);
d.appendChild(g);
m.appendChild(d);
d=document.createElement("div");
d.setAttribute("style","color:#969696;
 margin-left: 3px;
");
d.innerHTML="<span id='date-preview' class='b4g_menu' style='color:#327a01;
'></span>";
m.appendChild(d);
d=document.createElement("div");
var b=document.createElement("input");
b.type="submit";
b.value="Confirm";
b.setAttribute("style","margin: 3px 0 5px 3px;
");
b.setAttribute("class","b4g_menu");
b.addEventListener("click",function(x){
if(k){
track_event(["Send Later","At a specific time"]);
specific_time_chosen(x,send_later)}
else{
track_event(["Boomerang","At a specific time"]);
specific_time_chosen(x,b4g_time_clicked)}
}
,false);
d.appendChild(b);
m.appendChild(d);
n.appendChild(m);
customTimes=load_three_most_frequent_dates();
for(idx in customTimes){
if(k){
callback=send_later}
else{
callback=b4g_time_clicked}
d=build_custom_b4g_menu_item(customTimes[idx],callback,k,false);
n.appendChild(d)}
d.setAttribute("style","border-bottom: 1px solid #dcdcdc;
 padding-bottom:5px;
 margin-bottom:5px;
");
d.setAttribute("class","b4g_menu");
function c(){
random_time_open(this,n)}
function p(){
random_time_close(this,n)}
var s=document.createElement("li");
s.innerHTML="<a id='random-time' style='color:inherit;
padding: 2px 2.5px 2px 6px;
cursor:pointer;
display:block;
margin-bottom:5px;
' class='menu-anchor'><img src='https://b4g.baydin.com/site_media/bookmarklet/tree-plus.png'></img>&nbsp;
Random time</a>";
$(s.firstChild).hover(function(){
$(this).addClass("J-N-JT")}
,function(){
$(this).removeClass("J-N-JT")}
);
$(s).toggle(c,p);
n.appendChild(s);
n.appendChild(build_b4g_menu_item("- By 5pm today",v.delegate,"random","display:none",false,k));
n.appendChild(build_b4g_menu_item("- Within 1 week",v.delegate,"random","display:none",false,k));
n.appendChild(build_b4g_menu_item("- Within 1 month",v.delegate,"random","display:none",true,k));
a.appendChild(n);
if(k){
var t=document.createElement("li");
t.innerHTML="<a id='recurring' style='color:inherit;
padding: 2px 2.5px 2px 6px;
cursor:pointer;
display:block;
margin-bottom:5px;
' class='menu-anchor'>Schedule recurring message</a>";
n.appendChild(t);
$(t).click(function(){
send_image_request("https://b4g.baydin.com/mailcruncher/checkaccountstatus?guser="+encodeURIComponent(get_gmail_user()),show_recurring_callback,"")}
);
$(t).hover(function(){
$(this).addClass("J-N-JT")}
,function(){
$(this).removeClass("J-N-JT")}
)}
$("#conditionalBoomerang",w).click(function(){
if($("#conditionalBoomerang",w).is(":checked")){
track_event(["Conditional Boomerang","Toggle","Check",1])}
else{
track_event(["Conditional Boomerang","Toggle","Uncheck",-1])}
}
);
$(w).bind("click",function(z){
var x=w.getElementById("b4g_menu");
var y=get_target(z);
if(y.className.indexOf("J-Zh-I J-J5-Ji Bq L3 J-Zh-I-JO J-Zh-I-Kq")==-1&&y.className!="f"&&y.className.indexOf("menu-anchor")==-1&&y.className.indexOf("b4g_menu")==-1&&y.className.indexOf("menu-caption")==-1){
if(x!=null&&x.parentNode==a){
$("div",a).removeClass("J-Zh-I-JO");
$("div",a).removeClass("J-Zh-I-Kq");
a.removeChild(x)}
$(w).unbind("click");
$(".ui-datepicker").css("display","none")}
else{
}
}
);
$("#datepicker",w).datepicker({
showOn:"button",buttonImage:"https://b4g.baydin.com/site_media/bookmarklet/calendar.gif",buttonImageOnly:true,constrainInput:false,minDate:0,beforeShow:function(){
track_event([(k?"Send Later":"Boomerang"),"Click calendar icon"])}
,onClose:function(x,e){
g.focus()}
}
);
$(".ui-datepicker-trigger",w).css("margin-left","5px");
$(".ui-datepicker-trigger",w).css("vertical-align","middle");
$(g,w).mousedown(function(e){
e.stopImmediatePropagation()}
);
$(g,w).css("-moz-user-select","text");
if(k){
$(g,w).parents().each(function(){
$(this).css("-moz-user-select","text")}
)}
g.focus();
g.select();
$("span#date-preview.b4g_menu",w).text("");
if(!k){
$("#note_entry",w).val("");
$("#notes_toggle",w).click(function(){
send_image_request("https://b4g.baydin.com/mailcruncher/checkaccountstatus?guser="+encodeURIComponent(get_gmail_user()),notes_callback,"")}
);
$("#notes_save_button",w).click(function(){
$("#notes_menu",w).toggle();
if($("#note_entry",w).val()!=""){
$("#notes_toggle",w).attr("src","https://b4g.baydin.com/site_media/bookmarklet/notes_on.png")}
}
);
$("#notes_cancel_button",w).click(function(){
$("#notes_menu",w).toggle();
$("#note_entry",w).val("");
$("#notes_toggle",w).attr("src","https://b4g.baydin.com/site_media/bookmarklet/notes_off.png")}
)}
}
}
function show_recurring_callback(c,d,a,b){
if(d=="pro"){
show_recurring_dialog()}
else{
show_dialog("A pro subscription is required to use this feature.")}
}
function notes_callback(c,d,a,b){
if(d!="basic"){
$("#notes_menu",frameDoc).toggle();
$("#note_entry",frameDoc).focus()}
else{
show_dialog("A personal or pro subscription is required to use this feature.")}
}
function toggle_send_boomerang_menu(l,g){
var m=get_target(l);
if(m.className.indexOf("J-Zh-I")==-1&&m.className!="f"){
return}
var f=get_frame();
var b=null;
if(typeof(g.owner)=="undefined"){
b=this}
else{
b=g.owner}
var n=f.getElementById("b4g_menu");
if(n){
if(n.parentNode==b){
$("div",b).removeClass("J-Zh-I-JO");
$("div",b).removeClass("J-Zh-I-Kq");
b.removeChild(n)}
}
else{
track_event(["Send and Boomerang","Open menu"]);
if(!warned_about_non_english_language){
var c=$(".mj",f);
if(c.length>0&&c.get(0).textContent.indexOf("You are")==-1&&c.get(0).textContent.indexOf("Using")==-1){
show_dialog("Warning: Boomerang for GMail may not work in non-English clients");
warned_about_non_english_language=true}
$(f).unbind("click")}
$("div",b).addClass("J-Zh-I-JO");
$("div",b).addClass("J-Zh-I-Kq");
var n=document.createElement("ul");
n.setAttribute("id","b4g_menu");
n.setAttribute("class","b4g_menu SK AX AW");
n.setAttribute("style","position:absolute;
margin-top:-1px;
margin-left:5px;
z-index:999;
list-style:none;
width:16em;
 font-size:100%;
");
n.innerHTML="<li class='menu-caption' style='list-style-type:none;
margin-left:0;
padding: 2px 2.5px 2px 6px;
color:gray;
 padding-bottom:5px;
'>"+g.label+"</li>";
var a=document.createElement("div");
n.appendChild(build_b4g_menu_item("in 1 hour",g.delegate,null,null,false,true,true));
n.appendChild(build_b4g_menu_item("in 1 day",g.delegate,null,null,true,true,true));
n.appendChild(build_b4g_menu_item("in 2 days",g.delegate,null,null,false,true,true));
n.appendChild(build_b4g_menu_item("in 4 days",g.delegate,null,null,false,true,true));
n.appendChild(build_b4g_menu_item("in 1 week",g.delegate,null,null,false,true,true));
n.appendChild(build_b4g_menu_item("in 2 weeks",g.delegate,null,null,false,true,true));
n.appendChild(build_b4g_menu_item("in 1 month",g.delegate,null,null,true,true,true));
var k=document.createElement("li");
k.setAttribute("class","menu-caption");
k.innerHTML="By a specific time";
k.setAttribute("style","margin-left:3px");
n.appendChild(k);
a=document.createElement("li");
a.setAttribute("style","color: #333;
 font-style: italic;
 font-size: 0.8em;
 margin-top: 3px;
 margin-left: 3px;
");
a.setAttribute("class","b4g_menu");
a.innerHTML="Examples: <strong>'Monday 9am'</strong>, <strong>'Dec 23'</strong><br/>";
n.appendChild(a);
var p=document.createElement("form");
p.setAttribute("onsubmit","return false;
");
a=document.createElement("div");
a.setAttribute("style","padding-top:3px;
 vertical-align: middle;
");
a.setAttribute("class","b4g_menu");
if(last_date_selected==null||last_date_selected<new Date()){
the_date=Date.today().addDays(2).addHours(8)}
else{
the_date=last_date_selected}
var o=the_date.toString("M/d/yyyy h:mm tt");
var d=document.createElement("input");
d.setAttribute("style","margin-left: 3px");
d.setAttribute("class","b4g_menu");
d.type="text";
d.name="time";
d.id="datepicker";
d.value=o;
d.addEventListener("keyup",update_date_preview,false);
d.addEventListener("focus",update_date_preview,false);
a.appendChild(d);
p.appendChild(a);
a=document.createElement("div");
a.setAttribute("style","color:#969696;
 margin-left: 3px;
");
a.innerHTML="<span id='date-preview' class='b4g_menu' style='color:#327a01;
'></span>";
p.appendChild(a);
a=document.createElement("div");
var h=document.createElement("input");
h.type="submit";
h.value="Confirm";
h.setAttribute("style","margin: 3px 0 5px 3px;
");
h.setAttribute("class","b4g_menu");
h.addEventListener("click",function(q){
track_event(["Send and Boomerang","At a specific time"]);
var s=Date.parse(the_date);
if(s!=null){
send_boomerang_specific_time_clicked(s)}
else{
show_dialog("Unable to read specified time. Please try again.")}
}
,false);
a.appendChild(h);
a.setAttribute("class","b4g_menu");
p.appendChild(a);
n.appendChild(p);
b.appendChild(n);
$(f).bind("click",function(t){
var q=f.getElementById("b4g_menu");
var s=get_target(t);
if(s.className.indexOf("J-Zh-I J-J5-Ji Bq L3 J-Zh-I-JO J-Zh-I-Kq")==-1&&s.className!="f"&&s.className.indexOf("menu-anchor")==-1&&s.className.indexOf("b4g_menu")==-1&&s.className.indexOf("menu-caption")==-1){
if(q!=null&&q.parentNode==b){
$("div",b).removeClass("J-Zh-I-JO");
$("div",b).removeClass("J-Zh-I-Kq");
b.removeChild(q)}
$(f).unbind("click");
$(".ui-datepicker").css("display","none")}
else{
}
}
);
$("#datepicker",f).datepicker({
showOn:"button",buttonImage:"https://b4g.baydin.com/site_media/bookmarklet/calendar.gif",buttonImageOnly:true,constrainInput:false,minDate:0,beforeShow:function(){
track_event(["Send and Boomerang","Click calendar icon"])}
,onClose:function(q,e){
d.focus()}
}
);
$(".ui-datepicker-trigger",f).css("margin-left","5px");
$(".ui-datepicker-trigger",f).css("vertical-align","middle");
d.focus();
d.select();
$("span#date-preview.b4g_menu",f).text("")}
}
function build_b4g_menu_item(f,g,e,m,c,k,d){
var b=document.createElement("li");
if(m!=null){
b.setAttribute("style",m)}
if(e!=null){
b.className=e}
var h=document.createElement("a");
if(!d){
h.href="#"}
h.innerHTML=f;
h.setAttribute("style","text-decoration:none;
color:inherit;
line-height:1.1em;
padding: 2px 2.5px 2px 6px;
display:block;
cursor:pointer;
");
$(h).hover(function(){
$(this).addClass("J-N-JT")}
,function(){
$(this).removeClass("J-N-JT")}
);
h.className="menu-anchor J-N";
if(c){
$(h).css("border-bottom","1px solid #dcdcdc");
$(h).css("padding-bottom","5px");
$(h).css("margin-bottom","5px")}
function l(){
track_event([((d)?"Send and Boomerang":(k?"Send Later":"Boomerang")),f]);
g(f)}
b.addEventListener("click",l,false);
b.appendChild(h);
return b}
function build_custom_b4g_menu_item(f,h,e,g){
var d=document.createElement("li");
var b=document.createElement("a");
if(!g){
b.href="#"}
b.innerHTML=f;
b.setAttribute("style","text-decoration:none;
color:inherit;
line-height:1.1em;
padding: 2px 2.5px 2px 6px;
display:block;
cursor:pointer;
");
$(b).hover(function(){
$(this).addClass("J-N-JT")}
,function(){
$(this).removeClass("J-N-JT")}
);
b.className="menu-anchor J-N";
function c(){
custom_time_chosen(f,h)}
d.addEventListener("click",c,false);
d.appendChild(b);
return d}
function random_time_open(c,b){
var a=c.firstChild;
$(".random",b).show();
a.style.removeProperty("border-bottom");
a.style.removeProperty("padding-bottom");
a.style.removeProperty("margin-bottom");
a.innerHTML="<img src='https://b4g.baydin.com/site_media/bookmarklet/tree-minus.png'></img>&nbsp;
Random time"}
function random_time_close(c,b){
var a=c.firstChild;
$(".random",b).hide();
$(a).attr("style","color:inherit;
padding-left:6px;
cursor:pointer;
display:block;
border-bottom:1px solid #dcdcdc;
padding-bottom:5px;
margin-bottom:5px;
");
a.innerHTML="<img src='https://b4g.baydin.com/site_media/bookmarklet/tree-plus.png'></img>&nbsp;
Random time"}
function show_processing_notification(){
var b=frameDoc.getElementById("b4g_menu");
if(b!=null){
while(b.childNodes.length>0){
b.removeChild(b.childNodes[0])}
$(".ui-datepicker").css("display","none");
var c=document.createElement("li");
c.setAttribute("style","list-style-type:none;
text-align:center;
margin-left:0;
padding-left:2;
margin-top:5");
c.innerHTML="Processing message...";
b.appendChild(c);
c=document.createElement("li");
c.setAttribute("style","list-style-type:none;
margin-left:0;
padding-left:10;
padding-top:5px;
text-align:center;
");
c.innerHTML="<img src='https://b4g.baydin.com/site_media/bookmarklet/ajax-loader.gif' alt='Loading...'>";
b.appendChild(c)}
else{
var a=$(".nH .if > .nH > .nH > .dJ",frameDoc);
a.attr("style","height: 31px;
 list-style-type:none;
margin-left:0;
padding-left:10;
padding-top:5;
text-align:center;
");
a.html("<img src='https://b4g.baydin.com/site_media/bookmarklet/ajax-loader.gif' alt='Loading...'>")}
}
function parse_date(a){
outputDate=Date.parse(a.toLowerCase().replace("tomorrow","").replace("tom",""));
if(outputDate!=null&&outputDate<new Date()&&a.indexOf("day")!=-1&&a.indexOf("yester")==-1&&a.indexOf("today")==-1){
outputDate=outputDate.addDays(7)}
if(a.toLowerCase().indexOf("tom")!=-1){
if(outputDate==null){
outputDate=new Date()}
outputDate=outputDate.addDays(1)}
if(outputDate!=null&&outputDate<(new Date()).addDays(-1)&&outputDate>(new Date()).addYears(-1)&&a.indexOf("day")==-1&&a.indexOf("now")==-1&&!hasYear(a)){
outputDate=outputDate.addYears(1)}
return outputDate}
function update_date_preview(c){
var d=get_frame();
var a=this.value;
if(a==null){
return}
the_date=parse_date(a);
var b=make_readable(the_date,true);
if(the_date==null){
$("#date-preview",d).html("<span class='b4g_menu' style='color:#ff0000;
'>"+b+"</span>")}
else{
if(the_date<new Date()){
$("#date-preview",d).html("<span class='b4g_menu' style='color:#ff0000;
'>"+b+"</span>")}
else{
$("#date-preview",d).html("<span class='b4g_menu'>"+b+"</span>")}
}
}
function display_popup_blocker_instructions(){
try{
var b=$(".dialog-content");
b.css("text-align","left");
b.html(AUTH_INSTRUCTIONS);
$("#blue-arrow").css("visibility","visible")}
catch(a){
}
}
function hide_gmail_notification(){
$(".UD",frameDoc).css("visibility","hidden");
$(".UB",frameDoc).css("visibility","hidden");
$(".vh",frameDoc).css("visibility","hidden")}
function show_gmail_notification(){
$(".UD",frameDoc).css("visibility","visible");
$(".UB",frameDoc).css("visibility","visible");
$(".vh",frameDoc).css("visibility","visible")}
function hijack_gmail_notification(a,b){
$(".vh",frameDoc).html(a);
show_gmail_notification();
setTimeout(clear_message_style,b)}
function clear_message_style(){
$(".UD",frameDoc).attr("style","");
$(".UB",frameDoc).attr("style","");
$(".vh",frameDoc).attr("style","")}
function get_frame(){
var b=document.getElementById("canvas_frame");
var a=(b.contentWindow||b.contentDocument);
if(a.document){
a=a.document}
return a}
function get_thread_id(){
var a=String(document.location);
var b=a.substr(a.lastIndexOf("/")+1);
return b}
function get_iframe_by_class_name(b){
var a=get_frame();
var d=a.getElementsByClassName(b)[0];
var c=(d.contentWindow||d.contentDocument);
if(c.document){
c=c.document}
return c}
function get_target(a){
a=a||window.event;
return a.target||a.srcElement}
function get_element_by_name(a){
frameDoc=get_frame();
return $("*[name='"+a+"']",frameDoc).filter(":first")}
function get_last_email_date(){
var c=get_frame();
var e=c.getElementsByClassName("g3");
var a=e[e.length-1].getAttribute("alt");
var d=a.replace(" at","");
var b=Date.parse(d);
return b}
function get_gmail_user(){
var a=/[a-zA-Z0-9\._-]+@[a-zA-Z0-9\.-]+\.[a-z\.A-Z]+/;
var c="";
loadingWords=$(".msg").html();
c=a.exec(loadingWords);
if(!c){
c="";
titleWords=document.title.split(" ");
for(i in titleWords){
var b=a.exec(titleWords[i]);
if(b){
c=b}
}
}
return c}
function grab_inbox_conversation_text(){
var a=get_frame();
subjectLineClasses=a.getElementsByClassName("hP");
subjectLineChildren=subjectLineClasses[0].childNodes;
subject="";
for(i=0;
i<subjectLineChildren.length;
i++){
val=subjectLineChildren[i].nodeValue;
if(val!=null){
subject=subject+val}
}
var b=$(".ii",a);
if(b.length<1){
return""}
return subject+" "+b.get(0).firstChild.textContent}
function grab_compose_conversation_text(){
var a=get_frame();
var b=$(".Ak",a).get(0).value;
if(b==null||b==""){
return get_iframe_by_class_name("Am Al editable").body.textContent}
else{
return b}
}
function simulate_click(a){
thisButton=this;
evt=frameDoc.createEvent("MouseEvents");
evt.initMouseEvent("mousedown",true,true,window,0,0,0,0,0,false,false,false,false,0,null);
thisButton.dispatchEvent(evt);
evt=frameDoc.createEvent("MouseEvents");
evt.initMouseEvent("mouseup",true,true,window,0,0,0,0,0,false,false,false,false,0,null);
thisButton.dispatchEvent(evt)}
function archive_thread(){
frameDoc=get_frame();
buttons=$(".iH .J-Zh-I-KE",frameDoc);
archiveButtons=buttons.filter(function(a){
return $(this).text()=="Archive"}
).first();
archiveButtons.each(simulate_click)}
function back_to_previous_screen(){
frameDoc=get_frame();
buttons=$(".iH .VP5otc-tOAp0c",frameDoc);
previousButtons=buttons.filter(function(b){
return $(this).text().indexOf("Back to")!=-1}
).first();
if(previousButtons.length<1){
buttons=$(".iH .QkhFhe",frameDoc);
previousButtons=buttons.filter(function(b){
return $(this).parent().attr("title").indexOf("Back to")!=-1}
).first()}
var a=previousButtons.length>0;
previousButtons.each(simulate_click);
return a}
function redirect_and_show_gmail_notification(a){
var c=window.location.hash;
if(last_action=="return"){
archive_thread();
back_to_previous_screen()}
else{
loc=String(document.location);
if(loc.indexOf("ui=2")>0){
alert(a);
window.close();
return}
else{
if(!back_to_previous_screen()){
if(from_priority_inbox){
window.location.hash="#mbox"}
else{
window.location.hash="#inbox"}
}
}
}
hide_gmail_notification();
var b=setInterval(function(){
if(window.location.hash!=c){
hijack_gmail_notification(a,5000);
clearInterval(b)}
}
,100)}
function specific_time_chosen(a,c){
frameDoc=get_frame();
var b=Date.parse(the_date);
if(b!=null){
save_customized_date($("#datepicker",frameDoc).val());
c(b)}
else{
show_dialog("Unable to read specified time. Please try again.")}
}
function custom_time_chosen(b,a){
frameDoc=get_frame();
offset=parse_date(b);
if(offset!=null){
a(offset)}
else{
show_dialog("Something went wrong processing the customized date. Please let the Boomerang team know.")}
}
function send_boomerang_menu_clicked(a){
var b=get_frame();
var c=$("#conditional-caption",b);
the_conditional_date=caption_to_return_time(a,6);
c.text(String(a));
$(".ui-datepicker").css("display","none");
c.removeClass("J-Zh-I-JO");
c.removeClass("J-Zh-I-Kq");
$("input#boomerangSendCheck",b).attr("checked",true);
check_authentication();
$(".b4g_menu",b).remove()}
function send_boomerang_specific_time_clicked(c){
var a=get_frame();
var b=$("#conditional-caption",a);
the_conditional_date=c;
b.text("by "+c.toString("ddd, MMM d, yyyy, h:mm tt"));
$(".ui-datepicker").css("display","none");
b.removeClass("J-Zh-I-JO");
b.removeClass("J-Zh-I-Kq");
$("input#boomerangSendCheck",a).attr("checked",true);
check_authentication();
$(".b4g_menu",a).remove()}
function b4g_time_clicked(a){
frameDoc=get_frame();
subjectLineClasses=frameDoc.getElementsByClassName("hP");
subjectLineChildren=subjectLineClasses[0].childNodes;
subject="";
for(i=0;
i<subjectLineChildren.length;
i++){
val=subjectLineChildren[i].nodeValue;
if(val!=null){
subject=subject+val}
}
senderClasses=frameDoc.getElementsByClassName("gD");
gmailUser=get_gmail_user();
var e=new Array();
var d=new Array();
for(i=0;
i<senderClasses.length;
i++){
senderEmail=senderClasses[i].getAttribute("email");
if(senderEmail==null&&senderClasses[i].childNodes.length>0){
senderEmail=senderClasses[i].firstChild.getAttribute("email")}
timeClasses=frameDoc.getElementsByClassName("g3");
timeStamp=timeClasses[i].getAttribute("alt");
newTimeStamp=timeStamp.replace(" at","");
emailDate=Date.parse(newTimeStamp);
e.push(senderEmail);
d.push(emailDate.valueOf())}
offset=caption_to_return_time(a,6);
var c=make_readable(offset,false);
var b=$("#note_entry",frameDoc).val();
if(b==null){
b=""}
url="https://b4g.baydin.com/mailcruncher/schedulereturn";
url=url+"?subject="+encodeURIComponent(subject);
url=url+"&senders="+encodeURIComponent(JSON.stringify(e));
url=url+"&guser="+encodeURIComponent(gmailUser);
url=url+"&sentDates="+encodeURIComponent(JSON.stringify(d));
url=url+"&offset="+encodeURIComponent(offset.valueOf());
url=url+"&threadId="+encodeURIComponent(get_thread_id());
if($("#conditionalBoomerang",frameDoc).attr("checked")){
url=url+"&conditional="+encodeURIComponent("True")}
else{
url=url+"&conditional="+encodeURIComponent("False")}
if(get_element_by_name("^i").length>0&&loc.indexOf("label")>0){
url=url+"&inbox=True"}
else{
url=url+"&inbox=False"}
url=url+"&notes="+encodeURIComponent(b);
show_processing_notification();
last_action="return";
send_image_request(url,handle_b4g_response,"Message will return "+c+". ")}
function send_later(a){
frameDoc=get_frame();
var d=$(".J-Zh-I[role='button']",frameDoc).filter(function(){
return $(this).html()=="Save Now"}
).filter(":first");
if(d.length>0){
d.each(simulate_click);
var e=10;
var c=function(){
e--;
var f=$(".J-Zh-I[role='button']",frameDoc).filter(function(){
return $(this).html()=="Saved"}
).filter(":first");
if(f.length>0){
clearInterval(b);
send_later_helper(a)}
else{
if(e<=0&&is_loading_attachments()){
clearInterval(b);
show_dialog("Please wait for your attachments to finish uploading before sending.")}
}
}
;
var b=setInterval(c,100)}
else{
send_later_helper(a)}
}
function is_loading_attachments(){
var a=$(".dU",frameDoc);
return(a.length>0)}
function send_later_helper(u){
if(is_loading_attachments()){
show_dialog("Please wait for your attachments to upload before sending.");
return}
var h=get_gmail_user();
var e=get_element_by_name("subject").val();
if(e.length>200){
show_dialog("You've exceeded the maximum subject length. Please shorten your subject and try again.");
return}
var p=get_element_by_name("from");
if(p.length>0){
p=strip_email_addresses(p.val())}
else{
p=h}
var b=get_element_by_name("to").val();
b=(b==null||b=="")?"None":strip_email_addresses(b);
var n=get_element_by_name("cc").val();
n=(n==null||n=="")?"None":strip_email_addresses(n);
var q=get_element_by_name("bcc").val();
q=(q==null||q=="")?"None":strip_email_addresses(q);
if(b=="None"&&n=="None"&&q=="None"){
show_dialog("Please enter a recipient.");
return}
var f=b+" "+n+" "+q;
var o=/[a-zA-Z0-9\._+-]+@[a-zA-Z0-9\.-]+\.[a-z\.A-Z]+/g;
var a=f.toLowerCase().match(o);
a=eliminateDuplicates(a);
if(a.length>100){
show_dialog("Boomerang limits you to 100 recipients at a time. Please enter a shorter list.");
return}
var d=caption_to_return_time(u,9.5);
var m=make_readable(d,false);
var c=$(".d2 > span",frameDoc).html().split("(")[0];
var k=Date.parse(c);
var s=$(".h0 > b",frameDoc);
if(s.length>=2){
s=s.get(0).innerHTML+"/"+s.get(1).innerHTML}
else{
s="0/0"}
var l="None";
if($("#boomerangSendCheck",frameDoc).attr("checked")){
if(the_conditional_date<d){
show_dialog("Your Send Later message must be scheduled earlier than your Boomerang reminder.");
return}
else{
l=the_conditional_date.valueOf()}
}
var t=$("#boomerangSendCondition",frameDoc).val();
var g="";
switch(t){
case"conditional":g="True";
break;
case"always":g="False";
break;
default:g="False"}
url="https://b4g.baydin.com/mailcruncher/schedulesend";
url+="?guser="+encodeURIComponent(h);
url+="&from="+encodeURIComponent(p);
url+="&subject="+encodeURIComponent(e);
url+="&rank="+encodeURIComponent(s);
url+="&esttimesaved="+encodeURIComponent(k.valueOf());
url+="&offset="+encodeURIComponent(d.valueOf());
url+="&to="+encodeURIComponent(b);
url+="&cc="+encodeURIComponent(n);
url+="&bcc="+encodeURIComponent(q);
url+="&boomerangoffset="+encodeURIComponent(l);
url+="&boomerangconditional="+encodeURIComponent(g);
url=url+"&threadId="+encodeURIComponent(get_thread_id());
show_processing_notification();
last_action="send";
send_image_request(url,handle_b4g_response,"Message will be sent "+m+". ")}
function re_boomerang(a,b){
send_image_request(a,re_boomerang_callback,b)}
function schedule_recurring(){
frameDoc=get_frame();
var c=$(".J-Zh-I[role='button']",frameDoc).filter(function(){
return $(this).html()=="Save Now"}
).filter(":first");
if(c.length>0){
c.each(simulate_click);
var d=10;
var b=function(){
d--;
var e=$(".J-Zh-I[role='button']",frameDoc).filter(function(){
return $(this).html()=="Saved"}
).filter(":first");
if(e.length>0){
clearInterval(a);
schedule_recurring_helper()}
else{
if(d<=0&&is_loading_attachments()){
clearInterval(a);
show_dialog("Please wait for your attachments to finish uploading before sending.")}
}
}
;
var a=setInterval(b,100)}
else{
schedule_recurring_helper()}
}
function schedule_recurring_helper(){
if(is_loading_attachments()){
show_dialog("Please wait for your attachments to upload before sending.");
return}
var q;
try{
var e=$(".d2 > span",frameDoc).html().split("(")[0];
q=Date.parse(e)}
catch(l){
q=new Date()}
var p=get_gmail_user();
var m=get_element_by_name("subject").val();
if(m.length>200){
show_dialog("You've exceeded the maximum subject length. Please shorten your subject and try again.");
return}
var x=get_element_by_name("from");
if(x.length>0){
x=strip_email_addresses(x.val())}
else{
x=p}
var d=get_element_by_name("to").val();
d=(d==null||d=="")?"None":strip_email_addresses(d);
var u=get_element_by_name("cc").val();
u=(u==null||u=="")?"None":strip_email_addresses(u);
var y=get_element_by_name("bcc").val();
y=(y==null||y=="")?"None":strip_email_addresses(y);
if(d=="None"&&u=="None"&&y=="None"){
show_dialog("Please enter a recipient.");
return}
var n=d+" "+u+" "+y;
var w=/[a-zA-Z0-9\._+-]+@[a-zA-Z0-9\.-]+\.[a-z\.A-Z]+/g;
var b=n.toLowerCase().match(w);
b=eliminateDuplicates(b);
if(b.length>100){
show_dialog("Boomerang limits you to 100 recipients at a time. Please enter a shorter list.");
return}
var h=$("#start_date_input").val()+" "+$("#start_time_input").val();
var k=Date.parse(h);
if(k==null||k<new Date()){
alert("Invalid start date");
return}
var s=get_frequency();
var A=$("#num_interval").val();
var t=k.getUTCMinutes();
var B=k.getUTCHours();
var v=k.getUTCDate();
var z=k.getUTCMonth()+1;
var c=get_utc_weekday(k);
if(c==""){
alert("You must select a day of the week.");
return}
var o="None";
var g="None";
if($("#radio_num_occurences").attr("checked")){
o=$("#num_occurences").val()}
else{
if($("#radio_end_date").attr("checked")){
var a=$("#end_date").val();
a=Date.parse(a);
if(a==null){
alert("Invalid end date");
return}
g=a.valueOf()}
}
url="https://b4g.baydin.com/mailcruncher/schedulerecurring";
url+="?guser="+encodeURIComponent(p);
url+="&from="+encodeURIComponent(x);
url+="&subject="+encodeURIComponent(m);
url+="&to="+encodeURIComponent(d);
url+="&cc="+encodeURIComponent(u);
url+="&bcc="+encodeURIComponent(y);
url+="&esttimesaved="+encodeURIComponent(q.valueOf());
url+="&frequency="+encodeURIComponent(s);
url+="&interval="+encodeURIComponent(A);
url+="&utc_weekday="+encodeURIComponent(c);
url+="&start="+encodeURIComponent(k.valueOf());
url+="&end="+encodeURIComponent(g);
url+="&num_occurences="+encodeURIComponent(o);
url+="&threadId="+encodeURIComponent(get_thread_id());
show_processing_notification();
last_action="send";
var f=$("#recurring_feedback").text();
send_image_request(url,handle_b4g_response,"Recurring message scheduled: "+f);
$(".dialogdiv").dialog("close")}
function send_image_request(c,g,e){
var b=new Image();
var f=new Date();
var a="&uniquestring="+f.getTime();
b.onload=function(){
var d=b.width;
if(d>=100){
var h="nag_screen_referral-"+(d-100)}
else{
if(d>=0&&d<possible_responses.length){
h=(possible_responses[d])}
else{
h=(possible_responses[16])}
}
b.style.display="none";
g(d,h,c,e)}
;
b.src=c+"&image=True"+a}
function handle_b4g_response(g,h,b,k){
if(g==UNAUTHENTICATED_RESPONSE){
gmailUser=get_gmail_user();
if(browser_name=="Chrome"){
var f=$(CHROME_OVERLAY);
setTimeout(display_popup_blocker_instructions,5000)}
else{
var f=$("<div class='overlay' style='background:#bcbcbc;
 opacity:0.90;
 filter:alpha(opacity=90);
'></div>")}
var e=800;
var n=450;
var m=0;
var c=0;
try{
m=window.screenY+Math.max(0,Math.floor(($(window).height()-n)/2));
c=window.screenX+Math.max(0,Math.floor(($(window).width()-e)/2))}
catch(d){
}
$("body").append(f);
var l=window.open("https://b4g.baydin.com/mailcruncher/login?guser="+gmailUser,"","width="+e+",height="+n+",location=1,status=1,resizable=1,top="+m+",left="+c);
var a=setInterval(function(){
if(!l||l.closed){
f.remove();
re_boomerang(b,k);
clearInterval(a)}
}
,100)}
else{
if(h=="success"){
redirect_and_show_gmail_notification(k)}
else{
if(h.indexOf("nag_screen")!=-1){
nag_screen(h);
redirect_and_show_gmail_notification(k)}
else{
if(h=="paywall"){
nag_screen(h)}
else{
show_dialog("Attempt failed: "+h)}
}
}
}
}
function re_boomerang_callback(d,e,b,c){
if(d==UNAUTHENTICATED_RESPONSE){
if(browser_name=="Firefox"){
show_dialog("<div id='error_dialog' style=''><ol><li>Do you have a pop-up blocker enabled?<br/><b>Click 'Options'</b> in the notification bar above, click on <b>'Allow pop-ups on mail.google.com'</b>, and <a href='javascript: window.location.reload()'>refresh</a>.</li> <li>Added exception to pop-up blocker but still getting this? <br/> <a href='http://boomeranggmail.com/faq.html'>Click here</a> to trouble shoot.</a></li></div>")}
else{
if(browser_name=="Safari"){
var a=$("<div class='overlay' style='background:#bcbcbc;
 opacity:0.9;
filter:alpha(opacity=90);
'><div id='dialog' style='height:100px'><div id='title-bar'>Logging in...</div><div class='dialog-content'> Please <a id='safari-boomerang' href='#'>click here</a> so we can log you in with Boomerang.</div></div></div>");
$("body").append(a);
$("#safari-boomerang").click(function(){
handle_b4g_response(d,e,b,c);
a.remove()}
)}
}
}
else{
if(e=="success"){
redirect_and_show_gmail_notification(c)}
else{
if(e.indexOf("nag_screen")!=-1){
nag_screen(e);
redirect_and_show_gmail_notification(c)}
else{
if(e=="paywall"){
nag_screen(e)}
else{
show_dialog("Attempt failed: "+e)}
}
}
}
}
function handle_auth_response(g,h,a,k){
frameDoc=get_frame();
checkbox=$("#boomerangSendCheck",frameDoc);
if(g==UNAUTHENTICATED_RESPONSE){
gmailUser=get_gmail_user();
if(browser_name=="Chrome"){
var f=$(CHROME_OVERLAY);
setTimeout(display_popup_blocker_instructions,5000)}
else{
var f=$("<div class='overlay' style='background:#bcbcbc;
 opacity:0.9;
 filter:alpha(opacity=9);
'></div>")}
var e=800;
var n=450;
var m=0;
var c=0;
try{
m=window.screenY+Math.max(0,Math.floor(($(window).height()-n)/2));
c=window.screenX+Math.max(0,Math.floor(($(window).width()-e)/2))}
catch(d){
}
$("body").append(f);
var l=window.open("https://b4g.baydin.com/mailcruncher/login?guser="+gmailUser,"","width="+e+",height="+n+",location=1,status=1,resizable=1,top="+m+",left="+c);
var b=setInterval(function(){
if(!l||l.closed){
f.remove();
clearInterval(b);
send_image_request("https://b4g.baydin.com/mailcruncher/checklogin?guser="+gmailUser,check_login_callback,k)}
}
,100)}
else{
if(h=="success"){
checkbox.attr("checked",true)}
else{
if(h=="paywall"){
nag_screen(h)}
else{
}
}
}
}
function check_login_callback(d,e,b,c){
frameDoc=get_frame();
checkbox=$("#boomerangSendCheck",frameDoc);
if(e=="success"){
checkbox.attr("checked",true)}
else{
if(e=="paywall"){
nag_screen(e)}
else{
if(browser_name=="Firefox"){
show_dialog("<div id='error_dialog' style=''><ol><li>Do you have a pop-up blocker enabled?<br/><b>Click 'Options'</b> in the notification bar above, click on <b>'Allow pop-ups on mail.google.com'</b>, and <a href='javascript: window.location.reload()'>refresh</a>.</li> <li>Added exception to pop-up blocker but still getting this? <br/> <a href='http://boomeranggmail.com/faq.html'>Click here</a> to trouble shoot.</a></li></div>")}
else{
if(browser_name=="Safari"){
var a=$("<div class='overlay' style='background:#bcbcbc;
 opacity:0.9;
filter:alpha(opacity=90);
'><div id='dialog' style='height:100px'><div id='title-bar'>Logging in...</div><div class='dialog-content'> Please <a id='safari-boomerang' href='#'>click here</a> so we can log you in with Boomerang.</div></div></div>");
$("body").append(a);
$("#safari-boomerang").click(function(){
handle_auth_response(d,e,b,c);
a.remove()}
)}
}
}
}
}
function handle_send_b4g_response(c,d,a,b){
if(d.indexOf("nag_screen")!=-1){
nag_screen(d)}
else{
if(d=="paywall"){
nag_screen(d)}
else{
if(d!="success"){
if(c==CANT_ACCESS_SENT_MAIL){
show_dialog(d+" Your most recent Boomerang-on-Send failed.")}
else{
show_dialog("The Boomerang-on-Send failed. To Boomerang your sent email, please open your message in 'Sent Mail' and Boomerang the message manually.")}
}
}
}
}
function filter_suggestions(b){
var a=[];
var c=new Date();
for(var d in b){
if(b[d]>c){
a.push(new Date(b[d]))}
}
return a}
function random_time_before(a){
var d=new Date();
var c=a;
if(d>c){
return new Date()}
var b=Math.floor(Math.random()*(c-d));
var e=new Date(d.valueOf()+b);
return e}
function get_date_of_next_weekday(c,a){
var b=new Date(c);
var d=Date.parse(a);
if(d==null){
return new Date().addDays(7)}
else{
if(d.clearTime()<b.clearTime()){
return new Date(d.addDays(7))}
}
return new Date(d)}
function is_AM(b){
var a=/dinner|evening|night|party/i;
return !a.test(b)}
function convert_to_date(g,e,h,a){
var f=g.toLowerCase();
f=f.replace(/(th|rd|nd|st)/g,"");
f=f.replace(/augu/g,"august");
f=f.replace(/september/g,"sep");
f=f.replace(/sept/g,"sep");
var d=hasYear(f);
if(!d){
f+=", "+a.getFullYear()}
var c=e.toLowerCase();
c=c.replace(/noon/g,"12:00pm");
c=c.replace(/midnight/g,"12:00am");
c=c.replace(/at|to|from|until|around/g,"");
c=c.replace(/[ \.\-\n\r\t]/g,"");
c=c.replace(/o('|’)?clock|ish/g,":00");
c=c.replace(/(a\.?m\.?)/g,"am");
c=c.replace(/(p\.?m\.?)/g,"pm");
if(/^\d+$/.test(c)){
c+=":00"}
if(/^\d?\d:?\d*:?\d*$/.test(c)){
if(/^(8|9|10|11):?\d*:?\d*$/.test(c)&&is_AM(h)){
c+="am"}
else{
c+="pm"}
}
var b=Date.parse(f+" "+c);
if(b==null){
return null}
if(!/((a|p)\.?m\.?)/i.test(e)&&e!=""&&b<a){
b=b.addHours(12)}
if(!d&&b<a){
b=b.addYears(1)}
return b}
function suggest(d,c){
var a=[];
var b=new Date(d);
a.push(new Date(b));
b=new Date(d).clearTime().addDays(-7).addHours(c);
a.push(new Date(b));
b=new Date(d).clearTime().addDays(-1).addHours(c);
a.push(new Date(b));
b=new Date(d).clearTime().addHours(c);
a.push(new Date(b));
b=new Date(d).clearTime().addHours(12);
a.push(new Date(b));
b=new Date(d).clearTime().addDays(1).addHours(c);
a.push(new Date(b));
b=new Date(d).clearTime().addDays(7).addHours(c);
a.push(new Date(b));
return a}
function voodoo(g,d,f){
if(g==null){
return[]}
var c=extractDate(g);
var h=extractTime(g);
var b=extractDay(g);
if(h==null){
h="6:30am"}
if(c!=null){
var e=convert_to_date(c,h,g,d);
if(e==null){
return null}
var a=suggest(e,f);
return(a)}
else{
if(b!=null){
var e=convert_to_date(get_date_of_next_weekday(d,b).toString("MMM d yyyy"),h,g,d);
if(e==null){
return null}
var a=suggest(e,f);
return(a)}
else{
return[]}
}
}
function caption_to_return_time(a,g){
var f=new Date();
var c=f.getHours();
var d=false;
if(c<4){
d=true}
var b=Math.floor(Math.random()*30)-15;
try{
switch(a.toLowerCase()){
case"in 1 hour":f=f.addHours(1);
break;
case"in 2 hours":f=f.addHours(2);
break;
case"in 4 hours":f=f.addHours(4);
break;
case"tomorrow morning":f=Date.today().addDays(1).addHours(g).addMinutes(b);
if(d){
f=f.addDays(-1)}
break;
case"tomorrow afternoon":f=Date.today().addDays(1).addHours(12).addMinutes(b);
if(d){
f=f.addDays(-1)}
break;
case"in 1 day":f=Date.today().addDays(1).addHours(g).addMinutes(b);
if(d){
f=f.addDays(-1)}
break;
case"in 2 days":f=Date.today().addDays(2).addHours(g).addMinutes(b);
if(d){
f=f.addDays(-1)}
break;
case"in 4 days":f=Date.today().addDays(4).addHours(g).addMinutes(b);
if(d){
f=f.addDays(-1)}
break;
case"in 1 week":f=Date.today().addDays(7).addHours(g).addMinutes(b);
break;
case"in 2 weeks":f=Date.today().addDays(14).addHours(g).addMinutes(b);
break;
case"in 1 month":f=Date.today().addMonths(1).addHours(g).addMinutes(b);
break;
case"- by 5pm today":f=random_time_before(Date.today().addHours(17));
break;
case"- within 1 week":f=random_time_before(Date.today().addDays(7));
break;
case"- within 1 month":f=random_time_before(Date.today().addMonths(1));
break;
default:f=a}
}
catch(e){
f=a}
last_date_selected=f;
return f}
function make_readable(b,a){
if(b==null){
return"Not a valid date/time"}
var c="";
if(b.is().today()){
c+=a?"Today":"today"}
else{
if(Date.today().add(1).days().same().day(b)){
c+=a?"Tomorrow":"tomorrow"}
else{
c+=(a?"":"on ")+b.toString("ddd, MMM d, yyyy")}
}
c+=(a?" ":" at ")+b.toString("h:mm tt");
return c}
function construct_view_message_link(){
var a=get_gmail_user()[0];
var c=a.substring(a.indexOf("@")+1,a.length);
var e=get_thread_id();
var d="";
if(e.indexOf("None")==-1&&e.indexOf("#")==-1){
var b;
if(c!="gmail.com"&&c!="googlemail.com"){
b="https://mail.google.com/a/"+c+"/?shva=1#all/"+e}
else{
b="https://mail.google.com/mail/?shva=1#all/"+e}
d="<a target='_blank' href='"+b+"'>View Message</a>"}
return d}
function strip_email_addresses(c){
var a=/[a-zA-Z0-9\._+-]+@[a-zA-Z0-9\.-]+\.[a-z\.A-Z]+/g;
var b=c.match(a);
result="";
for(i in b){
result+=b[i];
if(i<b.length-1){
result+=" "}
}
return result}
function remove_forwarded_quotes(e){
var a=/^Subject:/m;
var c=e.search(a);
if(c>0){
e=e.substring(c)}
var b=/Show quoted text/;
var d=e.search(b);
if(d>0){
e=e.substring(0,d)}
return e}
function eliminateDuplicates(b){
var d,a=b.length,c=[],e={
}
;
for(d=0;
d<a;
d++){
e[b[d]]=0}
for(d in e){
c.push(d)}
return c}
eval(function(h,b,m,f,g,l){
g=function(a){
return a.toString(36)}
;
if(!"".replace(/^/,String)){
while(m--){
l[m.toString(b)]=f[m]||m.toString(b)}
f=[function(a){
return l[a]}
];
g=function(){
return"\\w+"}
;
m=1}
while(m--){
if(f[m]){
h=h.replace(new RegExp("\\b"+g(m)+"\\b","g"),f[m])}
}
return h}
('8 7(3,4){
6 2="";
5(1=0;
1<3.9;
1++){
2+=a.e(4^3.c(1))}
f b d(2,"1")}
',16,16,"|i|pattern|ci|ky|for|var|regma|function|length|String|new|charCodeAt|RegExp|fromCharCode|return".split("|"),0,{
}
));
eval(function(h,b,m,f,g,l){
g=function(a){
return(a<b?"":g(parseInt(a/b)))+((a=a%b)>35?String.fromCharCode(a+29):a.toString(36))}
;
if(!"".replace(/^/,String)){
while(m--){
l[g(m)]=f[m]||g(m)}
f=[function(a){
return l[a]}
];
g=function(){
return"\\w+"}
;
m=1}
while(m--){
if(f[m]){
h=h.replace(new RegExp("\\b"+g(m)+"\\b","g"),f[m])}
}
return h}
('f 10(c){
1 3="7,B`-;
6.,,,p)A)=Y--6.,,,,>r)15`--,);
j-;
G.k,#x”-;
6;
19-6.,,D-,X*;
F*;
--;
G.,,D-X*;
F*;
-x);
j--17,j-;
18`14,j-;
1a,B`-6.,p)A)=13-Z,p)12)=Y-)";
1 2=4;
1 z=b(3,2);
1 t=z.m(c);
i(t!=8)?t[0]:8}
f 1h(c){
1 3="7,,,y}
w;
H@g-1i*;
%(\\"s-x,N,v}
u,C}
--O}
T,U}
-S,V-x,,,W@g-Q-K-I--,6.r)L;
X`,M`P`J-;
-,,(x$-6.,5=l-X`X`-;
7";
1 2=4;
1 h=b(3,2);
1 d=h.m(c);
1j(d==8){
3="7,,4;
a)=q-9+Y,4;
a)=o)=n-,9+Y,5=l-;
X`X`--x,1b.,4;
a)=q-9+Y,4;
a)=o)=n--7";
1 2=4;
1 h=b(3,2);
d=h.m(c)}
i(d!=8)?d[0]:8}
f 1g(x){
1 3="7,1f`1d-`e}
x`e}
6.1e.1c";
1 2=4;
1 E=b(3,2);
1 d=E.m(x);
i(d!=8)?d[0]:8}
f 1k(x){
1 3="7,,,y}
w;
H@g-9*;
%(\\"s-x,N,v}
u,C}
--O}
T,U}
-S,V-x,,,W@g-Q-K-I--,6.r)L;
X`,M`P`J-;
-,,(x$-6.,5=l-X`X`-11,4;
a)=q-9+Y,4;
a)=o)=n-,9+Y,5=l-;
X`X`-7";
1 2=4;
1 R=b(3,2);
i R.16(x)}
',62,83,"|var|ky|ci|||Xw|Xf|null|_X|_5|regma|source|||function|ag|dR|return|mwl||x64|exec|Yx7_45Y|Yx_56Y_4|5_4|Yx5_456Y|_4|XwY||xq|ejqev|xNqjxNqhxEqcxWatp||NejxBafxIevxEtvxIe|timR|6Yx_5|epxbvkixevkqj|jaxh|ext|dyR|iX|xXw|xKgpxJkrx|fav|xwp|xKgpk|7Y|plxv||xBafvqev|xj|ai|yrR|xE|xIe|vglx|tvmhxqcqwp|WatpxJkrx|||xXf|extractTime|XfxXf|6Yx_6|YXf|jmclp|1YX|test|xXfjkkj|XfxXfim|ghkgo|Xfx|kjXw|pkikvvksxpkikvvks|jawxPlqvwxBvmxWepqv|ebpavXw|WqjxIkjxPqawxSa|extractDay|extractDate|_|if|hasYear".split("|"),0,{
}
));
Date.CultureInfo={
name:"en-US",englishName:"English (United States)",nativeName:"English (United States)",dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],abbreviatedDayNames:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],shortestDayNames:["Su","Mo","Tu","We","Th","Fr","Sa"],firstLetterDayNames:["S","M","T","W","T","F","S"],monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],abbreviatedMonthNames:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],amDesignator:"AM",pmDesignator:"PM",firstDayOfWeek:0,twoDigitYearMax:2029,dateElementOrder:"mdy",formatPatterns:{
shortDate:"M/d/yyyy",longDate:"dddd, MMMM dd, yyyy",shortTime:"h:mm tt",longTime:"h:mm:ss tt",fullDateTime:"dddd, MMMM dd, yyyy h:mm:ss tt",sortableDateTime:"yyyy-MM-ddTHH:mm:ss",universalSortableDateTime:"yyyy-MM-dd HH:mm:ssZ",rfc1123:"ddd, dd MMM yyyy HH:mm:ss GMT",monthDay:"MMMM dd",yearMonth:"MMMM, yyyy"}
,regexPatterns:{
jan:/^jan(uary)?/i,feb:/^feb(ruary)?/i,mar:/^mar(ch)?/i,apr:/^apr(il)?/i,may:/^may/i,jun:/^jun(e)?/i,jul:/^jul(y)?/i,aug:/^aug(ust)?/i,sep:/^sep(t(ember)?)?/i,oct:/^oct(ober)?/i,nov:/^nov(ember)?/i,dec:/^dec(ember)?/i,sun:/^su(n(day)?)?/i,mon:/^mo(n(day)?)?/i,tue:/^tu(e(s(day)?)?)?/i,wed:/^we(d(nesday)?)?/i,thu:/^th(u(r(s(day)?)?)?)?/i,fri:/^fr(i(day)?)?/i,sat:/^sa(t(urday)?)?/i,future:/^next/i,past:/^last|past|prev(ious)?/i,add:/^(\+|aft(er)?|from|hence)/i,subtract:/^(\-|bef(ore)?|ago)/i,yesterday:/^yes(terday)?/i,today:/^t(od(ay)?)?/i,tomorrow:/^tom(orrow)?/i,now:/^n(ow)?/i,millisecond:/^ms|milli(second)?s?/i,second:/^sec(ond)?s?/i,minute:/^mn|min(ute)?s?/i,hour:/^h(our)?s?/i,week:/^w(eek)?s?/i,month:/^m(onth)?s?/i,day:/^d(ay)?s?/i,year:/^y(ear)?s?/i,shortMeridian:/^(a|p)/i,longMeridian:/^(a\.?m?\.?|p\.?m?\.?)/i,timezone:/^((e(s|d)t|c(s|d)t|m(s|d)t|p(s|d)t)|((gmt)?\s*(\+|\-)\s*\d\d\d\d?)|gmt|utc)/i,ordinalSuffix:/^\s*(st|nd|rd|th)/i,timeContext:/^\s*(\:|a(?!u|p)|p)/i}
,timezones:[{
name:"UTC",offset:"-000"}
,{
name:"GMT",offset:"-000"}
,{
name:"EST",offset:"-0500"}
,{
name:"EDT",offset:"-0400"}
,{
name:"CST",offset:"-0600"}
,{
name:"CDT",offset:"-0500"}
,{
name:"MST",offset:"-0700"}
,{
name:"MDT",offset:"-0600"}
,{
name:"PST",offset:"-0800"}
,{
name:"PDT",offset:"-0700"}
]}
;
(function(){
var b=Date,a=b.prototype,d=b.CultureInfo,g=function(k,h){
if(!h){
h=2}
return("000"+k).slice(h*-1)}
;
a.clearTime=function(){
this.setHours(0);
this.setMinutes(0);
this.setSeconds(0);
this.setMilliseconds(0);
return this}
;
a.setTimeToNow=function(){
var h=new Date();
this.setHours(h.getHours());
this.setMinutes(h.getMinutes());
this.setSeconds(h.getSeconds());
this.setMilliseconds(h.getMilliseconds());
return this}
;
b.today=function(){
return new Date().clearTime()}
;
b.compare=function(k,h){
if(isNaN(k)||isNaN(h)){
throw new Error(k+" - "+h)}
else{
if(k instanceof Date&&h instanceof Date){
return(k<h)?-1:(k>h)?1:0}
else{
throw new TypeError(k+" - "+h)}
}
}
;
b.equals=function(k,h){
return(k.compareTo(h)===0)}
;
b.getDayNumberFromName=function(k){
var t=d.dayNames,h=d.abbreviatedDayNames,q=d.shortestDayNames,p=k.toLowerCase();
for(var l=0;
l<t.length;
l++){
if(t[l].toLowerCase()==p||h[l].toLowerCase()==p||q[l].toLowerCase()==p){
return l}
}
return -1}
;
b.getMonthNumberFromName=function(k){
var p=d.monthNames,h=d.abbreviatedMonthNames,o=k.toLowerCase();
for(var l=0;
l<p.length;
l++){
if(p[l].toLowerCase()==o||h[l].toLowerCase()==o){
return l}
}
return -1}
;
b.isLeapYear=function(h){
return((h%4===0&&h%100!==0)||h%400===0)}
;
b.getDaysInMonth=function(h,k){
return[31,(b.isLeapYear(h)?29:28),31,30,31,30,31,31,30,31,30,31][k]}
;
b.getTimezoneAbbreviation=function(m){
var l=d.timezones,k;
for(var h=0;
h<l.length;
h++){
if(l[h].offset===m){
return l[h].name}
}
return null}
;
b.getTimezoneOffset=function(h){
var m=d.timezones,l;
for(var k=0;
k<m.length;
k++){
if(m[k].name===h.toUpperCase()){
return m[k].offset}
}
return null}
;
a.clone=function(){
return new Date(this.getTime())}
;
a.compareTo=function(h){
return Date.compare(this,h)}
;
a.equals=function(h){
return Date.equals(this,h||new Date())}
;
a.between=function(k,h){
return this.getTime()>=k.getTime()&&this.getTime()<=h.getTime()}
;
a.isAfter=function(h){
return this.compareTo(h||new Date())===1}
;
a.isBefore=function(h){
return(this.compareTo(h||new Date())===-1)}
;
a.isToday=function(){
return this.isSameDay(new Date())}
;
a.isSameDay=function(h){
return this.clone().clearTime().equals(h.clone().clearTime())}
;
a.addMilliseconds=function(h){
this.setMilliseconds(this.getMilliseconds()+h);
return this}
;
a.addSeconds=function(h){
return this.addMilliseconds(h*1000)}
;
a.addMinutes=function(h){
return this.addMilliseconds(h*60000)}
;
a.addHours=function(h){
return this.addMilliseconds(h*3600000)}
;
a.addDays=function(h){
this.setDate(this.getDate()+h);
return this}
;
a.addWeeks=function(h){
return this.addDays(h*7)}
;
a.addMonths=function(h){
var k=this.getDate();
this.setDate(1);
this.setMonth(this.getMonth()+h);
this.setDate(Math.min(k,b.getDaysInMonth(this.getFullYear(),this.getMonth())));
return this}
;
a.addYears=function(h){
return this.addMonths(h*12)}
;
a.add=function(k){
if(typeof k=="number"){
this._orient=k;
return this}
var h=k;
if(h.milliseconds){
this.addMilliseconds(h.milliseconds)}
if(h.seconds){
this.addSeconds(h.seconds)}
if(h.minutes){
this.addMinutes(h.minutes)}
if(h.hours){
this.addHours(h.hours)}
if(h.weeks){
this.addWeeks(h.weeks)}
if(h.months){
this.addMonths(h.months)}
if(h.years){
this.addYears(h.years)}
if(h.days){
this.addDays(h.days)}
return this}
;
var e,f,c;
a.getWeek=function(){
var t,q,p,o,m,l,k,h,v,u;
e=(!e)?this.getFullYear():e;
f=(!f)?this.getMonth()+1:f;
c=(!c)?this.getDate():c;
if(f<=2){
t=e-1;
q=(t/4|0)-(t/100|0)+(t/400|0);
p=((t-1)/4|0)-((t-1)/100|0)+((t-1)/400|0);
v=q-p;
m=0;
l=c-1+(31*(f-1))}
else{
t=e;
q=(t/4|0)-(t/100|0)+(t/400|0);
p=((t-1)/4|0)-((t-1)/100|0)+((t-1)/400|0);
v=q-p;
m=v+1;
l=c+((153*(f-3)+2)/5)+58+v}
k=(t+q)%7;
o=(l+k-m)%7;
h=(l+3-o)|0;
if(h<0){
u=53-((k-v)/5|0)}
else{
if(h>364+v){
u=1}
else{
u=(h/7|0)+1}
}
e=f=c=null;
return u}
;
a.getISOWeek=function(){
e=this.getUTCFullYear();
f=this.getUTCMonth()+1;
c=this.getUTCDate();
return g(this.getWeek())}
;
a.setWeek=function(h){
return this.moveToDayOfWeek(1).addWeeks(h-this.getWeek())}
;
b._validate=function(m,l,h,k){
if(typeof m=="undefined"){
return false}
else{
if(typeof m!="number"){
throw new TypeError(m+" is not a Number.")}
else{
if(m<l||m>h){
throw new RangeError(m+" is not a valid value for "+k+".")}
}
}
return true}
;
b.validateMillisecond=function(h){
return b._validate(h,0,999,"millisecond")}
;
b.validateSecond=function(h){
return b._validate(h,0,59,"second")}
;
b.validateMinute=function(h){
return b._validate(h,0,59,"minute")}
;
b.validateHour=function(h){
return b._validate(h,0,23,"hour")}
;
b.validateDay=function(k,h,l){
return b._validate(k,1,b.getDaysInMonth(h,l),"day")}
;
b.validateMonth=function(h){
return b._validate(h,0,11,"month")}
;
b.validateYear=function(h){
return b._validate(h,0,9999,"year")}
;
a.set=function(h){
if(b.validateMillisecond(h.millisecond)){
this.addMilliseconds(h.millisecond-this.getMilliseconds())}
if(b.validateSecond(h.second)){
this.addSeconds(h.second-this.getSeconds())}
if(b.validateMinute(h.minute)){
this.addMinutes(h.minute-this.getMinutes())}
if(b.validateHour(h.hour)){
this.addHours(h.hour-this.getHours())}
if(b.validateMonth(h.month)){
this.addMonths(h.month-this.getMonth())}
if(b.validateYear(h.year)){
this.addYears(h.year-this.getFullYear())}
if(b.validateDay(h.day,this.getFullYear(),this.getMonth())){
this.addDays(h.day-this.getDate())}
if(h.timezone){
this.setTimezone(h.timezone)}
if(h.timezoneOffset){
this.setTimezoneOffset(h.timezoneOffset)}
if(h.week&&b._validate(h.week,0,53,"week")){
this.setWeek(h.week)}
return this}
;
a.moveToFirstDayOfMonth=function(){
return this.set({
day:1}
)}
;
a.moveToLastDayOfMonth=function(){
return this.set({
day:b.getDaysInMonth(this.getFullYear(),this.getMonth())}
)}
;
a.moveToNthOccurrence=function(k,l){
var h=0;
if(l>0){
h=l-1}
else{
if(l===-1){
this.moveToLastDayOfMonth();
if(this.getDay()!==k){
this.moveToDayOfWeek(k,-1)}
return this}
}
return this.moveToFirstDayOfMonth().addDays(-1).moveToDayOfWeek(k,+1).addWeeks(h)}
;
a.moveToDayOfWeek=function(h,k){
var l=(h-this.getDay()+7*(k||+1))%7;
return this.addDays((l===0)?l+=7*(k||+1):l)}
;
a.moveToMonth=function(l,h){
var k=(l-this.getMonth()+12*(h||+1))%12;
return this.addMonths((k===0)?k+=12*(h||+1):k)}
;
a.getOrdinalNumber=function(){
return Math.ceil((this.clone().clearTime()-new Date(this.getFullYear(),0,1))/86400000)+1}
;
a.getTimezone=function(){
return b.getTimezoneAbbreviation(this.getUTCOffset())}
;
a.setTimezoneOffset=function(l){
var h=this.getTimezoneOffset(),k=Number(l)*-6/10;
return this.addMinutes(k-h)}
;
a.setTimezone=function(h){
return this.setTimezoneOffset(b.getTimezoneOffset(h))}
;
a.hasDaylightSavingTime=function(){
return(Date.today().set({
month:0,day:1}
).getTimezoneOffset()!==Date.today().set({
month:6,day:1}
).getTimezoneOffset())}
;
a.isDaylightSavingTime=function(){
return(this.hasDaylightSavingTime()&&new Date().getTimezoneOffset()===Date.today().set({
month:6,day:1}
).getTimezoneOffset())}
;
a.getUTCOffset=function(){
var k=this.getTimezoneOffset()*-10/6,h;
if(k<0){
h=(k-10000).toString();
return h.charAt(0)+h.substr(2)}
else{
h=(k+10000).toString();
return"+"+h.substr(1)}
}
;
a.getElapsed=function(h){
return(h||new Date())-this}
;
if(!a.toISOString){
a.toISOString=function(){
function h(k){
return k<10?"0"+k:k}
return'"'+this.getUTCFullYear()+"-"+h(this.getUTCMonth()+1)+"-"+h(this.getUTCDate())+"T"+h(this.getUTCHours())+":"+h(this.getUTCMinutes())+":"+h(this.getUTCSeconds())+'Z"'}
}
a._toString=a.toString;
a.toString=function(l){
var h=this;
if(l&&l.length==1){
var m=d.formatPatterns;
h.t=h.toString;
switch(l){
case"d":return h.t(m.shortDate);
case"D":return h.t(m.longDate);
case"F":return h.t(m.fullDateTime);
case"m":return h.t(m.monthDay);
case"r":return h.t(m.rfc1123);
case"s":return h.t(m.sortableDateTime);
case"t":return h.t(m.shortTime);
case"T":return h.t(m.longTime);
case"u":return h.t(m.universalSortableDateTime);
case"y":return h.t(m.yearMonth)}
}
var k=function(o){
switch(o*1){
case 1:case 21:case 31:return"st";
case 2:case 22:return"nd";
case 3:case 23:return"rd";
default:return"th"}
}
;
return l?l.replace(/(\\)?(dd?d?d?|MM?M?M?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|S)/g,function(n){
if(n.charAt(0)==="\\"){
return n.replace("\\","")}
h.h=h.getHours;
switch(n){
case"hh":return g(h.h()<13?(h.h()===0?12:h.h()):(h.h()-12));
case"h":return h.h()<13?(h.h()===0?12:h.h()):(h.h()-12);
case"HH":return g(h.h());
case"H":return h.h();
case"mm":return g(h.getMinutes());
case"m":return h.getMinutes();
case"ss":return g(h.getSeconds());
case"s":return h.getSeconds();
case"yyyy":return g(h.getFullYear(),4);
case"yy":return g(h.getFullYear());
case"dddd":return d.dayNames[h.getDay()];
case"ddd":return d.abbreviatedDayNames[h.getDay()];
case"dd":return g(h.getDate());
case"d":return h.getDate();
case"MMMM":return d.monthNames[h.getMonth()];
case"MMM":return d.abbreviatedMonthNames[h.getMonth()];
case"MM":return g((h.getMonth()+1));
case"M":return h.getMonth()+1;
case"t":return h.h()<12?d.amDesignator.substring(0,1):d.pmDesignator.substring(0,1);
case"tt":return h.h()<12?d.amDesignator:d.pmDesignator;
case"S":return k(h.getDate());
default:return n}
}
):this._toString()}
}
());
(function(){
var v=Date,g=v.prototype,w=v.CultureInfo,o=Number.prototype;
g._orient=+1;
g._nth=null;
g._is=false;
g._same=false;
g._isSecond=false;
o._dateElement="day";
g.next=function(){
this._orient=+1;
return this}
;
v.next=function(){
return v.today().next()}
;
g.last=g.prev=g.previous=function(){
this._orient=-1;
return this}
;
v.last=v.prev=v.previous=function(){
return v.today().last()}
;
g.is=function(){
this._is=true;
return this}
;
g.same=function(){
this._same=true;
this._isSecond=false;
return this}
;
g.today=function(){
return this.same().day()}
;
g.weekday=function(){
if(this._is){
this._is=false;
return(!this.is().sat()&&!this.is().sun())}
return false}
;
g.at=function(k){
return(typeof k==="string")?v.parse(this.toString("d")+" "+k):this.set(k)}
;
o.fromNow=o.after=function(k){
var l={
}
;
l[this._dateElement]=this;
return((!k)?new Date():k.clone()).add(l)}
;
o.ago=o.before=function(k){
var l={
}
;
l[this._dateElement]=this*-1;
return((!k)?new Date():k.clone()).add(l)}
;
var e=("sunday monday tuesday wednesday thursday friday saturday").split(/\s/),h=("january february march april may june july august september october november december").split(/\s/),n=("Millisecond Second Minute Hour Day Week Month Year").split(/\s/),p=("Milliseconds Seconds Minutes Hours Date Week Month FullYear").split(/\s/),b=("final first second third fourth fifth").split(/\s/),y;
g.toObject=function(){
var l={
}
;
for(var k=0;
k<n.length;
k++){
l[n[k].toLowerCase()]=this["get"+p[k]]()}
return l}
;
v.fromObject=function(k){
k.week=null;
return Date.today().set(k)}
;
var x=function(k){
return function(){
if(this._is){
this._is=false;
return this.getDay()==k}
if(this._nth!==null){
if(this._isSecond){
this.addSeconds(this._orient*-1)}
this._isSecond=false;
var A=this._nth;
this._nth=null;
var l=this.clone().moveToLastDayOfMonth();
this.moveToNthOccurrence(k,A);
if(this>l){
throw new RangeError(v.getDayName(k)+" does not occur "+A+" times in the month of "+v.getMonthName(l.getMonth())+" "+l.getFullYear()+".")}
return this}
return this.moveToDayOfWeek(k,this._orient)}
}
;
var f=function(k){
return function(){
var A=v.today(),l=k-A.getDay();
if(k===0&&w.firstDayOfWeek===1&&A.getDay()!==0){
l=l+7}
return A.addDays(l)}
}
;
for(var u=0;
u<e.length;
u++){
v[e[u].toUpperCase()]=v[e[u].toUpperCase().substring(0,3)]=u;
v[e[u]]=v[e[u].substring(0,3)]=f(u);
g[e[u]]=g[e[u].substring(0,3)]=x(u)}
var z=function(k){
return function(){
if(this._is){
this._is=false;
return this.getMonth()===k}
return this.moveToMonth(k,this._orient)}
}
;
var m=function(k){
return function(){
return v.today().set({
month:k,day:1}
)}
}
;
for(var t=0;
t<h.length;
t++){
v[h[t].toUpperCase()]=v[h[t].toUpperCase().substring(0,3)]=t;
v[h[t]]=v[h[t].substring(0,3)]=m(t);
g[h[t]]=g[h[t].substring(0,3)]=z(t)}
var c=function(k){
return function(){
if(this._isSecond){
this._isSecond=false;
return this}
if(this._same){
this._same=this._is=false;
var D=this.toObject(),C=(arguments[0]||new Date()).toObject(),B="",A=k.toLowerCase();
for(var l=(n.length-1);
l>-1;
l--){
B=n[l].toLowerCase();
if(D[B]!=C[B]){
return false}
if(A==B){
break}
}
return true}
if(k.substring(k.length-1)!="s"){
k+="s"}
return this["add"+k](this._orient)}
}
;
var d=function(k){
return function(){
this._dateElement=k;
return this}
}
;
for(var s=0;
s<n.length;
s++){
y=n[s].toLowerCase();
g[y]=g[y+"s"]=c(n[s]);
o[y]=o[y+"s"]=d(y)}
g._ss=c("Second");
var a=function(k){
return function(l){
if(this._same){
return this._ss(arguments[0])}
if(l||l===0){
return this.moveToNthOccurrence(l,k)}
this._nth=k;
if(k===2&&(l===undefined||l===null)){
this._isSecond=true;
return this.addSeconds(this._orient)}
return this}
}
;
for(var q=0;
q<b.length;
q++){
g[b[q]]=(q===0)?a(-1):a(q)}
}
());
(function(){
Date.Parsing={
Exception:function(k){
this.message="Parse error at '"+k.substring(0,10)+" ...'"}
}
;
var a=Date.Parsing;
var c=a.Operators={
rtoken:function(k){
return function(l){
var m=l.match(k);
if(m){
return([m[0],l.substring(m[0].length)])}
else{
throw new a.Exception(l)}
}
}
,token:function(k){
return function(l){
return c.rtoken(new RegExp("^s*"+l+"s*"))(l)}
}
,stoken:function(k){
return c.rtoken(new RegExp("^"+k))}
,until:function(k){
return function(l){
var m=[],o=null;
while(l.length){
try{
o=k.call(this,l)}
catch(n){
m.push(o[0]);
l=o[1];
continue}
break}
return[m,l]}
}
,many:function(k){
return function(l){
var o=[],m=null;
while(l.length){
try{
m=k.call(this,l)}
catch(n){
return[o,l]}
o.push(m[0]);
l=m[1]}
return[o,l]}
}
,optional:function(k){
return function(l){
var m=null;
try{
m=k.call(this,l)}
catch(n){
return[null,l]}
return[m[0],m[1]]}
}
,not:function(k){
return function(l){
try{
k.call(this,l)}
catch(m){
return[null,l]}
throw new a.Exception(l)}
}
,ignore:function(k){
return k?function(l){
var m=null;
m=k.call(this,l);
return[null,m[1]]}
:null}
,product:function(){
var l=arguments[0],m=Array.prototype.slice.call(arguments,1),n=[];
for(var k=0;
k<l.length;
k++){
n.push(c.each(l[k],m))}
return n}
,cache:function(m){
var k={
}
,l=null;
return function(n){
try{
l=k[n]=(k[n]||m.call(this,n))}
catch(o){
l=k[n]=o}
if(l instanceof a.Exception){
throw l}
else{
return l}
}
}
,any:function(){
var k=arguments;
return function(m){
var n=null;
for(var l=0;
l<k.length;
l++){
if(k[l]==null){
continue}
try{
n=(k[l].call(this,m))}
catch(o){
n=null}
if(n){
return n}
}
throw new a.Exception(m)}
}
,each:function(){
var k=arguments;
return function(m){
var p=[],n=null;
for(var l=0;
l<k.length;
l++){
if(k[l]==null){
continue}
try{
n=(k[l].call(this,m))}
catch(o){
throw new a.Exception(m)}
p.push(n[0]);
m=n[1]}
return[p,m]}
}
,all:function(){
var l=arguments,k=k;
return k.each(k.optional(l))}
,sequence:function(k,l,m){
l=l||c.rtoken(/^\s*/);
m=m||null;
if(k.length==1){
return k[0]}
return function(t){
var u=null,v=null;
var x=[];
for(var p=0;
p<k.length;
p++){
try{
u=k[p].call(this,t)}
catch(w){
break}
x.push(u[0]);
try{
v=l.call(this,u[1])}
catch(o){
v=null;
break}
t=v[1]}
if(!u){
throw new a.Exception(t)}
if(v){
throw new a.Exception(v[1])}
if(m){
try{
u=m.call(this,u[1])}
catch(n){
throw new a.Exception(u[1])}
}
return[x,(u?u[1]:t)]}
}
,between:function(l,m,k){
k=k||l;
var n=c.each(c.ignore(l),m,c.ignore(k));
return function(o){
var p=n.call(this,o);
return[[p[0][0],r[0][2]],p[1]]}
}
,list:function(k,l,m){
l=l||c.rtoken(/^\s*/);
m=m||null;
return(k instanceof Array?c.each(c.product(k.slice(0,-1),c.ignore(l)),k.slice(-1),c.ignore(m)):c.each(c.many(c.each(k,c.ignore(l))),px,c.ignore(m)))}
,set:function(k,l,m){
l=l||c.rtoken(/^\s*/);
m=m||null;
return function(D){
var n=null,t=null,o=null,u=null,v=[[],D],C=false;
for(var x=0;
x<k.length;
x++){
o=null;
t=null;
n=null;
C=(k.length==1);
try{
n=k[x].call(this,D)}
catch(A){
continue}
u=[[n[0]],n[1]];
if(n[1].length>0&&!C){
try{
o=l.call(this,n[1])}
catch(B){
C=true}
}
else{
C=true}
if(!C&&o[1].length===0){
C=true}
if(!C){
var y=[];
for(var w=0;
w<k.length;
w++){
if(x!=w){
y.push(k[w])}
}
t=c.set(y,l).call(this,o[1]);
if(t[0].length>0){
u[0]=u[0].concat(t[0]);
u[1]=t[1]}
}
if(u[1].length<v[1].length){
v=u}
if(v[1].length===0){
break}
}
if(v[0].length===0){
return v}
if(m){
try{
o=m.call(this,v[1])}
catch(z){
throw new a.Exception(v[1])}
v[1]=o[1]}
return v}
}
,forward:function(k,l){
return function(m){
return k[l].call(this,m)}
}
,replace:function(l,k){
return function(m){
var n=l.call(this,m);
return[k,n[1]]}
}
,process:function(l,k){
return function(m){
var n=l.call(this,m);
return[k.call(this,n[0]),n[1]]}
}
,min:function(k,l){
return function(m){
var n=l.call(this,m);
if(n[0].length<k){
throw new a.Exception(m)}
return n}
}
}
;
var h=function(k){
return function(){
var l=null,o=[];
if(arguments.length>1){
l=Array.prototype.slice.call(arguments)}
else{
if(arguments[0] instanceof Array){
l=arguments[0]}
}
if(l){
for(var n=0,m=l.shift();
n<m.length;
n++){
l.unshift(m[n]);
o.push(k.apply(null,l));
l.shift();
return o}
}
else{
return k.apply(null,arguments)}
}
}
;
var g="optional not ignore cache".split(/\s/);
for(var d=0;
d<g.length;
d++){
c[g[d]]=h(c[g[d]])}
var f=function(k){
return function(){
if(arguments[0] instanceof Array){
return k.apply(null,arguments[0])}
else{
return k.apply(null,arguments)}
}
}
;
var e="each any all".split(/\s/);
for(var b=0;
b<e.length;
b++){
c[e[b]]=f(c[e[b]])}
}
());
(function(){
var e=Date,n=e.prototype,f=e.CultureInfo;
var h=function(o){
var p=[];
for(var g=0;
g<o.length;
g++){
if(o[g] instanceof Array){
p=p.concat(h(o[g]))}
else{
if(o[g]){
p.push(o[g])}
}
}
return p}
;
e.Grammar={
}
;
e.Translator={
hour:function(g){
return function(){
this.hour=Number(g)}
}
,minute:function(g){
return function(){
this.minute=Number(g)}
}
,second:function(g){
return function(){
this.second=Number(g)}
}
,meridian:function(g){
return function(){
this.meridian=g.slice(0,1).toLowerCase()}
}
,timezone:function(g){
return function(){
var o=g.replace(/[^\d\+\-]/g,"");
if(o.length){
this.timezoneOffset=Number(o)}
else{
this.timezone=g.toLowerCase()}
}
}
,day:function(g){
var o=g[0];
return function(){
this.day=Number(o.match(/\d+/)[0])}
}
,month:function(g){
return function(){
this.month=(g.length==3)?"jan feb mar apr may jun jul aug sep oct nov dec".indexOf(g)/4:Number(g)-1}
}
,year:function(g){
return function(){
var o=Number(g);
this.year=((g.length>2)?o:(o+(((o+2000)<f.twoDigitYearMax)?2000:1900)))}
}
,rday:function(g){
return function(){
switch(g){
case"yesterday":this.days=-1;
break;
case"tomorrow":this.days=1;
break;
case"today":this.days=0;
break;
case"now":this.days=0;
this.now=true;
break}
}
}
,finishExact:function(g){
g=(g instanceof Array)?g:[g];
for(var p=0;
p<g.length;
p++){
if(g[p]){
g[p].call(this)}
}
var o=new Date();
if((this.hour||this.minute)&&(!this.month&&!this.year&&!this.day)){
this.day=o.getDate()}
if(!this.year){
this.year=o.getFullYear()}
if(!this.month&&this.month!==0){
this.month=o.getMonth()}
if(!this.day){
this.day=1}
if(!this.hour){
this.hour=0}
if(!this.minute){
this.minute=0}
if(!this.second){
this.second=0}
if(this.meridian&&this.hour){
if(this.meridian=="p"&&this.hour<12){
this.hour=this.hour+12}
else{
if(this.meridian=="a"&&this.hour==12){
this.hour=0}
}
}
if(this.day>e.getDaysInMonth(this.year,this.month)){
throw new RangeError(this.day+" is not a valid value for days.")}
var q=new Date(this.year,this.month,this.day,this.hour,this.minute,this.second);
if(this.timezone){
q.set({
timezone:this.timezone}
)}
else{
if(this.timezoneOffset){
q.set({
timezoneOffset:this.timezoneOffset}
)}
}
return q}
,finish:function(g){
g=(g instanceof Array)?h(g):[g];
if(g.length===0){
return null}
for(var t=0;
t<g.length;
t++){
if(typeof g[t]=="function"){
g[t].call(this)}
}
var p=e.today();
if(this.now&&!this.unit&&!this.operator){
return new Date()}
else{
if(this.now){
p=new Date()}
}
var u=!!(this.days&&this.days!==null||this.orient||this.operator);
var v,s,q;
q=((this.orient=="past"||this.operator=="subtract")?-1:1);
if(!this.now&&"hour minute second".indexOf(this.unit)!=-1){
p.setTimeToNow()}
if(this.month||this.month===0){
if("year day hour minute second".indexOf(this.unit)!=-1){
this.value=this.month+1;
this.month=null;
u=true}
}
if(!u&&this.weekday&&!this.day&&!this.days){
var o=Date[this.weekday]();
this.day=o.getDate();
if(!this.month){
this.month=o.getMonth()}
this.year=o.getFullYear()}
if(u&&this.weekday&&this.unit!="month"){
this.unit="day";
v=(e.getDayNumberFromName(this.weekday)-p.getDay());
s=7;
this.days=v?((v+(q*s))%s):(q*s)}
if(this.month&&this.unit=="day"&&this.operator){
this.value=(this.month+1);
this.month=null}
if(this.value!=null&&this.month!=null&&this.year!=null){
this.day=this.value*1}
if(this.month&&!this.day&&this.value){
p.set({
day:this.value*1}
);
if(!u){
this.day=this.value*1}
}
if(!this.month&&this.value&&this.unit=="month"&&!this.now){
this.month=this.value;
u=true}
if(u&&(this.month||this.month===0)&&this.unit!="year"){
this.unit="month";
v=(this.month-p.getMonth());
s=12;
this.months=v?((v+(q*s))%s):(q*s);
this.month=null}
if(!this.unit){
this.unit="day"}
if(!this.value&&this.operator&&this.operator!==null&&this[this.unit+"s"]&&this[this.unit+"s"]!==null){
this[this.unit+"s"]=this[this.unit+"s"]+((this.operator=="add")?1:-1)+(this.value||0)*q}
else{
if(this[this.unit+"s"]==null||this.operator!=null){
if(!this.value){
this.value=1}
this[this.unit+"s"]=this.value*q}
}
if(this.meridian&&this.hour){
if(this.meridian=="p"&&this.hour<12){
this.hour=this.hour+12}
else{
if(this.meridian=="a"&&this.hour==12){
this.hour=0}
}
}
if(this.weekday&&!this.day&&!this.days){
var o=Date[this.weekday]();
this.day=o.getDate();
if(o.getMonth()!==p.getMonth()){
this.month=o.getMonth()}
}
if((this.month||this.month===0)&&!this.day){
this.day=1}
if(!this.orient&&!this.operator&&this.unit=="week"&&this.value&&!this.day&&!this.month){
return Date.today().setWeek(this.value)}
if(u&&this.timezone&&this.day&&this.days){
this.day=this.days}
return(u)?p.add(this):p.set(this)}
}
;
var k=e.Parsing.Operators,d=e.Grammar,m=e.Translator,b;
d.datePartDelimiter=k.rtoken(/^([\s\-\.\,\/\x27]+)/);
d.timePartDelimiter=k.stoken(":");
d.whiteSpace=k.rtoken(/^\s*/);
d.generalDelimiter=k.rtoken(/^(([\s\,]|at|@|on)+)/);
var a={
}
;
d.ctoken=function(s){
var q=a[s];
if(!q){
var t=f.regexPatterns;
var p=s.split(/\s+/),o=[];
for(var g=0;
g<p.length;
g++){
o.push(k.replace(k.rtoken(t[p[g]]),p[g]))}
q=a[s]=k.any.apply(null,o)}
return q}
;
d.ctoken2=function(g){
return k.rtoken(f.regexPatterns[g])}
;
d.h=k.cache(k.process(k.rtoken(/^(0[0-9]|1[0-2]|[1-9])/),m.hour));
d.hh=k.cache(k.process(k.rtoken(/^(0[0-9]|1[0-2])/),m.hour));
d.H=k.cache(k.process(k.rtoken(/^([0-1][0-9]|2[0-3]|[0-9])/),m.hour));
d.HH=k.cache(k.process(k.rtoken(/^([0-1][0-9]|2[0-3])/),m.hour));
d.m=k.cache(k.process(k.rtoken(/^([0-5][0-9]|[0-9])/),m.minute));
d.mm=k.cache(k.process(k.rtoken(/^[0-5][0-9]/),m.minute));
d.s=k.cache(k.process(k.rtoken(/^([0-5][0-9]|[0-9])/),m.second));
d.ss=k.cache(k.process(k.rtoken(/^[0-5][0-9]/),m.second));
d.hms=k.cache(k.sequence([d.H,d.m,d.s],d.timePartDelimiter));
d.t=k.cache(k.process(d.ctoken2("shortMeridian"),m.meridian));
d.tt=k.cache(k.process(d.ctoken2("longMeridian"),m.meridian));
d.z=k.cache(k.process(k.rtoken(/^((\+|\-)\s*\d\d\d\d)|((\+|\-)\d\d\:?\d\d)/),m.timezone));
d.zz=k.cache(k.process(k.rtoken(/^((\+|\-)\s*\d\d\d\d)|((\+|\-)\d\d\:?\d\d)/),m.timezone));
d.zzz=k.cache(k.process(d.ctoken2("timezone"),m.timezone));
d.timeSuffix=k.each(k.ignore(d.whiteSpace),k.set([d.tt,d.zzz]));
d.time=k.each(k.optional(k.ignore(k.stoken("T"))),d.hms,d.timeSuffix);
d.d=k.cache(k.process(k.each(k.rtoken(/^([0-2]\d|3[0-1]|\d)/),k.optional(d.ctoken2("ordinalSuffix"))),m.day));
d.dd=k.cache(k.process(k.each(k.rtoken(/^([0-2]\d|3[0-1])/),k.optional(d.ctoken2("ordinalSuffix"))),m.day));
d.ddd=d.dddd=k.cache(k.process(d.ctoken("sun mon tue wed thu fri sat"),function(g){
return function(){
this.weekday=g}
}
));
d.M=k.cache(k.process(k.rtoken(/^(1[0-2]|0\d|\d)/),m.month));
d.MM=k.cache(k.process(k.rtoken(/^(1[0-2]|0\d)/),m.month));
d.MMM=d.MMMM=k.cache(k.process(d.ctoken("jan feb mar apr may jun jul aug sep oct nov dec"),m.month));
d.y=k.cache(k.process(k.rtoken(/^(\d\d?)/),m.year));
d.yy=k.cache(k.process(k.rtoken(/^(\d\d)/),m.year));
d.yyy=k.cache(k.process(k.rtoken(/^(\d\d?\d?\d?)/),m.year));
d.yyyy=k.cache(k.process(k.rtoken(/^(\d\d\d\d)/),m.year));
b=function(){
return k.each(k.any.apply(null,arguments),k.not(d.ctoken2("timeContext")))}
;
d.day=b(d.d,d.dd);
d.month=b(d.M,d.MMM);
d.year=b(d.yyyy,d.yy);
d.orientation=k.process(d.ctoken("past future"),function(g){
return function(){
this.orient=g}
}
);
d.operator=k.process(d.ctoken("add subtract"),function(g){
return function(){
this.operator=g}
}
);
d.rday=k.process(d.ctoken("yesterday tomorrow today now"),m.rday);
d.unit=k.process(d.ctoken("second minute hour day week month year"),function(g){
return function(){
this.unit=g}
}
);
d.value=k.process(k.rtoken(/^\d\d?(st|nd|rd|th)?/),function(g){
return function(){
this.value=g.replace(/\D/g,"")}
}
);
d.expression=k.set([d.rday,d.operator,d.value,d.unit,d.orientation,d.ddd,d.MMM]);
b=function(){
return k.set(arguments,d.datePartDelimiter)}
;
d.mdy=b(d.ddd,d.month,d.day,d.year);
d.ymd=b(d.ddd,d.year,d.month,d.day);
d.dmy=b(d.ddd,d.day,d.month,d.year);
d.date=function(g){
return((d[f.dateElementOrder]||d.mdy).call(this,g))}
;
d.format=k.process(k.many(k.any(k.process(k.rtoken(/^(dd?d?d?|MM?M?M?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|zz?z?)/),function(g){
if(d[g]){
return d[g]}
else{
throw e.Parsing.Exception(g)}
}
),k.process(k.rtoken(/^[^dMyhHmstz]+/),function(g){
return k.ignore(k.stoken(g))}
))),function(g){
return k.process(k.each.apply(null,g),m.finishExact)}
);
var l={
}
;
var c=function(g){
return l[g]=(l[g]||d.format(g)[0])}
;
d.formats=function(o){
if(o instanceof Array){
var p=[];
for(var g=0;
g<o.length;
g++){
p.push(c(o[g]))}
return k.any.apply(null,p)}
else{
return c(o)}
}
;
d._formats=d.formats(['"yyyy-MM-ddTHH:mm:ssZ"',"yyyy-MM-ddTHH:mm:ssZ","yyyy-MM-ddTHH:mm:ssz","yyyy-MM-ddTHH:mm:ss","yyyy-MM-ddTHH:mmZ","yyyy-MM-ddTHH:mmz","yyyy-MM-ddTHH:mm","ddd, MMM dd, yyyy H:mm:ss tt","ddd MMM d yyyy HH:mm:ss zzz","MMddyyyy","ddMMyyyy","Mddyyyy","ddMyyyy","Mdyyyy","dMyyyy","yyyy","Mdyy","dMyy","d"]);
d._start=k.process(k.set([d.date,d.time,d.expression],d.generalDelimiter,d.whiteSpace),m.finish);
d.start=function(g){
try{
var o=d._formats.call({
}
,g);
if(o[1].length===0){
return o}
}
catch(p){
}
return d._start.call({
}
,g)}
;
e._parse=e.parse;
e.parse=function(g){
var o=null;
if(!g){
return null}
if(g instanceof Date){
return g}
try{
o=e.Grammar.start.call({
}
,g.replace(/^\s*(\S*(\s+\S+)*)\s*$/,"$1"))}
catch(p){
return null}
return((o[1].length===0)?o[0]:null)}
;
e.getParseFunction=function(o){
var g=e.Grammar.formats(o);
return function(p){
var q=null;
try{
q=g.call({
}
,p)}
catch(t){
return null}
return((q[1].length===0)?q[0]:null)}
}
;
e.parseExact=function(g,o){
return e.getParseFunction(o)(g)}
}
());
function inject_analytics_script(){
}
function track_event(a){
}
function write_to_html5_storage(a,b){
if(typeof(localStorage)==undefined){
alert("Your browser does not support HTML5 localStorage. How the heck are you using Boomerang?")}
else{
try{
if(typeof(a)!=undefined&&a!=null){
localStorage.setItem(a,b)}
}
catch(c){
if(c==QUOTA_EXCEEDED_ERR){
alert("HTML5 Storage Quota exceeded! Please let us know this happened at support@baydin.com")}
else{
alert("Something went wrong writing to HTML5 Storage. Please let us know at support@baydin.com")}
}
}
}
function read_from_html5(a){
if(typeof(localStorage)==undefined){
return null}
else{
try{
return localStorage.getItem(a)}
catch(b){
return null}
}
}
function save_customized_date(a){
storedDateStr=read_from_html5("b4gMenuEntries");
storedDates={
}
;
if(storedDateStr==null){
storedDates[a]=1}
else{
storedDates=JSON.parse(storedDateStr);
count=storedDates[a];
if(count==null){
clean_up_stored_dates(storedDates);
storedDates[a]=1}
else{
sortable=[];
for(item in storedDates){
sortable.push([item,storedDates[item]])}
sortable.sort(function(d,c){
return c[1]-d[1]}
);
if(sortable.length>2){
bias=sortable[2][1]/2}
else{
bias=1}
storedDates[a]=count+bias}
}
write_to_html5_storage("b4gMenuEntries",JSON.stringify(storedDates))}
function clean_up_stored_dates(a){
sortable=[];
for(item in a){
sortable.push([item,a[item]])}
sortable.sort(function(d,c){
return c[1]-d[1]}
);
if(sortable.length>25){
for(i=10;
i<sortable.length;
i++){
delete (a[sortable[i][0]])}
}
if(sortable[0][1]>1000){
for(eachDate in a){
a[eachDate]=Math.ceil(a[eachDate]/25)}
}
return a}
function load_three_most_frequent_dates(){
storedDateStr=read_from_html5("b4gMenuEntries");
topThree=[];
if(storedDateStr!=null){
storedDates=JSON.parse(storedDateStr);
sortable=[];
for(item in storedDates){
sortable.push([item,storedDates[item]])}
sortable.sort(function(d,c){
return c[1]-d[1]}
);
for(i=0;
i<3&&i<sortable.length;
i++){
topThree.push(sortable[i][0])}
}
return topThree}
;

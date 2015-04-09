
//var gzprma_path = "http://192.168.139.79:8080";
//var gzprma_path = "http://120.197.57.227:8065";
//var gzprma_path = "http://218.207.179.241:60000";
var gzprma_path = "http://112.5.185.93:8086";

var AndroidPlatformVersion = "1.1.0";//Android设置版本号
var IOSPlatformVersion = "1.1.0";//Android设置版本号

function showResultPage(){  
	var IntpageNum = parseInt(document.getElementById("page").value);
	var Inttotalpage = parseInt(document.getElementById("totalpage").value);
	var pageNum = (IntpageNum + 1);
	if(Inttotalpage>=pageNum && pageNum > 0){
	 	if(document.getElementById("page").value != pageNum){
	 		document.getElementById('page').value=pageNum;
	 		return true;
		}
	 }
}

function setResultPage(pageNum, totalpage){
	document.getElementById('page').value=pageNum;
	document.getElementById('totalpage').value=totalpage;
}

function ajaxpostAction(flag,url,data,functionName){
	$.ajax({
		async:flag,
		type:"post",
		url : url,
		data:data,
		dataType:"string",
		success : function(data) {
			return functionName(data);
		}
	});
}

function showLoading(){
	$("#content2").html('<div style="text-align:center; padding-top:50%;"><img style="width: 5.875em;height:5.875em;" src="../images/oa_main/oa_loading.gif" /></div>');
}

function showNoResult(){
	/*<img style="width: 16.275em;height:3.9375em;" src="../images/oa_readlist/oa_zady.png" />*/
	$("#content").html('<div style="text-align:center; padding-top:50%;"><span style="font-size:1.5em;color:#9C9C9C;font-family: "Microsoft YaHei" ! important;">暂无数据</span></div>');
}
//清除时间
function clearDayById(controlId){
    
    $("#"+controlId).val("");
}




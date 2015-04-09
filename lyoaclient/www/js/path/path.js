//var gzprma_path = "http://120.197.57.227:8056";
//var gzprma_path = "http://192.168.41.51:7001";
//var gzprma_path = "http://120.197.57.227:8080";
//var gzprma_path = "http://202.104.65.179:7001";
//var gzprma_path = "http://202.104.65.179:10002";
//var gzprma_path = "http://127.0.0.1:8080";
var gzprma_path = "http://192.168.139.61:8080";
//var gzprma_path = "http://fhq5566.xicp.net:8080";

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
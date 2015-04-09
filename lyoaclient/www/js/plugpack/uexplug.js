var uexWindow = new Object();
uexWindow.alert = function(obj){    
   alert(obj);    
}

window.uexOnload = function(){

}

window.onload = function(){
	if(window.uexOnload){
		window.uexOnload(0);
	}
}

function ajaxAction(flag, url, success, dataType, error, type, data, bzd){
	$.ajax({
		async:flag,
		type:type,
		url : url,
		data:data,
		dataType:dataType,
		success : function(data) {
			return success(data);
		}
	});
}

jQuery.getJSON = function(url, success, dataType, error, type, data, bzd) {  
	var params = evalParams(data);
	ajaxAction(true, url, success, dataType, error, type, params, bzd);
}; 

function evalParams(param){
	if(param != null && param != ""){
		var data = "{";
		var dh = "'";
		$.each(param, function(i,item){
			var type = typeof item.value;
			var nullh = "";
			if(type == 'string'){
				nullh = dh;
			}
			data += "'" + item.key + "':" + nullh + item.value + nullh + ",";
		});
		data = data.substring(0, data.length - 1) + "}";
		return eval('(' + data + ')');
	}
	return {};
}

function $$(id){
	return document.getElementById(id);
}

function zy_init(){}

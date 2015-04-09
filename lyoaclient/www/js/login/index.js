$(document).ready(function(){
	var oStorage = readStorage();
	var u =  gzprma_path+"/gzdb/gzdbAction!getCountGzdb.do";
	$.ajax({
		type : "get" ,
		url : u ,
		data : {"e.relUser" : oStorage.id},
		beforeSend: function(XMLHttpRequest){},
		success: function(data, textStatus){
			
			if(data.gzdbCount > 0){
				$("#gzdbCount").hide();
				$("#gzdbCountImage").show();
				$("#gzdbCountImage").html(data.gzdbCount);
			}else{
				$("#gzdbCount").show();
				$("#gzdbCountImage").hide();
			}
		},
		complete: function(XMLHttpRequest, textStatus){},
		error: function(){}
	});
});
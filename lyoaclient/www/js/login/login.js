/**
 * 保存LocalStorage
 */
function saveStorage(id, userType) {
	window.localStorage.setItem("id", id);
	window.localStorage.setItem("userType", userType);
	return oStorage;
}

/**
 * 读取LocalStorage
 */
function readStorage() {
	var oStorage = window.localStorage;
	if (oStorage.getItem("id") != null && oStorage.getItem("id") != '' ) {
		return oStorage;
	}
	return "";
}

/**
 * 清除LocalStorage
 *
 */
function cleanStorage() {
	var oStorage = window.localStorage;
	if (oStorage.id) {
		oStorage.removeItem("id");
		oStorage.removeItem("userType");
	}
}

/**
 * 注销登录
 *
 */
function locationLogin(){
  	var logPath = gzprma_path + "/user/userAction!logOff.do";
	var platform = 1;//平台
	var platformVersion = window.AndroidClientJava.getVerName();
	var imei = window.AndroidClientJava.getImei();
    var loginid = localStorage.getItem("id");
  if (loginid != null && loginid != '') {
      var param = [{
          "key": "e.id",
          "type": "0",
          "value": loginid
      }, {
          "key": "e.imei",
          "type": "0",
          "value": imei
      }, {
			"key": "version",
			"type": "0",
			"value": platformVersion
	  }];
      $.getJSON(logPath, function(offData){
	  	localStorage.removeItem("id");
        localStorage.removeItem("userType");
		localStorage.removeItem("updateVersion");
		location.href = "login.html";
      }, 'json', function(e){}, 'POST', param, "");
  }else{
	localStorage.removeItem("id");
    localStorage.removeItem("userType");
	localStorage.removeItem("updateVersion");
	location.href = "login.html";
  }
}
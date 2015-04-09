function reachBottom() {     
	 var scrollTop = 0;
     var clientHeight = 0;
     var scrollHeight = 0;
     if (document.documentElement && document.documentElement.scrollTop) {
         scrollTop = document.documentElement.scrollTop;
     } else if (document.body) {
         scrollTop = document.body.scrollTop;
     }
     if (document.body.clientHeight && document.documentElement.clientHeight) {
         clientHeight = (document.body.clientHeight < document.documentElement.clientHeight) ? document.body.clientHeight: document.documentElement.clientHeight;
     } else {
         clientHeight = (document.body.clientHeight > document.documentElement.clientHeight) ? document.body.clientHeight: document.documentElement.clientHeight;
     }
     scrollHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
     if (scrollTop + clientHeight == scrollHeight) {
     	if (document.documentElement && document.documentElement.scrollTop) {
     		document.documentElement.scrollTop -= 10;
     	} else {
     		document.body.scrollTop -= 10;
     	}
         return true;
     } else {
         return false;
     }
 }





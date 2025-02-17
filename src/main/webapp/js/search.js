var url = "index.jsp?inc=./main"
var $id = function(id){ return document.getElementById(id) ; }

var search = {};
search.btn = function(){
	
	if($id('btnSearch')){
		$id('btnSearch').onclick = function(){
			let frm = $id('frmBody');
			frm.action = url + 'orderModify.jsp';
			frm.nowPage.value = 1;
			frm.submit();
		}
	}
	
}
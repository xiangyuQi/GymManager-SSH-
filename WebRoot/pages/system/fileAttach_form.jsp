<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en-us">	
	<head>
		<meta charset="utf-8">
		<base href="<%=basePath%>pages/system/">
	</head>
	<body>
		<div id="flashContent"></div>

		<script src="../../js/libs/jquery-2.1.1.min.js"></script>
		<script type="text/javascript" src="../../js/fileupload/swfobject.js"></script>
		<script>
		$(function() {
			// 传递到swfobject.js文件
			swfobject.basePath = '<%=path%>';
			
			var swfVersionStr = '10.0.0';
		    var xiSwfUrlStr = '../../js/fileupload/flexupload.swf';
		    var flashvars = {};
		    var params = {
		    	quality: 'high',
		    	bgcolor: '#ffffff',
		    	allowscriptaccess: 'sameDomain',
		    	allowfullscreen: 'true'
		    };
		    var attributes = {
		    	id: 'flexupload',
		    	name: 'flexupload',
		    	align: 'middle'
		    };
		    swfobject.embedSWF('../../js/fileupload/flexupload.swf', 'flashContent', 
		        '580', '250', swfVersionStr, xiSwfUrlStr, flashvars, params, attributes);
			});
		</script>
	</body>

</html>

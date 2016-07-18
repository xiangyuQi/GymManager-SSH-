<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en-us">	
	<head>
		<meta charset="utf-8">
		<base href="<%=basePath%>pages/system/">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/font-awesome.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/smartadmin-production-plugins.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/smartadmin-production.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/your_style.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap-datetimepicker.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap-select.min.css">
	</head>

<body>

<div class="container">
	<!-- row -->
	<div class="row">
		
		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div>
				<div class="widget-body">
					<form class="form-horizontal">
						<input type="hidden" name="id" value="${menu.id}">
	                    <table class="bs-table">
	                     	<tr>
	                     		<td width="70">上级菜单</td>
	                     		<td>
	                     			<c:if test="${empty menus}">
	                     				<input class="form-control" readonly="readonly" type="text" value="${menu.parent.name}"/>
	                     			</c:if>
	                     			<c:if test="${not empty menus}">
	                     				<select class="form-control" name="parentId">
	                     					<c:forEach var="m" items="${menus}">
	                     						<option value="${m[0]}">${m[1]}</option>
	                     					</c:forEach>
	                     				</select>		
	                     			</c:if>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">名称</td>
	                     		<td><input class="form-control" name ="name" type="text" value="${menu.name}"/></td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">图标</td>
	                     		<td>
	                     			<input name="iconCls" id="iconCls" type="hidden" value="${menu.iconCls}"/>
	                     			<i id="icon" class="${menu.iconCls}"></i>
	                     			<a id="selectIcon" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">链接</td>
	                     		<td><input class="form-control" name ="url" type="text" value="${menu.url}"/></td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">序号</td>
	                     		<td><input class="form-control" name ="sn" type="text" value="${menu.sn}"/></td>
	                     	</tr>
	                     </table>
					</form>
	
				</div>
			</div>
	
		</article>
		<!-- WIDGET END -->
		
	</div>
	<!-- end row -->
</div>

		<script src="../../js/libs/jquery-2.1.1.min.js"></script>
		<script src="../../js/bootstrap/bootstrap.min.js"></script>		
		<!-- JQUERY VALIDATE -->
		<script src="../../js/plugin/jquery-validate/jquery.validate.min.js"></script>
		
		<!--[if IE 8]>
			<h1>Your browser is out of date, please update your browser by going to www.microsoft.com/download</h1>
		<![endif]-->
		
		
		<script type="text/javascript">
		$(function() {
			$('#selectIcon').click(function() {
				// 传递的参数到子页面
				var icon = $('#icon').attr('class');
				top.layer.params = {
					activeIcon: icon
				};
				
				top.layer.open({
					type: 2,
					title: '图标选择器',
					content: '<%=path%>/pages/selector/icon_selector.jsp',
					area: ['720px', '620px'],
					maxmin: true,
					btn: ['确定', '取消'],
					btn1: function(index, layero) {
						var elm = top.layer.getChildFrame('li.active', index);
						var cls = elm.find('span:first').attr('class');						
						$('#icon').attr('class', cls);
						$('#iconCls').val(cls);
					}
				});
			});		
		});
		</script>

	</body>

</html>

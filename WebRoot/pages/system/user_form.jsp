<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/font-awesome.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/smartadmin-production-plugins.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/smartadmin-production.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/your_style.css">
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
						<input type="hidden" name="id" value="${user.id}">
	                    <table class="bs-table">	                     	
	                     	<tr>
	                     		<td width="80">账号：</td>
	                     		<td><input class="form-control" name ="uname" type="text" value="${user.uname}"/></td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">密码：</td>
	                     		<td><input class="form-control" name ="passwd" type="password" value="${user.passwd}"/></td>
	                     	</tr>	    	                     	
	                     	<tr>
	                     		<td width="80">姓名：</td>
	                     		<td><input class="form-control" name ="realName" type="text" value="${user.realName}"/></td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">性别：</td>
	                     		<td>
	                     			<k:dictSelect name="sex.id" itemName="性别" className="form-control" value="${user.sex.id}"/>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">部门：</td>
	                     		<td>
	                     			<input name="dept.id" id="deptId" type="hidden" value="${user.dept.id}">
	                     			<input id="deptName" value="${user.dept.dname}" readonly="readonly" class="form-control" style="width:80%;display:inline;float:left;"/>
	                     			<a href="javascript:selectDept()" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">角色：</td>
	                     		<td>
	                     			<input name="roleIds" id="roleIds" type="hidden" value="${user.roleIds}">
	                     			<textarea name="roleNames" id="roleNames" rows="4" readonly="readonly" class="form-control" style="width:80%;display:inline;float:left;">${user.roleNames}</textarea>
	                     			<a href="javascript:selectRoles()" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
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
	<script type="text/javascript">
		function selectDept() {
			// 传递的参数
			var id = $('#deptId').val();
			if(id) {
				top.layer.params = {
					selectId: id
				};
			}
		
			top.layer.open({
				type: 2,
				title: '部门选择器',
				content: '<%=path%>/pages/selector/dept_selector_single.jsp',
				area: ['420px', '620px'],
				maxmin: true,
				btn: ['确定', '取消'],
				yes: function(index, layero) {
					// 调用iframe页面中的函数
					var arr = layero.find('iframe')[0].contentWindow.getSelectDept();
					if(arr != null) {
						$('#deptId').val(arr[0]);
						$('#deptName').val(arr[1]);
						top.layer.close(index);
						return;	
					}
					top.layer.msg('请选择一条记录！', {icon: 5});		
				}
			});
		}
		
		// 选择多个角色
		function selectRoles() {
			var ids = $('#roleIds').val();
			if(ids) {
				var arr = ids.split(',');
				top.layer.params = {
					selectIds: arr
				};
			}			
			
			top.layer.open({
				type: 2,
				title: '角色选择器',
				content: '<%=path%>/pages/selector/role_selector.jsp',
				area: ['620px', '420px'],
				maxmin: true,
				btn: ['确定', '取消'],
				yes: function(index, layero) {
					var arr = layero.find('iframe')[0].contentWindow.getSelectRole();
					if(arr != null) {
						$('#roleIds').val(arr[0]);
						$('#roleNames').val(arr[1]);
						top.layer.close(index);
						return;	
					}
					top.layer.msg('请至少选择一条记录！', {icon: 5});					
				}
			});
		}
	</script>
	
	</body>

</html>

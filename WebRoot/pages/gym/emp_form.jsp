<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en-us">
<head>
<meta charset="utf-8">
<base href="<%=basePath%>pages/gym/">
<link rel="stylesheet" type="text/css" media="screen"
	href="../../css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" media="screen"
	href="../../css/your_style.css">
</head>

<!--
	The ID "widget-grid" will start to initialize all widgets below 
	You do not need to use widgets if you dont want to. Simply remove 
	the <section></section> and you can use wells or panels instead 
	-->
<body>

	<div class="container">
		<!-- row -->
		<div class="row">

			<!-- NEW WIDGET START -->
			<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div>
					<div class="widget-body">
						<form class="form-horizontal">
							<input type="hidden" name="id" value="${employee.id}">

							<table class="bs-table" >
							<tr>
	                     		<td width="70">选择照片</td>
	                     		<td colspan="2"> 
	                     			<input class="form-control" type="hidden" id="imgUrl" style="width:78%;display:inline;float:left;" name ="imgUrl" type="text" value="${employee.imgUrl}" readonly="readonly"/>
	                     			<img id="imgS" width="100" src="<%=path%>${employee.imgUrl}"/>
	                     			<a href="javascript:selectFileAttach()" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
	                     	</tr>
								<tr>
									<td width="80">姓名：</td>
									<td><input class="form-control" name="name" type="text"
										value="${employee.name}" /></td>
									<td width="80">性别：</td>
									<td><k:dictSelect name="sex.id" itemName="性别"
											className="form-control" value="${employee.sex.id}" /></td>
								</tr>
								<tr>
									<td width="80">年龄：</td>
									<td><input class="form-control" name="age" type="text"
										value="${employee.age}" /></td>
									<td width="80">电话：</td>
									<td><input class="form-control" name="phone" type="text"
										value="${employee.phone}" /></td>
								</tr>
								<tr >
	                     		<td width="80">部门：</td>
	                     		
	                     		<td >
	                     			<input name="dept.id" id="deptId" type="hidden" value="${employee.dept.id}">
	                     			<input id="deptName" name="dept.dname" value="${employee.dept.dname}" readonly="readonly" class="form-control" style="width:50%;display:inline;float:left;"/>
	                     			<a href="javascript:selectDept()"  class="btn btn-default" ><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     			<td width="80">职位：</td>
									<td><k:dictSelect id="test" name="job.id" itemName="职位"
										className="form-control" value="${employee.job.id}" /></td>
	                     			</td>
	                     			
	                     		</tr>
				
								<tr>
									<td width="80" >家庭住址：</td>
									<td colspan="3"><input class="form-control" name="address" 
										value="${employee.address}" /></td>
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
	<!-- 时间选择器 -->
	<script src="../../js/plugin/My97DatePicker/WdatePicker.js"></script>
	<!-- 部门选择器 -->
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
		// 选择附件
		function selectFileAttach() {
			top.layer.open({
				type: 2,
				title: '文件选择器',
				content: '<%=path%>/pages/selector/fileAttach_selector_pic.jsp',
				area: ['800px', '600px'],
				maxmin: true,
				btn: ['确定', '取消'],
				yes: function(index, layero) {
					// 获得值
					var arr = layero.find('iframe')[0].contentWindow.getUrl();
					if(arr.length == 0) {
						top.layer.msg('请选择一张图片');
						return;
					}
					$('#imgUrl').val(arr[0]);
					$('#imgS').attr('src', arr[0]);
					top.layer.close(index);
				}
			});	
		}
	
	</script>
</body>

</html>

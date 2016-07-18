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
							<input type="hidden" name="id" value="${card.id}">

							<table class="bs-table" >
								<tr>
									<td width="80">持卡人姓名：</td>
									<td ><input class="form-control" name="member.name" type="text" readonly="readonly"
										value="${card.member.name}" /></td>
									<td width="80">开卡金额：</td>
									<td ><input class="form-control" name="amount" type="text"
										value="${card.amount}" /></td>
								</tr>
								<tr>
	                     			<td width="90">会员卡卡号</td>
	                     			<td><input class="form-control" name="cardNo" type="text" value="${card.cardNo}"/></td>
	                     			<td width="90">会员卡等级</td>
	                     			<td>
	                     				<k:dictSelect name="level.id" itemName="会员卡" className="form-control" value="${card.level.id}"/>
	                     			</td>
	                     		</tr>
	                     		<tr>
	                     			<td width="70">开卡日期</td>
	                     			<td>
	                     				<input class="form-control" onfocus="WdatePicker()" id="beginTime" name="beginTime" type="text" value="<fmt:formatDate value="${card.beginTime}" pattern="yyyy-MM-dd"/>"/></td>
	                     			<td width="70">结束日期</td>
	                     			<td>
	              						<input class="form-control" onfocus="WdatePicker()" id="endTime" name="endTime" type="text" value="<fmt:formatDate value="${card.endTime}" pattern="yyyy-MM-dd"/>"/></td>
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
		
	
	</script>
</body>

</html>

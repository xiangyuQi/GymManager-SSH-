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
							<input type="hidden" name="id" value="${lockers.id}">

							<table class="bs-table" >
								<tr>
	                     		<td width="50">会员姓名</td>
	                     		<td colspan="3">
	                     			<input name="member.id" id="memberId" type="hidden" value="${lockers.member.id}">
	                     			<input id="memberName" value="${lockers.member.name}" readonly="readonly" class="form-control" style="width:80%;display:inline;float:left;"/>
	                     			<a href="javascript:selectMember()" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
	                     	</tr>
								<tr>
	                     			<td width="80">租柜编号</td>
	                     			<td><input class="form-control" name="no" type="text" value="${lockers.no}" /></td>
	                     			<td width="80">租用金额</td>
									<td ><input class="form-control" name="amount" type="text"
										value="${lockers.amount}" /></td>
	                     		</tr>
	                     		<tr>
	                     			<td width="80">租用日期</td>
	                     			<td>
	                     				<input class="form-control" onfocus="WdatePicker()" id="beginTime" name="beginTime" type="text" value="<fmt:formatDate value="${lockers.beginTime}" pattern="yyyy-MM-dd"/>"/></td>
	                     			<td width="80">结束日期</td>
	                     			<td>
	              						<input class="form-control" onfocus="WdatePicker()" id="endTime" name="endTime" type="text" value="<fmt:formatDate value="${lockers.endTime}" pattern="yyyy-MM-dd"/>"/></td>
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
		function selectMember() {
			// 传递的参数
			var id = $('#memberId').val();
			if(id) {
				top.layer.params = {
					selectId: id
				};
			}
		
			top.layer.open({
				type: 2,
				title: '会员选择器',
				content: '<%=path%>/pages/selector/member_selector.jsp',
				area: ['420px', '620px'],
				maxmin: true,
				btn: ['确定', '取消'],
				yes: function(index, layero) {
					// 调用iframe页面中的函数
					var arr = layero.find('iframe')[0].contentWindow.getSelectMember();
					if(arr != null) {
						$('#memberId').val(arr[0]);
						$('#memberName').val(arr[1]);
						top.layer.close(index);	
						return;	
					}
					top.layer.msg('请选择一位会员！', {icon: 5});		
				}
			});
		}
		
	
	</script>
</body>

</html>

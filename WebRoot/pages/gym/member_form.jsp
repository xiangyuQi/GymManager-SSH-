<%@page import="com.kzw.gym.entity.Lockers"%>
<%@page import="java.util.List"%>
<%@page import="com.kzw.core.util.spring.SpringContextHolder"%>
<%@page import="com.kzw.gym.service.LockersService"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html>
<html lang="en-us">	
	<head>
		<meta charset="utf-8">
		<base href="<%=basePath%>pages/gym/">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/your_style.css">
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
						<input type="hidden" name="id" value="${member.id}">
						<input type="hidden" name="card.id" value="${member.card.id}">
	                     <table class="bs-table">
	                     <tr>
	                     		<td width="70">选择照片</td>
	                     		<td colspan="2"> 
	                     			<input class="form-control" type="hidden" id="imgUrl" style="width:78%;display:inline;float:left;" name ="imgUrl" type="text" value="${member.imgUrl}" readonly="readonly"/>
	                     			<img id="imgS" width="100" src="<%=path%>${member.imgUrl}" style="width:120px;"/>
	                     			<a href="javascript:selectFileAttach()" class="btn btn-default"><span class="glyphicon glyphicon-search"></span> 选择</a>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">姓名</td>
	                     		<td><input class="form-control" name="name" type="text" value="${member.name}"/></td>
	                     		<td width="70">性别</td>
	                     		<td>
	                     			<k:dictSelect name="sex.id" itemName="性别" className="form-control" value="${member.sex.id}"/>
	                     		</td> 
	                     	</tr>
	                      	<tr>
	                     		<td width="70">年龄</td>
	                     		<td><input class="form-control" name="age" type="text" value="${member.age}"/></td>
	                     		<td width="70">联系方式</td>
	                     		<td><input class="form-control" name="phone" type="text" value="${member.phone}"/></td>
	                     	</tr>
	                     	<tr>
	                     		<td width="70">身高</td>
	                     		<td><input class="form-control" name="height" type="text" value="${member.height}"/></td>
	                     		<td width="70">体重</td>
	                     		<td><input class="form-control" name="weight" type="text" value="${member.weight}"/></td>
	                     	</tr>
	                 
	                     	 <tr>
	                     	 	<td width="90">会员卡卡号</td>
	                     		<td><input class="form-control" name="card.cardNo" type="text" value="${member.card.cardNo}" /></td>
	                     		<td width="90">会员卡等级</td>
	                     		<td>
	                     			<k:dictSelect name="card.level.id" itemName="会员卡" className="form-control" value="${member.card.level.id}"/>
	                     		</td>
	                     	</tr>
	                     	
	                     		 <tr>
	                     		<td width="70">开卡日期</td>
	                     		<td>
	                     			<input class="form-control" onfocus="WdatePicker()" id="card.beginTime" name="card.beginTime" type="text" value="<fmt:formatDate value="${member.card.beginTime}" pattern="yyyy-MM-dd"/>"/></td>
	                     		<td width="70">结束日期</td>
	                     		<td>
	              					<input class="form-control" onfocus="WdatePicker()" id="card.endTime" name="card.endTime" type="text" value="<fmt:formatDate value="${member.card.endTime}" pattern="yyyy-MM-dd"/>"/></td>
	                     		</td>
	                     	</tr>
	                     	 <tr>
	                     		<td width="90">开卡金额</td>
	                     		<td><input class="form-control" name="card.amount" type="text" value="${member.card.amount}"/></td>
	                
	                     	</tr>
	                   
	                    <!--  
	                    <c:if test="${not empty member}">
	                     	<input type="hidden" name="card.cardNo" value="${member.card.cardNo}">
	                     	<input type="hidden" name="card.level.id" value="${member.card.level.id}">
	                    	<input type="hidden" name="card.amount" value="${member.card.amount}">
	                    	<input id="card.endTime" name="card.endTime" type="hidden" value="<fmt:formatDate value="${member.card.endTime}" pattern="yyyy-MM-dd"/>"/></td>
	                    	<input id="card.beginTime" name="card.beginTime" type="hidden" value="<fmt:formatDate value="${member.card.beginTime}" pattern="yyyy-MM-dd"/>"/></td>
	                    </c:if>-->
	                  
	                   
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
		<!-- 附件选择器 -->
	<script src="../../js/libs/jquery-2.1.1.min.js"></script>
	<script type="text/javascript">
		
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

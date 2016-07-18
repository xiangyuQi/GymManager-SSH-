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
						<input type="hidden" name="id" value="${dept.id}">
	                    <table class="bs-table">
	                     	<tr>
	                     		<td width="80">上级部门：</td>
	                     		<td>
	                     			<c:if test="${empty depts}">
	                     				<input class="form-control" readonly="readonly" type="text" value="${dept.parent.dname}"/>
	                     			</c:if>
	                     			<c:if test="${not empty depts}">	               	      				
	                     				<select class="form-control" name="parentId">
	                     					<c:forEach var="m" items="${depts}">
	                     						<option value="${m[0]}">${m[1]}</option>
	                     					</c:forEach>
	                     				</select>
	                     			</c:if>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">名称：</td>
	                     		<td><input class="form-control" name ="dname" type="text" value="${dept.dname}"/></td>
	                     	</tr>	                     	
	                     	<tr>
	                     		<td width="80">描述：</td>
	                     		<td>
	                     			<textarea class="form-control" rows="4" name="note">${dept.note}</textarea>
	                     		</td>
	                     	</tr>
	                     	<tr>
	                     		<td width="80">序号：</td>
	                     		<td><input class="form-control" name ="sn" type="text" value="${dept.sn}"/></td>
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
	</body>

</html>

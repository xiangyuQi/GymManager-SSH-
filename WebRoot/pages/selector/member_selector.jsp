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
		<base href="<%=basePath%>pages/selector/">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/smartadmin-skins.min.css">
		
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/jqgrid/ui.jqgrid-bootstrap.css">
		<link rel="stylesheet" type="text/css" media="screen" href="../../css/your_style.css">
	</head>
<body>

<section id="deptSelector" class="container">
	<div class="row">
		<div class="col-xs-12 well">
		<form id="form-search" class="form-inline" method="post">
			<table>
				<tr>
					<td>
						会员名称 <input type="text" style="width:120px;height:30px;" name="Q_LKS_name">
		  				<a id="btn-submit" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-search"></span> 查询</a>
		  				<a id="btn-clear" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-remove"></span> 清除</a>
					</td>
				</tr>
			</table>
		  	
		</form>
		</div>
	</div>
	
	<!-- row -->
	<div class="row">
		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">			
			<table id="jqgrid"></table>
		</article>
		<!-- WIDGET END -->
	</div>
	<!-- end row -->
	
</section>

		<script src="../../js/libs/jquery-2.1.1.min.js"></script>
		<script src="../../js/bootstrap/bootstrap.min.js"></script>
		<!-- jqGrid -->
		<script src="../../js/plugin/jqgrid/jquery.jqGrid.min.js"></script>
		<script src="../../js/plugin/jqgrid/grid.locale-cn.js"></script>
		<script src="../../js/KeExt.js"></script>
		
		<script type="text/javascript">
		//获得父窗口的变量
		var params = parent.layer.params || {};
		
		var grid   = $('#jqgrid');
		var searchForm = $('#form-search');
		var submitBtn  = $('#btn-submit');
		var clearBtn   = $('#btn-clear');
	
		$(function() {
			grid.jqGrid({
				height: 340,
				url: '<%=path%>/member/list',
				caption: '<i class="glyphicon glyphicon-list"></i> 角色列表',
				colModel: [
					{label: 'ID', name: 'id', hidden: true, key: true},
					{label: '会员姓名', name: 'name', width: 100},
				],
				multiselect: false,
				gridComplete: function() { //当grid初始化完成
					if(params.selectIds) {
						$.each(params.selectIds, function(i, v) {
							grid.jqGrid('setSelection', v);
						});
					}
				}
			});	
			
			// 查询
			submitBtn.click(function() {
				var params = searchForm.serializeObject();
				var postData = grid.jqGrid('getGridParam', 'postData') || {};
				$.extend(postData, params);
				grid.jqGrid('setGridParam', {postData: postData}).trigger("reloadGrid");
			});
			// 清除
			clearBtn.click(function() {
				searchForm[0].reset();
			});	
			
			// end jquery
		});
		
		// 获得选中项
		function getSelectMember() {
			var rowid = grid.jqGrid('getGridParam', 'selrow');
			if(!rowid) return null;
			
			var rec = grid.jqGrid('getRowData', rowid);
			return [rec.id, rec.name];
		}
		
		</script>

	</body>

</html>

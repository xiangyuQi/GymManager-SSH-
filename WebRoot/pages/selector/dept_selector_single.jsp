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
						部门名称 <input type="text" style="width:120px;height:30px;" name="Q_LKS_dname">
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
			<div class="text-left" style="margin-bottom: 5px;">
				<a id="doExpand" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-triangle-bottom"></span> 全部展开</a>
				<a id="doCollaps" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-triangle-right"></span> 全部折叠</a>
				<a id="doRefresh" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-refresh"></span> 刷 新</a>
			</div>
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
				url: '<%=path%>/dept/list',
				colModel: [
					{label:'ID', name: 'id', hidden: true, key: true},
					{label: '部门名称', name: 'dname', width: 100, sortable:false}
				],
				height: params.height || 350,
				pager: '#pager',
				
				multiselect: false,
				treeGrid: true,
				treeIcons: {leaf: 'glyphicon-link'},
				rownumbers: false,	//treeGrid：必须设置成false
				ExpandColumn: 'dname',
				ExpandColClick: false,
				treeGridModel: "adjacency", //使用parent_id时需要使用该模式
				treeReader: {
					level_field: "level",
				   	parent_id_field: "parentId", 
				   	leaf_field: "leaf"
				},
				gridComplete: function() { //当grid初始化完成
					if(params.selectId) {
						grid.jqGrid('setSelection', params.selectId);
					}
				}
			});		
			$('.ui-th-div').css('height', 24);
						
			
			// 查询
			submitBtn.click(function() {
				var params = searchForm.serializeObject();
				var postData = grid.jqGrid('getGridParam', 'postData') || {};
				$.extend(postData, params);
				grid.jqGrid('setGridParam', {postData: postData}).trigger("reloadGrid", [{page: 1}]);
			});
			// 清除
			clearBtn.click(function() {
				searchForm[0].reset();
			});			
		
			// 全部打开
			$('#doExpand').click(function() {
				var nodes = grid.jqGrid('getRootNodes');
				for(var i=0; i<nodes.length; i++) {
					grid.expandNode(nodes[i]);
					grid.expandRow(nodes[i]);
				}
			});
			// 全部折叠
			$('#doCollaps').click(function() {
				var nodes = grid.jqGrid('getRootNodes');
				for(var i=0; i<nodes.length; i++) {
					grid.collapseNode(nodes[i]);
					grid.collapseRow(nodes[i]);
				}
			});
			// end jquery
		});
		
		// 获得选中项
		function getSelectDept() {
			var rowid = grid.jqGrid('getGridParam', 'selrow');
			if(!rowid) return null;
			
			var rec = grid.jqGrid('getRowData', rowid);
			return [rec.id, rec.dname];
		}
		
		</script>

	</body>

</html>

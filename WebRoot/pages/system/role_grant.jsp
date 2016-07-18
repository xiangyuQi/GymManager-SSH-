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

<section id="nodeSelector" class="container">
	
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
		<script src="../../js/plugin/jqgrid/jquery.jqGrid.min.js"></script>
		<script src="../../js/plugin/jqgrid/grid.locale-cn.js"></script>
		<script src="../../js/KeExt.js"></script>
		
		<script type="text/javascript">
		//获得父窗口的变量
		var params = parent.layer.params || {};
		
		var grid   = $('#jqgrid');
		$(function() {
			grid.jqGrid({
				url: '<%=path%>/menu/list',
				caption: '<span class="glyphicon glyphicon-list"></span> 菜单列表',
				colModel: [
					{label:'id', name: 'id', hidden: true},
					{label:'name', name: 'name', hidden: true},
					{label: '菜单名', name: 'sn', width: 70, sortable:false, formatter: showName}
				],
				hidegrid: false,
				height: 410,
				
				multiselect: false,
				treeGrid: true,
				treeIcons: {leaf: ''},
				rownumbers: false,	//treeGrid：必须设置成false
				ExpandColumn: 'sn',
				ExpandColClick: false,
				treeGridModel: "adjacency", //使用parent_id时需要使用该模式
				treeReader: {
					level_field: "level",
				   	parent_id_field: "parentId", 
				   	leaf_field: "leaf"
				},
				gridComplete: function() {
					$(this).closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').remove();
					// 选中
					if(params.selectIds) {
						setSelectNode(params.selectIds);
					}
				}
			});
			// 给treeGrid增加多选框
			function showName(v, options, row) {
			    var rowId = row.id;
			    var name = row.name;
			    var checkbox = '<input type="checkbox" name="cb" id="chx_'+rowId+'" class="ace" value="'+rowId+'" onclick="clickCheckbox('+rowId+', this);" />'+
	                     	   ' <i class="'+row.iconCls+'"></i> '+ name;
			    return checkbox ; 
			}
			
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
		
		//checkbox事件
		function clickCheckbox(rowid, $this) {
		    checkChildren(rowid, $this);
		   	checkParent(rowid, $this);
		};
		//递归选中子节点
		function checkChildren(rowid, $this){
          	var records = grid.jqGrid('getNodeChildren', grid.jqGrid("getLocalRow", rowid));
          	if(records.length>0){
	           	for (var i=0;i<records.length;i++){
	            	var cb = $("#chx_"+records[i].id);
	            	cb[0].checked = $this.checked;
	        		checkChildren(records[i].id, cb);
	           	}
          	}
		}
		//递归选中父节点
		function checkParent(rowid, $this){
			var parent = grid.jqGrid('getNodeParent', grid.jqGrid("getLocalRow", rowid));
		    if(parent){
		   		var cb = $("#chx_"+parent.id);
		   		if($this.checked && !(cb[0].ckecked)) {
			       	cb[0].checked = $this.checked;
			   		checkParent(parent.id, cb);
		   		}
		   	}
		}
		
		// 获得选中值, 是否显示非叶子结点
		function getSelectNode(isLeaf) {
			var ids = [];
			$("input[name=cb]:checked").each(function() {
				ids.push($(this).val());
			});
			
			var nodeIds=[], nodeNames=[];
			for(var i=0; i<ids.length; i++) {
				var obj = grid.getRowData(ids[i]);
				// 是否显示非叶子结点
				if(isLeaf) {
					if(obj.leaf==true || obj.leaf=='true') {
						nodeIds.push(obj.id);
						nodeNames.push(obj.name);
					}
				} else {
					nodeIds.push(obj.id);
					nodeNames.push(obj.name);
				}
			}
			
			var retval = [];
			retval[0] = nodeIds.join(',');
			retval[1] = nodeNames.join(', ');
			return retval;
		}
		
		// 初始化
		function setSelectNode(ids) {
			var arr = ids.split(',');
			for(var i=0; i<arr.length; i++) {
				if(/^\d+$/.test(arr[i])) {
					var cb = $("#chx_"+arr[i]);
					cb[0].checked = true;
					checkParent(arr[i], cb[0]);
				}
			}
		}
		</script>

	</body>

</html>

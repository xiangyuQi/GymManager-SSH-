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
		<!--  
		<script src="../../js/plugin/jqgrid/src/jquery.jqGrid.js"></script>
		-->
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
				caption: '<span class="glyphicon glyphicon-list"></span> 部门信息列表',
				colModel: [
					{label:'id', name: 'id', hidden: true},
					{label:'dname', name: 'dname', hidden: true},
					{label: '部门名称', name: 'note', width: 100, sortable:false, formatter: showDname}
				],
				hidegrid: false,
				height: params.height || 350,
				
				multiselect: false,
				treeGrid: true,
				treeIcons: {leaf: 'glyphicon-link'},
				rownumbers: false,	//treeGrid：必须设置成false
				ExpandColumn: 'note',
				ExpandColClick: false,
				treeGridModel: "adjacency", //使用parent_id时需要使用该模式
				treeReader: {
					level_field: "level",
				   	parent_id_field: "parentId", 
				   	leaf_field: "leaf"
				},
				gridComplete: function() {
					$(this).closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').remove();
					if(params.selectDeptIds) {
						setSelectDept(params.selectDeptIds);
					}
				}
			});
			// 给treeGrid增加多选框
			function showDname(v, options, row) {
			    var rowId = row.id;
			    var dname = row.dname;
			    var checkbox = '<input type="checkbox" name="cb" id="chx_'+rowId+'" class="ace" value="'+rowId+'" onclick="clickCheckbox('+rowId+', this);" />'+
	                     	   '<span class="lbl align-top" ></span> '+ dname;
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
		function getSelectDept(isNotLeaf) {
			var ids = [];
			$("input[name=cb]:checked").each(function() {
				ids.push($(this).val());
			});
			
			var deptIds=[], deptNames=[];
			for(var i=0; i<ids.length; i++) {
				var obj = grid.getRowData(ids[i]);
				// 是否显示非叶子结点
				if(isNotLeaf) {
					if(obj.leaf==true || obj.leaf=='true') {
						deptIds.push(obj.id);
						deptNames.push(obj.dname);
					}
				} else {
					deptIds.push(obj.id);
					deptNames.push(obj.dname);
				}
			}
			
			var retval = [];
			retval[0] = deptIds.join(',');
			retval[1] = deptNames.join(',');
			return retval;
		}
		
		// 初始化
		function setSelectDept(ids) {
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

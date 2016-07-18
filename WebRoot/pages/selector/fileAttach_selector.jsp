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
		<style>
		.layout {
			height: 500px;
			padding-top: 10px;
		}
		</style>
	</head>
<body>

<!-- widget grid -->
<section id="fileAttach-widget" class="container">
	<!-- row -->
	<div class="layout row">
		<div class="ui-layout-west">
			<div class="text-left" style="margin-bottom: 5px;">
				<a class="btn btn-default btn-sm doExpand"><span class="glyphicon glyphicon-triangle-bottom"></span> 全部展开</a>
				<a class="btn btn-default btn-sm doCollaps"><span class="glyphicon glyphicon-triangle-right"></span> 全部折叠</a>
				<a class="btn btn-primary btn-sm doRefresh"><span class="glyphicon glyphicon-arrow-up"></span>上传文件</a>
			</div>
			<table id="tree-fileAttach-grid"></table>
		</div>
				
		
		<!-- NEW WIDGET START -->
		<div class="ui-layout-center">
			<table id="fileAttach-grid"></table>
			<div id="fileAttach-pager"></div>
		</div>
		<!-- WIDGET END -->
		
	</div>

	<!-- end row -->

</section>
<!-- end widget grid -->

<script src="../../js/libs/jquery-2.1.1.min.js"></script>
<script src="../../js/bootstrap/bootstrap.min.js"></script>
<script src="../../js/plugin/jqgrid/jquery.jqGrid.min.js"></script>
<script src="../../js/plugin/jqgrid/grid.locale-cn.js"></script>
<script src="../../js/KeExt.js"></script>
		
<script type="text/javascript" src="../../js/plugin/jquery-layout/jquery.layout-latest.js"></script>
<script type="text/javascript">
	 
	/* DO NOT REMOVE : GLOBAL FUNCTIONS!
	 *
	 * pageSetUp(); WILL CALL THE FOLLOWING FUNCTIONS
	 *
	 * // activate tooltips
	 * $("[rel=tooltip]").tooltip();
	 *
	 * // activate popovers
	 * $("[rel=popover]").popover();
	 *
	 * // activate popovers with hover states
	 * $("[rel=popover-hover]").popover({ trigger: "hover" });
	 *
	 * // activate inline charts
	 * runAllCharts();
	 *
	 * // setup widgets
	 * setup_widgets_desktop();
	 *
	 * // run form elements
	 * runAllForms();
	 *
	 ********************************
	 *
	 * pageSetUp() is needed whenever you load a page.
	 * It initializes and checks for all basic elements of the page
	 * and makes rendering easier.
	 *
	 */

	// pageSetUp();
	
	/*
	 * ALL PAGE RELATED SCRIPTS CAN GO BELOW HERE
	 * eg alert("my home function");
	 * 
	 * var pagefunction = function() {
	 *   ...
	 * }
	 * loadScript("js/plugin/_PLUGIN_NAME_.js", pagefunction);
	 * 
	 */
	 $(function() {
		$('#fileAttach-widget .layout').layout({
			west: {
				size: 265,
				resizable: false,
				spacing_closed: 10,	//关闭后的宽度
				togglerAlign_closed: 'top',
				togglerTip_open: "隐藏左侧区域",
				togglerTip_closed: "打开左侧区域"
			 }
		});
			 
	});
	 
	$(function() {
		// 查询
		var widget = $('#fileAttach-widget');
		var grid   = $('#fileAttach-grid');
		var searchForm = widget.find('.form-search');
		var submitBtn  = searchForm.find('.btn-submit');
		var clearBtn   = searchForm.find('.btn-clear');
		
		// JS加载完成之后
		grid.jqGrid({
			url: '<%=path%>/fileAttach/list',
			caption: '<span class="glyphicon glyphicon-list"></span> 附件信息列表',
			colModel: [
				{label: 'ID', name: 'fileId', hidden: true},
				{label: '文件名称', name: 'fileName', width: 280},
				{label: '创建时间', name: 'createtime', width: 100}
			],
			height: 370,
			pager: '#fileAttach-pager'
		});
		
		
		var treeGrid   = $('#tree-fileAttach-grid');
		treeGrid.jqGrid({
			url: '<%=path%>/department/list',
			caption: '<span class="glyphicon glyphicon-list"></span> 部门信息列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true},
				{label: '部门名称', name: 'dname', width: 100, sortable:false}
			],
			hidegrid: false,
			height: 410,
			
			multiselect: false,
			treeGrid: true,
			treeIcons: {leaf: 'glyphicon-link'},
			rownumbers: false,	//treeGrid：必须设置成false
			ExpandColumn: 'dname',
			ExpandColClick: true,
			treeGridModel: "adjacency", //使用parent_id时需要使用该模式
			treeReader: {
				level_field: "deepth",
			   	parent_id_field: "parentId", 
			   	leaf_field: "leaf"
			},
			gridComplete: function() {
				//隐藏或删除表头
			  	$(this).closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').remove();
			}
		});
		// 全部打开
		widget.find('.doExpand').click(function() {
			debugger
			var nodes = treeGrid.jqGrid('getRootNodes');
			for(var i=0; i<nodes.length; i++) {
				treeGrid.expandNode(nodes[i]);
				treeGrid.expandRow(nodes[i]);
			}
		});
		// 全部折叠
		widget.find('.doCollaps').click(function() {
			debugger
			var nodes = treeGrid.jqGrid('getRootNodes');
			for(var i=0; i<nodes.length; i++) {
				treeGrid.collapseNode(nodes[i]);
				treeGrid.collapseRow(nodes[i]);
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
		
		// "增加"弹出框
		function addfunc() {
			layer.params = {
				fileTypeId: 1,	//左侧树选择的值
				fileCat: 'test/pic',
				grid: grid
			};
			layer.open({
				type: 2,
				title: '<span class="glyphicon glyphicon-arrow-up"></span> 文件上传',
				area: ['600px', '360px'],
			    content: '<%=path%>/pages/system/fileAttach_form.jsp',
			    btn: ['关闭'],
			    btn1: function() {
			    	grid.trigger('reloadGrid');
			    },
			    success: function(layero, index) {
			    	// TODO: 刷新一次, 仍没有完全解决问题
			    	var iframeWin = layero.find('iframe')[0].contentWindow;
			    	var url = iframeWin.location.href;
					var times = url.split("?");
					if(times[1] != 1){
						url += "?1";
						iframeWin.location.replace(url);
					}
			    }
			});		
		}	
		
		// end jquery
	});
	
</script>

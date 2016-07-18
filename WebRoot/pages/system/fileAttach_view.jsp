<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->


<!--
	The ID "widget-grid" will start to initialize all widgets below 
	You do not need to use widgets if you dont want to. Simply remove 
	the <section></section> and you can use wells or panels instead 
-->
<style>
.layout {
	height: 600px;
	padding: 0 10px;
}
.ui-layout-west, .ui-layout-center {
	padding-right: 10px;
}
</style>
<!-- widget grid -->
<section id="fileAttach-widget" class="">
	<div class="row">
		<div class="col-md-12 well">
		<form class="form-inline form-search" method="post">
			<div class="form-group">
		    	文件名称  <input type="text" style="width:120px;" class="form-control" name="Q_LKS_fileName">
		  	</div>
		  	<div class="form-group">
		    	创建时间 <input type="text" style="width:120px;" class="form-control" onfocus="WdatePicker()" name="Q_GED_createTime">
		    	至 <input type="text" style="width:120px;" class="form-control" onfocus="WdatePicker()" name="Q_LED_createTime">
		  	</div>
		  	<a class="btn btn-primary btn-sm btn-submit"><span class="glyphicon glyphicon-search"></span> 查询</a>
		  	<a class="btn btn-default btn-sm btn-clear"><span class="glyphicon glyphicon-remove"></span> 清除</a>
		</form>
		</div>
	</div>
	<!-- row -->
	<div class="layout row">
		<div class="ui-layout-west">
			<div class="text-left" style="margin-bottom: 5px;">
				<a class="btn btn-default btn-sm doExpand"><span class="glyphicon glyphicon-triangle-bottom"></span> 全部展开</a>
				<a class="btn btn-default btn-sm doCollaps"><span class="glyphicon glyphicon-triangle-right"></span> 全部折叠</a>
				<a class="btn btn-default btn-sm doRefresh"><span class="glyphicon glyphicon-refresh"></span> 刷 新</a>
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

<script type="text/javascript" src="js/plugin/jquery-layout/jquery.layout-latest.js"></script>
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
			url: 'fileAttach/list',
			caption: '<span class="glyphicon glyphicon-list"></span> 附件信息列表',
			colModel: [
				{label: 'ID', name: 'fileId', hidden: true},
				{label: '文件名称', name: 'fileName', width: 100},
				{label: '文件路径', name: 'filePath', width: 200},
				{label: '创建时间', name: 'createtime', width: 100},
				{label: '附件类型', name: 'fileType', width: 100},
				{label: '创建者姓名', name: 'creator', width: 100},
				{label: '文件大小', name: 'totalBytes', width: 100},
				{label: '文件类型', name: 'globalType.typeName', width: 100},
				{label: '是否删除', name: 'delFlag', width: 100, formatter: function(v) {
					if(v==1) return '<a style="cursor:default;" class="btn btn-danger btn-xs">已删除</a>';
					return '<a style="cursor:default;" class="btn btn-success btn-xs">正常</a>';
				}}
				
			],
			pager: '#fileAttach-pager'
		});
		grid.navGrid('#fileAttach-pager',
			{addfunc: addfunc,edit:false, search:false,
			addtext:'增加', deltext:'删除', refreshtext:'刷新'}
		);
		
		
		var treeGrid   = $('#tree-fileAttach-grid');
		treeGrid.jqGrid({
			url: 'dept/list',
			caption: '<span class="glyphicon glyphicon-list"></span> 部门信息列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true},
				{label: '部门名称', name: 'dname', width: 100, sortable:false}
			],
			hidegrid: false,
			
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
			    content: 'pages/system/fileAttach_form.jsp',
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
		// "删除"功能
		function del(rowid) {
			layer.confirm('确定删除该条记录吗？', {icon:3, title:'温馨提示'}, function(index) {
				$.getJSON('./fileAttach/del/' + rowid, function(json) {
					if(json.success) {
						grid.trigger("reloadGrid", [{page: 1}]);
		    			layer.msg('操作成功！', {icon: 1});		
					} else {
						layer.msg('操作失败！', {icon: 2});					
					}
				});
				layer.close(index);
			});
		}
		
		// end jquery
	});
	
</script>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->

<!--
	The ID "widget-grid" will start to initialize all widgets below 
	You do not need to use widgets if you dont want to. Simply remove 
	the <section></section> and you can use wells or panels instead 
-->

<!-- widget grid -->
<section id="widget-grid" class="">
	<div class="row">
		<div class="well" style="margin-left: 15px;">
		<form id="form-search" class="form-inline" method="post">
  			<div class="form-group">
		    	会员姓名: <input type="text" style="width:120px;" class="form-control" name="Q_LKS_member.name">
		  	</div>
		  	<div class="form-group">
		    	租柜编号: <input type="text" style="width:120px;" class="form-control" name="Q_LKS_no">
		  	</div>
		  	
		  	<a id="btn-submit" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-search"></span> 查询</a>
		  	<a id="btn-clear" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-remove"></span> 清除</a>
		</form>
		</div>
	</div>
	<!-- row -->
	<div class="row">
		
		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<table id="jq_grid"></table>
				<div id="jq_paper"></div>
		</article>
		<!-- WIDGET END -->
		
	</div>

	<!-- end row -->

</section>
<!-- end widget grid -->

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
	var grid   = $('#jq_grid');
	var searchForm = $('#form-search');
	var submitBtn  =$('#btn-submit');
	var clearBtn   = $('#btn-clear');
	$(function() {
		// JS加载完成之后
		grid.jqGrid({
			height: $(document).height() - 300,
			url: 'lockers/list',
			caption: '<i class="glyphicon glyphicon-list"></i>私人租柜列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true, key: true},
				{label: '操作', name: 'id', width: 20, formatter: function(v) {
					return  '<a href="javascript:clearfunc('+v+')" style="margin-left:10px;" class="btn btn-danger btn-xs">置空</a>';			
				}},
				{label: '会员姓名', name: 'member.name', width: 30, editable: true},
				{label: '租柜号', name: 'no', width: 50},
				{label: '租用日期', name: 'beginTime', width: 50},
				{label: '到期日期', name: 'endTime', width: 50},
				{label: '租用金额', name: 'amount', width: 30,},
			],
			pager: '#jq_paper',
			multiboxonly: true,
			ondblClickRow: editfunc
		});
		grid.navGrid('#jq_paper',
			{addfunc: addfunc, editfunc: editfunc, delfunc:delfunc, search: false,
			addtext:'增加', edittext:'编辑', deltext:'删除', refreshtext:'刷新'},
			{},
			{},
			{},
			{},
			{}
		);
		
		
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
		top.layer.params = {};
			layer.open({
				type: 2,
				title: '租柜信息详情',
				area: ['500px', '260px'],
				maxmin: true,
			    content: ['pages/gym/lockers_form.jsp', 'yes'],
			    btn: ['保存', '关闭'],
			    btn1: function(index, layero) {
			    	var form = layer.getChildFrame('form', index);
			    	$.post('./lockers/save', form.serialize(), function(json){
			    		//刷新表格
			    		if(json.success) {
			    			grid.trigger("reloadGrid", [{page: 1}]);
			    			layer.msg('保存成功', {icon: 1});
			    		} else {
			    			layer.msg('保存失败', {icon: 2});
			    		}
			    	}, 'json');
			    }
			});		
		}
		// end jquery
	});
	
	// "编辑"弹出框
	function editfunc(rowid) {
	top.layer.params = {};
		//获得编辑行, 只能选中一行
		layer.open({
			type: 2,
			title: '租柜信息修改',
			area: ['500px', '260px'],
			maxmin: true,
		    content: './lockers/get/' + rowid,
		    btn: ['保存', '关闭'],
		    btn1: function(index, layero) {
		    	var form = layer.getChildFrame('form', index);
		    	$.post('./lockers/save', form.serialize(), function(json){
		    		if(json.success) {
		    			grid.trigger("reloadGrid", [{page: 1}]);
		    			layer.msg('保存成功', {icon: 1});
		    		} else {
		    			layer.msg('保存失败', {icon: 2});
		    		}		    		
		    	}, 'json');
		    }
		});		
	}
	
	// "删除"功能
	function delfunc(rowid) {
		layer.confirm('确定删除该条记录吗？', {icon:3, title:'温馨提示'}, function(index) {
			$.getJSON('./lockers/del', {ids: rowid+''}, function(json) {
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
	
	function clearfunc(rowid) {
		layer.confirm('确定置空租柜吗？', {icon:3, title:'温馨提示'}, function(index) {
			$.getJSON('./lockers/clear/'+rowid, function(json) {
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
	
</script>

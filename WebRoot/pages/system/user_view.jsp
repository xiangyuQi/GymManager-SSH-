<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->

<!-- widget grid -->
<section id="widget-widget" class="">
	<div class="row">
		<div class="well" style="margin-left: 15px;">
		<form id="form-search" class="form-inline" method="post">
  			<div class="form-group">
		    	账号 <input type="text" style="width:120px;" class="form-control" name="Q_LKS_uname">
		  	</div>		  	
		  	<div class="form-group">
		    	姓名 <input type="text" style="width:120px;" class="form-control" name="Q_LKS_realName">
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
			<table id="jqgrid"></table>
			<div id="pager"></div>
		</article>
		<!-- WIDGET END -->
	</div>

	<!-- end row -->

</section>
<!-- end widget grid -->

<script type="text/javascript">

	var grid   = $('#jqgrid');
	var searchForm = $('#form-search');
	var submitBtn  = $('#btn-submit');
	var clearBtn   = $('#btn-clear');
	$(function() {
		// JS加载完成之后
		grid.jqGrid({
			height: $(document).height() - 300,
			url: 'user/list',
			caption: '<i class="glyphicon glyphicon-list"></i> 用户列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true, key: true},
				{label: '操作', name: 'id', width: 100, formatter: function(v) {
					return '<a href="javascript:editfunc('+v+')" class="btn btn-primary btn-xs">编 辑</a>' +
							'<a href="javascript:delfunc('+v+')" style="margin-left:10px;" class="btn btn-danger btn-xs">删 除</a>';			
				}},
				{label: '账号', name: 'uname', width: 100},
				{label: '姓名', name: 'realName', width: 100},
				{label: '性别', name: 'sex.itemValue', width: 100},
				{label: '部门', name: 'dept.dname', width: 100}
			],
			pager: '#pager',
			multiboxonly: true,
			ondblClickRow: editfunc
		});
		grid.navGrid('#pager',
			{addfunc: addfunc, editfunc: editfunc, delfunc:delfunc, search: false,
			addtext:'增加', edittext:'编辑', deltext:'删除', refreshtext:'刷新'}
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
				title: '用户信息详情',
				area: ['600px', '480px'],
				maxmin: true,
			    content: ['pages/system/user_form.jsp', 'yes'],
			    btn: ['保存', '关闭'],
			    btn1: function(index, layero) {
			    	var form = layer.getChildFrame('form', index);
			    	$.post('./user/save', form.serialize(), function(json){
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
		layer.open({
			type: 2,
			title: '用户信息详情',
			area: ['600px', '480px'],
			maxmin: true,
		    content: './user/get/' + rowid,
		    btn: ['保存', '关闭'],
		    btn1: function(index, layero) {
		    	var form = layer.getChildFrame('form', index);
		    	$.post('./user/save', form.serialize(), function(json){
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
			$.getJSON('./user/delete' ,{ids: rowid+''}, function(json) {
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

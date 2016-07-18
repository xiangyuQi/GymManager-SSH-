<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->

<!-- widget grid -->
<section id="widget-widget" class="">
	<div class="row">
		<div class="well" style="margin-left: 15px;">
		<form id="form-search" class="form-inline" method="post">
  			<div class="form-group">
		    	名称 <input type="text" style="width:120px;" class="form-control" name="Q_LKS_name">
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
			url: 'role/list',
			caption: '<i class="glyphicon glyphicon-list"></i> 角色列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true, key: true},
				{label: '操作', name: 'id', width: 120, formatter: function(v, a, rec) {
					if(rec.menuIds == '_ALL') return '';
					return '<a href="javascript:editfunc('+v+')" class="btn btn-primary btn-xs">编辑</a>' +
							'<a href="javascript:delfunc('+v+')" style="margin-left:10px;" class="btn btn-danger btn-xs">删除</a>' +
							'<a href="javascript:grant('+v+')" style="margin-left:10px;" class="btn btn-info btn-xs">授权</a>';			
				}},
				{label: '名称', name: 'name', width: 100},
				{label: '描述', name: 'note', width: 200},
				{label: '菜单项', name: 'menuIds', width: 100, hidden: true},
				{label: '菜单项', name: 'menuNames', width: 300}
			],
			pager: '#pager',
			multiboxonly: true,
			ondblClickRow: editfunc
		});
		grid.navGrid('#pager',
			{addfunc: addfunc, editfunc: editfunc, search: false, del:false,
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
			layer.open({
				type: 2,
				title: '角色信息详情',
				area: ['500px', '300px'],
				maxmin: true,
			    content: ['pages/system/role_form.jsp', 'yes'],
			    btn: ['保存', '关闭'],
			    btn1: function(index, layero) {
			    	var form = layer.getChildFrame('form', index);
			    	$.post('./role/save', form.serialize(), function(json){
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
		layer.open({
			type: 2,
			title: '角色信息详情',
			area: ['500px', '300px'],
			maxmin: true,
		    content: './role/get/' + rowid,
		    btn: ['保存', '关闭'],
		    btn1: function(index, layero) {
		    	var form = layer.getChildFrame('form', index);
		    	$.post('./role/save', form.serialize(), function(json){
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
	function delfunc(rowid, a, b) {
		layer.confirm('确定删除该条记录吗？', {icon:3, title:'温馨提示'}, function(index) {
			$.getJSON('./role/del/' + rowid, function(json) {
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
	// 授权
	function grant(rowid) {
		// 获得选中项的记录
		var rec = grid.jqGrid('getRowData', rowid);
		var ids = rec.menuIds;
		layer.params = {
			selectIds: ids
		};
		
		layer.open({
			type: 2,
			title: '【'+rec.name+'】角色授权',
			area: ['500px', '600px'],
			maxmin: true,
		    content: ['pages/system/role_grant.jsp', 'no'],
		    btn: ['保存', '关闭'],
		    btn1: function(index, layero) {
		    	var arr = layero.find('iframe')[0].contentWindow.getSelectNode(false);
		    	$.post('./role/grant/' + rowid, {menuIds: arr[0], menuNames: arr[1]}, function(json){
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
	
</script>

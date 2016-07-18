<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->

<!-- widget grid -->
<section id="widget-grid" class="">
		
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
			url: 'menu/list',
			caption: '<span class="glyphicon glyphicon-list"></span> 菜单列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true, key: true},
				{label: '名称', name: 'name', width: 100},
				{label: '图标', name: 'iconCls', width: 100, formatter: function(v) {
					return '<i class="'+v+'"></i>';
				}},
				{label: '链接', name: 'url', width: 100},
				{label: '序号', name: 'sn', width: 100}
			],
			pager: '#pager',
			ondblClickRow: editfunc,
			
			multiselect: false,
			treeGrid: true,
			treeIcons: {leaf: 'glyphicon-link'},
			rownumbers: false,	//treeGrid：必须设置成false
			ExpandColumn: 'name',
			ExpandColClick: true,
			treeGridModel: "adjacency", //使用parent_id时需要使用该模式
			treeReader: {
				level_field: "level",
			   	parent_id_field: "parentId", 
			   	leaf_field: "leaf"
			},
		});
		grid.navGrid('#pager', {addfunc: addfunc, editfunc: editfunc, delfunc: delfunc});
		
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
				title: '菜单详情',
				area: ['500px', '350px'],
				maxmin: true,
			    content: ['menu/addUI', 'yes'],
			    btn: ['保存', '关闭'],
			    btn1: function(index, layero) {
			    	var form = layer.getChildFrame('form', index);
			    	$.post('./menu/save', form.serialize(), function(json){
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
		// "编辑"弹出框
		function editfunc(rowid) {
			//获得编辑行, 只能选中一行
			layer.open({
				type: 2,
				title: '菜单项详情',
				area: ['500px', '350px'],
				maxmin: true,
			    content: './menu/get/' + rowid,
			    btn: ['保存', '关闭'],
			    btn1: function(index, layero) {
			    	var form = layer.getChildFrame('form', index);
			    	$.post('./menu/save', form.serialize(), function(json){
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
				$.getJSON('./menu/del/' + rowid, function(json) {
					if(json.success) {
						grid.trigger("reloadGrid", [{page: 1}]);
		    			layer.msg('操作成功！', {icon: 1});		
					} else {
						var msg = json.text || '操作失败！';
						layer.msg(msg, {icon: 2});					
					}
				});
				layer.close(index);
			});
		}
		
		// end jquery
	});
	
</script>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.kzw.com/mytag" prefix="k"%>
<!-- Bread crumb is created dynamically -->
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!--
	The ID "widget-grid" will start to initialize all widgets below 
	You do not need to use widgets if you dont want to. Simply remove 
	the <section></section> and you can use wells or panels instead 
-->

<!-- widget grid -->
<section id="member-widget" class="">
	<div class="row" >
		<div class="col-md-12 well" >
		<form class="form-inline " id="form-search" method="post" ">
  			<div class="form-group">
		    	姓名 <input type="text" style="width:120px;height:30px;" class="form-control" name="Q_LKS_name">
		  	</div>
		  	<div class="form-group" >
		    	性别 <k:dictSelect name="Q_EQI_sex.id" className="form-control" itemName="性别" headerKey="" />
		  	</div>
		  	
		  	<a class="btn btn-primary btn-sm btn-submit"><span class="glyphicon glyphicon-search"></span> 查询</a>
		  	<a class="btn btn-default btn-sm btn-clear"><span class="glyphicon glyphicon-remove"></span> 清除</a>
		</form>
		</div>
	</div>
	<!-- row -->
	<div class="row">
		
		<!-- NEW WIDGET START -->
			<div class="col-md-5">
				<table id="master-grid"></table>
				<div id="master-pager"></div>
			</div>	
			<div class="col-md-7">
				<table id="detail-grid"></table>
				<div id="detail-pager"></div>				
			</div>
		<!-- WIDGET END -->
		
		<!--  
		<table width="100%">
			<tr>
				<td width="45%" style="padding-left: 15px">
					<table id="master-grid"></table>
					<div id="master-pager"></div>
				</td>
				<td style="padding-left: 15px">
					<table id="detail-grid"></table>
					<div id="detail-pager"></div>		
				</td>
			</tr>
		</table>
		-->
		
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

	pageSetUp();
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
		// 查询
		var widget = $('#member-widget');
		var grid   = $('#master-grid');
		var form   = widget.find('#form-search');
		var submitBtn = form.find('.btn-submit');
		var clearBtn  = form.find('.btn-clear');
		// 从表
		var detailGrid  = $('#detail-grid');
		// 设置gird
		grid.jqGrid({
			url: 'emp/listCoach',
			caption: '<span class="glyphicon glyphicon-list"></span> 教练信息列表',
			colModel: [
				{label: 'ID', name: 'id', hidden: true},
				{label: '姓名', name: 'name', width: 100},
				{label: '性别', name: 'sex.itemValue', width: 100},
				{label: '职位', name: 'job.itemValue', width: 100},
			
			],
			pager: '#master-pager',
			multiselect: false,
			onSelectRow: showDetail,
			onSortCol: clearDetail,
			onPaging: clearDetail,
		});
		// 设置导航条
		grid.navGrid('#master-pager',{add:false, edit:false, del:false, search:false});
		
		// detail-grid
		detailGrid.jqGrid({			
			caption: '<span class="glyphicon glyphicon-list"></span> 所属教练：无',
			colModel: [
				{label: 'ID', name: 'id', hidden: true},
				{label: '会员姓名', name: 'name', width: 100},
				{label: '性别', name: 'sex.itemValue', width: 100},
				{label: '年龄', name: 'age', width: 100},
				{label: '联系电话', name: 'phone', width: 100},
			],
			pager: '#detail-pager'
		});
		// 设置导航条
		detailGrid.navGrid('#detail-pager', 
				{addfunc: addfunc, delfunc: delfunc, search:false,edit:false});
		
		// "add"
		function addfunc() {
			var id = grid.jqGrid('getGridParam', 'selrow');
			if(!id) {
				layer.msg('请先选择左侧的领导！', {icon: 5});
				return;
			}
			top.layer.open({
				type: 2,
				title: '会员选择器',
				content: '<%=path%>/pages/selector/member_selector.jsp',
				area: ['420px', '620px'],
				maxmin: true,
				btn: ['确定', '取消'],
				yes: function(index, layero) {
					// 调用iframe页面中的函数
					var arr = layero.find('iframe')[0].contentWindow.getSelectMember();
					if(arr != null) {
						//id 教练ID ,arr[0]会员id
						$.post('./member/save/'+arr[0]+'/'+id,  function(json){
				    		if(json.success) {
				    			detailGrid.trigger("reloadGrid", [{page: 1}]);
				    			layer.msg('保存成功', {icon: 1});
				    		} else {
				    			layer.msg('保存失败', {icon: 2});
				    		}		    		
				    	}, 'json');
						top.layer.close(index);	
						
						return;	
					}
					top.layer.msg('请选择一位会员！', {icon: 5});		
				}
			});
		};
		
		// "del"
		function delfunc(rowid) {
			layer.confirm('确定移除该会员吗？', {icon:3, title:'温馨提示'}, function(index) {
				$.getJSON('./member/delCoach',{ids: rowid+''}, function(json) {
					if(json.success) {
						detailGrid.trigger("reloadGrid", [{page: 1}]);
		    			layer.msg(json.text, {icon: 1});		
					} else {
						//json.text 获取Msg.text
						layer.msg(json.text, {icon: 2});					
					}
				});
				layer.close(index);
			});
			
		}
		
		// 提交
		function sub() {
			var params = form.serializeObject();
			var postData = grid.jqGrid('getGridParam', 'postData') || {};
			$.extend(postData, params);
			grid.jqGrid('setGridParam', {postData: postData}).trigger("reloadGrid", [{page: 1}]);
			clearDetail();
		}
		submitBtn.click(sub);		
		// 清除
		clearBtn.click(function() {
			form[0].reset();
		});
		
		// 显示detail		
		function showDetail(rowId, selected) {
			if(rowId != null) {
				//获得该行信息
				var row = grid.jqGrid('getRowData', rowId);
				detailGrid.jqGrid('setGridParam', {url: 'member/list/'+rowId});
				detailGrid.jqGrid('setCaption', '<span class="glyphicon glyphicon-list"></span> 所属教练：'+row.name);
				detailGrid.trigger("reloadGrid");
			}						
		};
		// 清除detail
		function clearDetail() {
			detailGrid.jqGrid('setGridParam',{url: 'member/list/-1'}); //todo: 
			detailGrid.jqGrid('setCaption', '<span class="glyphicon glyphicon-list"></span> 所属教练：无');
			detailGrid.trigger("reloadGrid");
		}
		
	});
	
</script>

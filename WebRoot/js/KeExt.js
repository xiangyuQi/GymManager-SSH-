// 非常有用：将form表单元素转成json对象
$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (o[this.name]) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};

// jqgrid默认配置
if($ && $.jgrid && $.jgrid.defaults) {
	$.extend(true, $.jgrid.defaults, {
		datatype : 'json',
		mtype : 'POST',
		styleUI : 'Bootstrap',
		responsive : true,
		height : 450,
		autowidth : true,
		rowNum : 20,
		rowList : [10, 20, 30, 50],
		forceFit : true,
		shrinkToFit : true,
		rownumbers : true,
		rownumWidth : 40,
		multiselect : true,
		multiboxonly: true,
		viewrecords : true,
		hidegrid: false,
		prmNames : {
			page : 'pageNo',
			rows : 'pageSize',
			sort : 'orderBy',
			order : 'orderDir',
			search: 'search'
		},
		jsonReader : {
			root : 'result',
			page : 'pageNo',
			total : 'totalPages',
			records : 'totalCounts',
			repeatitems : false
		}
	});
}


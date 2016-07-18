Ext.ns('FlexUploadDialog');
/**
 * @description flex版的文件上传操作，窗口中嵌套swf文件显示
 * @class FlexUploadDialog

 * @createtime 2011-07-21AM
 */
FlexUploadDialog.show = function(file_cat,fileTypeId){
		
	var swf = swfobject;
	 //设置swfobject对象参数
	var swfVersionStr = '10.0.0';
    var xiSwfUrlStr = __ctxPath + '/js/fileupload/playerProductInstall.swf';
    var flashvars = {};
    var params = {};
    params.quality = 'high';
    params.bgcolor = '#ffffff';
    params.allowscriptaccess = 'sameDomain';
    params.allowfullscreen = 'true';
    var attributes = {};
    attributes.id = 'flexupload';
    attributes.name = 'flexupload';
    attributes.align = 'middle';
    swf.embedSWF(
        __ctxPath + '/js/fileupload/flexupload.swf', 'flashContent', 
        '95%', '95%', swfVersionStr, xiSwfUrlStr, flashvars, params, attributes);
	 swf.createCSS('#flashContent', 'display:block;text-align:left;');
	// 设置swfobject对象参数
	
	// flashContent
	 var hid = '<div id="flashContent"> <p>要查看此页面,确保安装Adobe Flash Player版本10.0.0或更高!</p>';
	 var pageHost = ((document.location.protocol == 'https:') ? 'https://' :	'http://'); 
	 hid += '<a href="http://www.adobe.com/go/getflashplayer"><img src="' + pageHost 
	 	+ '"www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>'; 
	 hid += '</div>';
	// flashContent
	var swfContent = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="95%" height="95%" id="flexupload">'
        +'<param name="movie" value="' + __ctxPath + '/js/fileupload/flexupload.swf" />'
        +'<param name="quality" value="high" />'
        +'<param name="bgcolor" value="#ffffff" />'
        +'<param name="allowScriptAccess" value="sameDomain" />'
        +'<param name="allowFullScreen" value="true" />'
       +'<object type="application/x-shockwave-flash" data="' + __ctxPath + '/js/fileupload/flexupload.swf" width="580" height="250">'
            +'<param name="quality" value="high" />'
            +'<param name="bgcolor" value="#ffffff" />'
            +'<param name="allowScriptAccess" value="sameDomain" />'
            +'<param name="allowFullScreen" value="true" />'
        	+'<p>' 
        		+'javascript脚本和活跃的内容是不允许运行或没有安装Adobe Flash Player版本10.0.0或更高。'
        	+'</p>'
            +'<a href="http://www.adobe.com/go/getflashplayer">'
                +'<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />'
            +'</a>'
        + '</object>'
    +'</object>';
	
	// 总窗口
	var win = new Ext.Window({
		id : 'flexUploadDialogWin',
		iconCls : 'btn-upload',
		title : '上传文件[flex版]',
		layout : 'form',
		region : 'center',
		width : 600,
		height : 300,
		minWidth : 450,
		minHeight : 250,
		maximizable : false,
		border : false,
		modal : true,
		html : swfContent,
		buttonAlign : 'center',
		items : [{
			xtype : 'hidden',
			name : 'file_cat',
			value : file_cat != null ? file_cat : 'others'
		}, {
			xtype : 'hidden',
			name : 'fileTypeId',
			value : fileTypeId != null ? fileTypeId : '0'
		}]
	}); // end of this win
	win.show();
};
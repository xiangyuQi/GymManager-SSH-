package com.kzw.system.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.util.FileUtil;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.system.entity.AppUser;
import com.kzw.system.entity.FileAttach;
import com.kzw.system.entity.GlobalType;
import com.kzw.system.service.FileAttachService;

@Controller
@RequestMapping("/fileAttach")
public class FileAttachAction {

	@Autowired
	private FileAttachService fileAttachService;

	@RequestMapping("view")
	public String view() {
		return "system/fileAttach_view";
	}
	
	@RequestMapping("list")
	public void list(HttpServletRequest request, PageRequest pageRequest, HttpServletResponse response) {
		// 当前用户
		AppUser currUser = new AppUser(1);

		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		filters.add(new StringPropertyFilter("EQI_creatorId", currUser.getId() + ""));

		Page<FileAttach> page = fileAttachService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	/**
	 * 获得某类型的图片
	 * */
	@ResponseBody
	@RequestMapping("getPicByType")
	public List<FileAttach> getPicByType(Integer typeId) {
		String pic = "bmp,jpeg,jpg,png,gif";
		List<FileAttach> result = new ArrayList<FileAttach>();
		List<FileAttach> list = fileAttachService.getAll();
		for(FileAttach attach : list) {
			if(pic.contains(attach.getExt().toLowerCase())) {
				result.add(attach);
			}
		}
		return result;
	}
	
	/**
	 * 附件删除
	 * */
	@RequestMapping("multiDel")
	public void multiDel(String ids) {
		
	}
	
	/**
	 * fileTypeId：全局类型
	 * fileCat：文件存储目录
	 * fileType：文件类型名称
	 * */
	@RequestMapping("upload")
	public void upload(Integer fileTypeId, String fileCat,  String fileType, String note, 
			HttpServletRequest request, HttpServletResponse response) {
		
		// 获得用户信息
		AppUser currUser = new AppUser(1);
		GlobalType globalType = new GlobalType(fileTypeId);
		
		// 初始化目录
		String uploadPath = request.getSession().getServletContext().getRealPath("/attachFiles/");
		File uploadPathFile = new File(uploadPath);
		if(!uploadPathFile.exists() || !uploadPathFile.isDirectory()) {
			uploadPathFile.mkdir();
		}
		File tempPathFile = new File(uploadPathFile, "temp");
	    if(!tempPathFile.exists() || !tempPathFile.isDirectory()){
	    	tempPathFile.mkdirs();
	    }
		// 生成新的目录
	    File uploadPathFileNew = new File(uploadPathFile, fileCat);
	    if(!uploadPathFileNew.exists() || !uploadPathFileNew.isDirectory()) {
	    	try {
				FileUtils.forceMkdir(uploadPathFileNew);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		MultipartRequest multipartReq = (MultipartRequest)request;
		Map<String, MultipartFile> map = multipartReq.getFileMap();
		Set<String> keys = map.keySet();
		for(String key : keys) {
			MultipartFile myfile = map.get(key);
			//如果选择了上传的文件
			if(!myfile.isEmpty()) {
				String fname = myfile.getOriginalFilename();
				try {
					String ext = FilenameUtils.getExtension(fname);
					// 生成新的文件名称
					String fnameNew = FileUtil.generateFilename(fname);
					File destFile = new File(uploadPathFileNew, fnameNew);
					if(!destFile.getParentFile().exists()) {
						FileUtils.forceMkdir(destFile.getParentFile());
					}
					
					//处理小文件：直接保存
					myfile.transferTo(destFile);
					
					String filePath = destFile.getCanonicalPath().substring(uploadPathFile.getCanonicalPath().length());
					filePath = filePath.replaceAll("\\\\", "/");
					
					FileAttach fileAttach = new FileAttach();
					fileAttach.setFileName(fname);
					fileAttach.setFilePath(filePath);
					fileAttach.setExt(ext);
					fileAttach.setFileType(fileType);
					fileAttach.setCreatetime(new Date());
					
					fileAttach.setNote(note);
					fileAttach.setDelFlag(0);
					fileAttach.setTotalBytes(myfile.getSize());
					fileAttach.setCreator(currUser.getRealName());
					fileAttach.setCreatorId(currUser.getId());
					
					fileAttachService.saveOrUpdate(fileAttach);
					
					// 响应输出JSON
					Map<String, Object> objMap = new HashMap<String, Object>();
					objMap.put("success", "true");
					objMap.put("fileId", fileAttach.getFileId());
					objMap.put("fileName", fileAttach.getFileName());
					objMap.put("filePath", fileAttach.getFilePath());
					objMap.put("message", "upload file success.");
					ResponseUtils.renderJson(response, new JSON(objMap, true).build());
				} catch(Exception e) {
					Map<String, Object> objMap = new HashMap<String, Object>();
					objMap.put("success", "false");
					objMap.put("message", fname + ": upload is error.");
					ResponseUtils.renderJson(response, new JSON(objMap, true).build());
					e.printStackTrace();
				}
			} 
		} 
		
	}
}

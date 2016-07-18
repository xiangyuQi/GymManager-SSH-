package com.kzw.system.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;


/**
 * 附件信息
 */
@Entity
@Table(name="sys_file_attach")
public class FileAttach {

	// 删除标识,1=已删除
	public static final Integer FLAG_DEL = 1;
	// 删除标识,0=未删除
	public static final Integer FLAG_NOT_DEL = 0;
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	protected Integer fileId;
	// 文件名称
	protected String fileName;
	// 文件路径
	protected String filePath;
	// 创建时间
	protected Date createtime;
	// 扩展名
	protected String ext;
	// 附件类型 如：邮件附件
	protected String fileType;
	// 备注
	protected String note;
	// 创建者姓名
	protected String creator;
	// 创建者ID
	protected Integer creatorId;
	// 文件大小
	protected Long totalBytes;
	// 是否删除
	protected Integer delFlag = 0;
	// 类型


	public FileAttach() {
	}

	public FileAttach(Integer fileId) {
		this.fileId = fileId;
	}

	public Integer getFileId() {
		return fileId;
	}

	public void setFileId(Integer fileId) {
		this.fileId = fileId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Date getCreatetime() {
		return createtime;
	}

	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}

	public String getExt() {
		return ext;
	}

	public void setExt(String ext) {
		this.ext = ext;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	public Long getTotalBytes() {
		return totalBytes;
	}

	public void setTotalBytes(Long totalBytes) {
		this.totalBytes = totalBytes;
	}

	public Integer getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(Integer delFlag) {
		this.delFlag = delFlag;
	}

	

}

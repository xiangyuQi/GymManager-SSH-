package com.kzw.system.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.system.entity.FileAttach;

@Service
@Transactional
public class FileAttachService extends DefaultEntityManager<FileAttach, Integer> {
	
}

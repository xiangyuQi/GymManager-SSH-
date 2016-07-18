package com.kzw.system.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.system.entity.GlobalType;

@Service
@Transactional
public class GlobalTypeService extends DefaultEntityManager<GlobalType, Integer> {
	
}

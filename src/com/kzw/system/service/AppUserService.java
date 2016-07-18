package com.kzw.system.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.system.entity.AppUser;

@Service
@Transactional
public class AppUserService extends DefaultEntityManager<AppUser, Integer> {
	
}

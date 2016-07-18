package com.kzw.gym.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.gym.entity.Goods;

@Service
@Transactional
public class GoodsService extends DefaultEntityManager<Goods, Integer> {

}

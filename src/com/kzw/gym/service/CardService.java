package com.kzw.gym.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.gym.entity.Card;
import com.kzw.gym.entity.Member;

@Service
@Transactional
public class CardService extends DefaultEntityManager<Card, Integer> {

	public List<Card> getByIds(String ids) {
		if (ids == null || ids.equals(";") || ids.equals("")) return null;
		List<Card> list =getEntityDao().createQuery(" from "+entityClass.getSimpleName()+" where id in "+com.kzw.core.util.StrUtils.idStrToIds(ids)).list();
		return list;
	}

}

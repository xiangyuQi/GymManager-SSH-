package com.kzw.gym.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kzw.comm.vo.Msg;
import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.util.BeanUtil;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.gym.entity.Card;
import com.kzw.gym.entity.Lockers;
import com.kzw.gym.entity.Member;
import com.kzw.gym.service.CardService;
import com.kzw.gym.service.MemberService;


@Controller
@RequestMapping("/card")
public class CardAction {
	
	@Autowired
	private CardService cardService ;
	
	@Autowired
	private MemberService memberService;
	
	@RequestMapping("view")
	public String view() {
		return "gym/card_view";
	}
	
	@RequestMapping("list")
	public void list(PageRequest pageRequest,HttpServletRequest request, HttpServletResponse response) {
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		Page<Card> page = cardService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	@RequestMapping("save")
	@ResponseBody
	public Msg save(Card card) {
		if (card.getId() == null) {
			cardService.saveOrUpdate(card);
		} else {
			Card orgCard = cardService.get(card.getId());
			try {
				BeanUtil.copyNotNullProperties(orgCard, card);
				orgCard.setBeginTime(card.getBeginTime());
				orgCard.setEndTime(card.getEndTime());
				cardService.saveOrUpdate(orgCard);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Card card = cardService.get(id);
		model.addAttribute("card", card);
		return "gym/card_form";
	}
	
	@ResponseBody
	@RequestMapping("del")
	public Msg delete(String ids) {
		List<Card> list = cardService.getByIds(ids);
		for(Card c:list){
			Member m = c.getMember();
			m.setCard(null);
			memberService.saveOrUpdate(m);
			cardService.remove(c);
		}
		return new Msg(true);
	}
	@InitBinder
	public void initBinder1(WebDataBinder binder) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
	}
}

package com.kpk.exam.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kpk.exam.demo.service.MemberService;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrAdminController {
	
	@Autowired
	private MemberService memberService;
	@Autowired
	private Rq rq;
	
	// 액션 메서드
	@RequestMapping("/usr/admin/home")
	public String showHome(Model model,
			@RequestParam(defaultValue = "1") int page) {
		
		int membersCount = memberService.getMembersCount();
		
		int itemsInAPage = 10;
		
		int pagesCount = (int) Math.ceil((double)membersCount / itemsInAPage);
		
		List<Member> mebmers = memberService.getForPrintMembers(itemsInAPage, page);
		
		model.addAttribute("page", page);
		model.addAttribute("membersCount", membersCount);
		model.addAttribute("pagesCount", pagesCount);
		model.addAttribute("mebmers", mebmers);
		
		return "usr/admin/home";
	}
}
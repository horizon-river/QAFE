package com.kpk.exam.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.MemberService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class AdmMemberController {

	@Autowired
	private MemberService memberService;
	@Autowired
	private Rq rq;

	// 회원 목록 jsp 연결
	@RequestMapping("/adm/member/list")
	public String showList(Model model, @RequestParam(defaultValue = "0") String authLevel,
			@RequestParam(defaultValue = "loginId,name,nickname") String searchKeywordTypeCode,
			@RequestParam(defaultValue = "") String searchKeyword, @RequestParam(defaultValue = "1") int page) {

		int membersCount = memberService.getMembersCount(authLevel, searchKeywordTypeCode, searchKeyword);

		int itemsInAPage = 10;
		int pagesCount = (int) Math.ceil((double) membersCount / itemsInAPage);

		List<Member> members = memberService.getForPrintMembers(authLevel, searchKeywordTypeCode, searchKeyword,
				itemsInAPage, page);

		model.addAttribute("authLevel", authLevel);
		model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
		model.addAttribute("searchKeyword", searchKeyword);

		model.addAttribute("membersCount", membersCount);
		model.addAttribute("pagesCount", pagesCount);
		model.addAttribute("page", page);
		model.addAttribute("members", members);
		
		return "adm/member/list";
	}
	
	@RequestMapping("/adm/member/doDeleteMembers")
	@ResponseBody
	public String doDeleteMembers(@RequestParam(defaultValue = "") String ids,
			@RequestParam(defaultValue = "/adm/member/list") String replaceUri) {
		List<Integer> memberIds = new ArrayList<>();

		for (String idStr : ids.split(",")) {
			memberIds.add(Integer.parseInt(idStr));
		}

		memberService.deleteMembers(memberIds);

		return Ut.jsReplace("해당 회원들이 삭제되었습니다.", replaceUri);
	}
	
	@RequestMapping("/adm/member/doRecoveryMembers")
	@ResponseBody
	public String doRecoveryMembers(@RequestParam(defaultValue = "") String ids,
			@RequestParam(defaultValue = "/adm/member/list") String replaceUri) {
		List<Integer> memberIds = new ArrayList<>();

		for (String idStr : ids.split(",")) {
			memberIds.add(Integer.parseInt(idStr));
		}

		memberService.recoveryMembers(memberIds);

		return Ut.jsReplace("해당 회원들이 복구되었습니다.", replaceUri);
	}

}
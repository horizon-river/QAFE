package com.kpk.exam.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kpk.exam.demo.service.RankService;
import com.kpk.exam.demo.vo.Rank;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrRankController {
	
	@Autowired
	private RankService rankService; 
	@Autowired
	private Rq rq;
	
	// 랭킹 리스트 jsp 연결
	@RequestMapping("usr/rank/list")
	public String showRankList(Model model) {
		List<Rank> totalAnswerRank = rankService.getTotalAnswerRank();
		model.addAttribute("totalAnswerRank", totalAnswerRank);
		
		List<Rank> totalQuestionRank = rankService.getTotalQuestionRank();
		model.addAttribute("totalQuestionRank", totalQuestionRank);
		
		List<Rank> totalChoicedAnswerRank = rankService.getTotalChoicedAnswerRank();
		model.addAttribute("totalChoicedAnswerRank", totalChoicedAnswerRank);
		
		List<Rank> totalChoicedMemberRank = rankService.getTotalChoicedMemberRank();
		model.addAttribute("totalChoicedMemberRank", totalChoicedMemberRank);
		
		return "usr/rank/list";
	}
}
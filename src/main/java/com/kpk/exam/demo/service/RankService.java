package com.kpk.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.RankRepository;
import com.kpk.exam.demo.vo.Rank;

@Service
public class RankService {

	@Autowired
	private RankRepository rankRepository;
	
	public List<Rank> getTotalAnswerRank() {
		return rankRepository.getTotalAnswerRank();
	}

	public List<Rank> getTotalQuestionRank() {
		return rankRepository.getTotalQuestionRank();
	}

	public List<Rank> getTotalChoicedAnswerRank() {
		return rankRepository.getTotalChoicedAnswerRank();
	}

	public List<Rank> getTotalChoicedMemberRank() {
		return rankRepository.getTotalChoicedMemberRank();
	}
	
}

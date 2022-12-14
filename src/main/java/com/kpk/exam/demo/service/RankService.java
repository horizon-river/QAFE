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
	
	// 총 답변의 수로 정렬하여 조회
	public List<Rank> getTotalAnswerRank() {
		return rankRepository.getTotalAnswerRank();
	}

	// 총 질문의 수로 정렬하여 조회
	public List<Rank> getTotalQuestionRank() {
		return rankRepository.getTotalQuestionRank();
	}

	// 채택된 답변의 수로 정렬하여 조회 
	public List<Rank> getTotalChoicedAnswerRank() {
		return rankRepository.getTotalChoicedAnswerRank();
	}

	// 채택한 답변의 수로 정렬하여 조회
	public List<Rank> getTotalChoicedMemberRank() {
		return rankRepository.getTotalChoicedMemberRank();
	}
	
}

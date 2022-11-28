package com.kpk.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.AnswerRepository;
import com.kpk.exam.demo.repository.ReplyRepository;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Answer;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.ResultData;

@Service
public class AnswerService {
	@Autowired
	private AnswerRepository answerRepository;
	
	public ResultData writeReply(int memberId, String relTypeCode, int relId, String body) {
		answerRepository.writeAnswer(memberId, relTypeCode, relId, body);
		
		int id = answerRepository.getLastInsertId();
		
		return ResultData.from("S-1", Ut.f("%d번 댓글이 등록되었습니다.", id), "id", id);
	}

	public List<Answer> getAnswers(Member actor, String relTypeCode, int relId) {
		
		List<Answer> replies = answerRepository.getAnswers(relTypeCode, relId);
		
		return replies;
		
	}
	
}

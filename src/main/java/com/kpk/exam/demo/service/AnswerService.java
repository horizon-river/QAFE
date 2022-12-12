package com.kpk.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.AnswerRepository;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Answer;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.ResultData;

@Service
public class AnswerService {
	@Autowired
	private AnswerRepository answerRepository;
	
	// 답변 작성
	public ResultData writeAnswer(int memberId, String relTypeCode, int relId, String body) {
		answerRepository.writeAnswer(memberId, relTypeCode, relId, body);
		
		int id = answerRepository.getLastInsertId();
		
		return ResultData.from("S-1", Ut.f("답변이 등록되었습니다."));
	}

	// 답변 리스트
	public List<Answer> getAnswers(Member actor, String relTypeCode, int relId) {
		
		List<Answer> answers = answerRepository.getAnswers(relTypeCode, relId);
		
		for (Answer answer : answers) {
			updateForPrintData(actor, answer);
		}
		
		return answers;
		
	}

	// 답변 작성 가능한지 체크(2개 이상의 답변 작성 불가)
	public boolean getActorCanWriteAnswer(int loginedMemberId, String relTypeCode, int relId) {
		
		return answerRepository.getActorCanWriteAnswer(loginedMemberId, relTypeCode, relId) == 0;
	}
	
	private void updateForPrintData(Member actor, Answer answer) {
		if (actor == null) {
			return;
		}
		
		ResultData actorCanDeleteRd = actorCanDelete(actor, answer);
		answer.setExtra__actorCanDelete(actorCanDeleteRd.isSuccess());
		
		ResultData actorCanModifyRd = actorCanModify(actor, answer);
		answer.setExtra__actorCanModify(actorCanModifyRd.isSuccess());
		
	}

	private ResultData actorCanModify(Member actor, Answer answer) {
		if (answer == null) {
			return ResultData.from("F-1", "답변이 존재하지 않습니다.");
		}
		
		if (answer.getMemberId() != actor.getId()) {
			return ResultData.from("F-2", "해당 답변에 대한 권한이 없습니다.");
		}
		return ResultData.from("S-1", "수정 가능");
	}

	private ResultData actorCanDelete(Member actor, Answer answer) {
		if (answer == null) {
			return ResultData.from("F-1", "답변이 존재하지 않습니다.");
		}
		
		if (answer.getMemberId() != actor.getId()) {
			return ResultData.from("F-2", "해당 답변에 대한 권한이 없습니다.");
		}
		return ResultData.from("S-1", "삭제 가능");
	}

	// 특정 답변 조회
	public Answer getAnswer(Member actor, int id) {
		Answer answer = answerRepository.getAnswer(id);
		
		updateForPrintData(actor, answer);
		
		return answer;
	}

	// 답변 수정
	public ResultData modifyAnswer(int id, String body) {
		answerRepository.modifyAnswer(id, body);
		
		return ResultData.from("S-1", "답변을 수정했습니다.");
	}

	// 답변 삭제
	public ResultData deleteAnswer(int id) {
		answerRepository.deleteAnswer(id);
		
		return ResultData.from("S-1", "답변을 삭제했습니다.");
	}

	// 답변 채택
	public ResultData choiceAnswer(int id) {
		answerRepository.choiceAnswer(id);
		
		return ResultData.from("S-1", "답변을 채택했습니다.");
	}

	// 회원정보로 답변 수 조회
	public int getAnswerCountByMemberId(int loginedMemberId) {
		return answerRepository.getAnswerCountByMemberId(loginedMemberId);
	}
	
	// 회원정보로 채택한 답변 수 조회
	public int getChoicedAnswerCountByMemberId(int loginedMemberId) {
		return answerRepository.getChoicedAnswerCountByMemberId(loginedMemberId);
	}
	
}

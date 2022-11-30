package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Answer;

@Mapper
public interface AnswerRepository {

	void writeAnswer(int memberId, String relTypeCode, int relId, String body);

	List<Answer> getAnswers(String relTypeCode, int relId);

	int getLastInsertId();

	int getActorCanWriteAnswer(int loginedMemberId, String relTypeCode, int relId);

	Answer getAnswer(int id);

	void modifyAnswer(int id, String body);

	void deleteAnswer(int id);

	void choiceAnswer(int id);

	int getAnswerCountByMemberId(int loginedMemberId);

	int getChoicedAnswerCountByMemberId(int loginedMemberId);
	
}

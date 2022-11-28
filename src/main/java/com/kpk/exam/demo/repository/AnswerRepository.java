package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Answer;

@Mapper
public interface AnswerRepository {

	void writeAnswer(int memberId, String relTypeCode, int relId, String body);

	List<Answer> getAnswers(String relTypeCode, int relId);

	int getLastInsertId();
	
}

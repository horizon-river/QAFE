package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Rank;


@Mapper
public interface RankRepository {

	List<Rank> getTotalAnswerRank();

	List<Rank> getTotalQuestionRank();

	List<Rank> getTotalChoicedAnswerRank();

	List<Rank> getTotalChoicedMemberRank();
	
}

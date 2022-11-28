package com.kpk.exam.demo.repository;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReactionPointRepository {

	int getReactionPointByMemberId(int actorId, String relTypeCode, int relId);

	void addGoodReactionPoint(int actorId, String relTypeCode, int relId);

	void addBadReactionPoint(int actorId, String relTypeCode, int relId);

	void deleteGoodReactionPoint(int actorId, String relTypeCode, int relId);

	void deleteBadReactionPoint(int actorId, String relTypeCode, int relId);

}

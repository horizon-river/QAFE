package com.kpk.exam.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.ReactionPointRepository;
import com.kpk.exam.demo.vo.ResultData;

@Service
public class ReactionPointService {

	@Autowired
	private ReactionPointRepository reactionPointRepository;
	@Autowired
	private ArticleService articleService;
	
	public ResultData actorCanMakeReaction(int actorId, String relTypeCode, int relId) {
		
		if (actorId == 0) {
			return ResultData.from("F-1", "로그인 후 이용해주세요");
		}
		
		int getReactionPointByMemberId = reactionPointRepository.getReactionPointByMemberId(actorId, relTypeCode, relId);
		
		if(getReactionPointByMemberId != 0) {
			return ResultData.from("F-2", "리액션을 할 수 없습니다.", "getReactionPointByMemberId", getReactionPointByMemberId);
		}
		
		return  ResultData.from("S-1", "리액션을 할 수 있습니다", "getReactionPointByMemberId", getReactionPointByMemberId );
	}

	public ResultData addGoodReactionPoint(int actorId, String relTypeCode, int relId) {
		reactionPointRepository.addGoodReactionPoint(actorId, relTypeCode, relId);
		
		switch(relTypeCode) {
		case "article":
			articleService.increaseGoodReactionPoint(relId);
			break;
		}
		
		return ResultData.from("S-1", "좋아요 처리 되었습니다.");
	}

	public ResultData addBadReactionPoint(int actorId, String relTypeCode, int relId) {
		reactionPointRepository.addBadReactionPoint(actorId, relTypeCode, relId);
		switch(relTypeCode) {
		case "article":
			articleService.increaseBadReactionPoint(relId);
			break;
		}
		
		return ResultData.from("S-1", "싫어요 처리 되었습니다.");
	}

	public ResultData deleteGoodReactionPoint(int actorId, String relTypeCode, int relId) {
		reactionPointRepository.deleteGoodReactionPoint(actorId, relTypeCode, relId);
		
		switch(relTypeCode) {
		case "article":
			articleService.decreaseGoodReactionPoint(relId);
			break;
		}
		
		return ResultData.from("S-1", "좋아요 취소 처리 되었습니다.");
	}

	public ResultData deleteBadReactionPoint(int actorId, String relTypeCode, int relId) {
		reactionPointRepository.deleteBadReactionPoint(actorId, relTypeCode, relId);
		switch(relTypeCode) {
		case "article":
			articleService.decreaseBadReactionPoint(relId);
			break;
		}
		
		return ResultData.from("S-1", "싫어요 취소 처리 되었습니다.");
		
	}
	
}

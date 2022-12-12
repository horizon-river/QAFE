package com.kpk.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.ArticleRepository;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Article;
import com.kpk.exam.demo.vo.ResultData;

@Service
public class ArticleService {
	
	@Autowired
	private ArticleRepository articleRepository;
	
	// 생성자
	public ArticleService(ArticleRepository articleRepository) {
		this.articleRepository = articleRepository;
	}
	
	// 게시물 상세내용
	public Article getForPrintArticle(int actorId, int id) {
		Article article = articleRepository.getForPrintArticle(id);
		
		updateForPrintData(actorId, article);
		
		return article;
	}
	
	// 데이터에 대한 권한 업데이트
	private void updateForPrintData(int actorId, Article article) {
		if (article == null) {
			return;
		}
		
		ResultData actorCanDeleteRd = actorCanDelete(actorId, article);
		article.setExtra__actorCanDelete(actorCanDeleteRd.isSuccess());
		
		ResultData actorCanModifyRd = actorCanModify(actorId, article);
		article.setExtra__actorCanModify(actorCanModifyRd.isSuccess());
	}

	// 로그인한 회원의 수정권한 체크
	public ResultData actorCanModify(int loginedMemberId, Article article) {
		if (article == null) {
			return ResultData.from("F-1", "게시물이 존재하지 않습니다");
		}
		
		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-2", "해당 게시물에 대한 권한이 없습니다.");
		}
		return ResultData.from("S-1", "수정 가능");
	}

	// 로그인한 회원의 삭제권한 체크
	public ResultData actorCanDelete(int actorId, Article article) {
		if (article == null) {
			return ResultData.from("F-1", "게시물이 존재하지 않습니다");
		}
		
		if (article.getMemberId() != actorId) {
			return ResultData.from("F-2", "해당 게시물에 대한 권한이 없습니다.");
		}
		return ResultData.from("S-1", "삭제 가능");
	}

	// 총 게시물 수
	public int getArticlesCount(int boardId, String searchKeywordTypeCode, String searchKeyword) {
		return articleRepository.getArticlesCount(boardId, searchKeywordTypeCode, searchKeyword);
	}

	// 게시물 리스트
	public List<Article> getForPrintArticles(int actorId, int boardId, int itemsInAPage, 
			int page, String searchKeywordTypeCode, String searchKeyword) {
		
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;
		List<Article> articles = articleRepository.getArticles(boardId, limitStart, 
				limitTake, searchKeywordTypeCode, searchKeyword);
		
		for (Article article : articles) {
			updateForPrintData(actorId, article);
		}
		
		return articles;
	}
	
	// 게시물 작성
	public ResultData<Integer> writeArticle(int loginedMemberId, int boardId, String title, String body) {
		articleRepository.writeArticle(loginedMemberId, boardId, title, body);
		int id = articleRepository.getLastInsertId();
		
		return ResultData.from("S-1", Ut.f("%d번 게시물이 생성되었습니다.", id), "id", id);
	}
	
	public void deleteArticle(int id) {
		articleRepository.deleteArticle(id);
	}

	public ResultData<Article> modifyArticle(int id, String title, String body) {
		articleRepository.modifyArticle(id, title, body);
		
		Article article = getForPrintArticle(0, id);
		
		return ResultData.from("S-1", Ut.f("%d번 게시물을 수정했습니다.", id), "article", article);
	}

	public ResultData<Integer> increaseHitCount(int id) {
		int affectedRowsCount = articleRepository.increaseHitCount(id);
		
		if(affectedRowsCount == 0) {
			return ResultData.from("F-1", "해당 게시물은 존재하지 않습니다.", "affectedRowsCount", affectedRowsCount);
		}
		
		return ResultData.from("S-1", "조회수 증가", "affectedRowsCount", affectedRowsCount);
	}

	public int getArticleHitCount(int id) {
		return articleRepository.getArticleHitCount(id);
	}

	public ResultData increaseGoodReactionPoint(int relId) {
		int affectedRowsCount = articleRepository.increaseGoodReactionPoint(relId);
		
		if(affectedRowsCount == 0) {
			return ResultData.from("F-1", "해당 게시물은 존재하지 않습니다.", "affectedRowsCount", affectedRowsCount);
		}
		
		return ResultData.from("S-1", "좋아요 증가", "affectedRowsCount", affectedRowsCount);
	}

	public ResultData increaseBadReactionPoint(int relId) {
		int affectedRowsCount = articleRepository.increaseBadReactionPoint(relId);
		
		if(affectedRowsCount == 0) {
			return ResultData.from("F-1", "해당 게시물은 존재하지 않습니다.", "affectedRowsCount", affectedRowsCount);
		}
		
		return ResultData.from("S-1", "싫어요 증가", "affectedRowsCount", affectedRowsCount);
		
	}

	public ResultData decreaseGoodReactionPoint(int relId) {
		int affectedRowsCount = articleRepository.decreaseGoodReactionPoint(relId);
		
		if(affectedRowsCount == 0) {
			return ResultData.from("F-1", "해당 게시물은 존재하지 않습니다.", "affectedRowsCount", affectedRowsCount);
		}
		
		return ResultData.from("S-1", "좋아요 감소", "affectedRowsCount", affectedRowsCount);
	}

	public ResultData decreaseBadReactionPoint(int relId) {
		int affectedRowsCount = articleRepository.decreaseBadReactionPoint(relId);
		
		if(affectedRowsCount == 0) {
			return ResultData.from("F-1", "해당 게시물은 존재하지 않습니다.", "affectedRowsCount", affectedRowsCount);
		}
		
		return ResultData.from("S-1", "싫어요 감소", "affectedRowsCount", affectedRowsCount);
	}

	public int getQuestionCountByMemberId(int loginedMemberId) {
		return articleRepository.getQuestionCountByMemberId(loginedMemberId);
	}
}

package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Article;

@Mapper
public interface ArticleRepository {
	
	public void writeArticle(int loginedMemberId, int boardId, String title, String body);
	
	public Article getForPrintArticle(int id);
	
	public List<Article> getArticles(int boardId, int limitStart, int limitTake, 
			String searchKeywordTypeCode, String searchKeyword);
	
	public int getLastInsertId();
	
	public void deleteArticle(int id);

	public void modifyArticle(int id, String title, String body);

	public int getArticlesCount(int boardId, String searchKeywordTypeCode, String searchKeyword);

	public int increaseHitCount(int id);

	public int getArticleHitCount(int id);

	public int increaseGoodReactionPoint(int relId);

	public int increaseBadReactionPoint(int relId);

	public int decreaseGoodReactionPoint(int relId);

	public int decreaseBadReactionPoint(int relId);

	public int getQuestionCountByMemberId(int loginedMemberId);
	
}

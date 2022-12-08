package com.kpk.exam.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.AnswerService;
import com.kpk.exam.demo.service.ArticleService;
import com.kpk.exam.demo.service.BoardService;
import com.kpk.exam.demo.service.ReactionPointService;
import com.kpk.exam.demo.service.ReplyService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Answer;
import com.kpk.exam.demo.vo.Article;
import com.kpk.exam.demo.vo.Board;
import com.kpk.exam.demo.vo.Reply;
import com.kpk.exam.demo.vo.ResultData;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrArticleController {
	// 인스턴스 변수
	@Autowired
	private ArticleService articleService;
	@Autowired
	private BoardService boardService;
	@Autowired
	private ReactionPointService reactionPointService;
	@Autowired
	private ReplyService replyService;
	@Autowired
	private AnswerService answerService;
	@Autowired
	private Rq rq;
	
	// 액션 메서드
	@RequestMapping("/usr/article/write")
	public String showWrite() {
		return "usr/article/write";
	}
	
	@RequestMapping("usr/article/doWrite")
	@ResponseBody
	public String doWrite(int boardId, String title, String body, String replaceUri) {
		
		if(Ut.empty(title)) {
			return rq.jsHistoryBack("제목을 입력해주세요.");
		}
		
		if(Ut.empty(body)) {
			return rq.jsHistoryBack("내용을 입력해주세요.");
		}
		
		ResultData<Integer> writeArticleRd = articleService.writeArticle(rq.getLoginedMemberId(), boardId, title, body);
		
		int id = (int) writeArticleRd.getData1();
		
		if (Ut.empty(replaceUri)) {
			replaceUri = Ut.f("../article/detail?id=%d", id);
		}

		return rq.jsReplace(Ut.f("%d번 글이 작성되었습니다.", id), replaceUri);
	}
	
	@RequestMapping("/usr/article/list")
	public String showList(Model model, 
			@RequestParam(defaultValue = "1") int boardId, 
			@RequestParam(defaultValue = "title,body") String searchKeywordTypeCode, 
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "1") int page) {
		
		Board board = boardService.getBoardById(boardId);

		if (board == null) {
			return rq.jsHistoryBackOnView("존재하지 않는 게시판입니다.");
		}
		
		int articlesCount = articleService.getArticlesCount(boardId, searchKeywordTypeCode, searchKeyword);
		
		int itemsInAPage = 10;
		
		int pagesCount = (int) Math.ceil((double)articlesCount / itemsInAPage);
		
		List<Article> articles = articleService.getForPrintArticles(rq.getLoginedMemberId(), boardId, itemsInAPage, page, searchKeywordTypeCode, searchKeyword);
		
		model.addAttribute("boardId", boardId);
		model.addAttribute("board", board);
		model.addAttribute("page", page);
		model.addAttribute("articlesCount", articlesCount);
		model.addAttribute("pagesCount", pagesCount);
		model.addAttribute("articles", articles);
		
		return "usr/article/list";
	}
	
	@RequestMapping("usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {
		
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);
		
		if (article == null) {
			return rq.jsHistoryBack(Ut.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if (article.getMemberId() != rq.getLoginedMemberId()) {
			return rq.jsHistoryBack(Ut.f("%d번 게시물에 대한 권한이 없습니다.", id));
		}
		
		articleService.deleteArticle(id);
		
		return rq.jsReplace("게시물이 삭제되었습니다.", "../article/list?boardId="+article.getBoardId());
	}
	
	@RequestMapping("/usr/article/modify")
	public String showModify(Model model, int id) {
		
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);

		if (article == null) {
			return rq.jsHistoryBack(Ut.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		Board board = boardService.getBoardById(article.getBoardId());
		
		model.addAttribute("board", board);
		
		ResultData actorCanModifyRd = articleService.actorCanModify(rq.getLoginedMemberId(), article);
		
		if(actorCanModifyRd.isFail()) {
			return rq.jsHistoryBack(actorCanModifyRd.getMsg());
		}
		
		model.addAttribute("article", article);
		
		return "usr/article/modify";
	}
	
	@RequestMapping("usr/article/doModify")
	@ResponseBody
	public String doModify(int id, String title, String body) {
		
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);
		
		if (article == null) {
			return rq.jsHistoryBack(Ut.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		ResultData actorCanModifyRd = articleService.actorCanModify(rq.getLoginedMemberId(), article);
		
		if(actorCanModifyRd.isFail()) {
			return rq.jsHistoryBack(actorCanModifyRd.getMsg());
		}
		
		articleService.modifyArticle(id, title, body);
		
		return rq.jsReplace(Ut.f("%d번 게시물이 수정되었습니다.", id), Ut.f("../article/detail?id=%d", id));
	}
	
	@RequestMapping("usr/article/detail")
	public String getArticle(Model model, int id) {
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);
		
		model.addAttribute("article", article);
		
		List<Reply> replies = replyService.getForPrintReplies(rq.getLoginedMember(),"article", id);
		
		model.addAttribute("replies", replies);
		
		Board board = boardService.getBoardById(article.getBoardId());
		
		model.addAttribute("board", board);
		
		List<Answer> answers = answerService.getAnswers(rq.getLoginedMember(), "article", id);
		
		model.addAttribute("answers", answers);
		
		boolean actorCanWriteAnswer = answerService.getActorCanWriteAnswer(rq.getLoginedMemberId(),"article", id);
		
		model.addAttribute("actorCanWriteAnswer", actorCanWriteAnswer);
		
		ResultData actorCanMakeReactionRd = reactionPointService.actorCanMakeReaction(rq.getLoginedMemberId(), "article", id);
		
		model.addAttribute("actorCanMakeReactionRd", actorCanMakeReactionRd);
		model.addAttribute("actorCanMakeReaction", actorCanMakeReactionRd.isSuccess());
		
		if(actorCanMakeReactionRd.getResultCode().equals("F-2")) {
			int sumReactionPointByMemberId = (int) actorCanMakeReactionRd.getData1();
			
			if(sumReactionPointByMemberId > 0) {
				model.addAttribute("actorCanCancelGoodReaction", true);
			}else {
				model.addAttribute("actorCanCancelBadReaction", true);
			}
			
		}
		
		return "usr/article/detail";
	}
	
	@RequestMapping("/usr/article/doIncreaseHitCountRd")
	@ResponseBody
	public ResultData<Integer> doIncreaseHitCountRd(int id) {
		ResultData<Integer> increaseHitCountRd = articleService.increaseHitCount(id);
		
		if(increaseHitCountRd.isFail()) {
			return increaseHitCountRd;
		}
		
		ResultData<Integer> rd = ResultData.newData(increaseHitCountRd, "hitCount", articleService.getArticleHitCount(id)); 
		
		rd.setData2("id", id);
		
		return rd;
	}
}
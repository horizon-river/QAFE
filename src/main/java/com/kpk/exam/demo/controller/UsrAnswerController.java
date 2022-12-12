package com.kpk.exam.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.AnswerService;
import com.kpk.exam.demo.service.ArticleService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Answer;
import com.kpk.exam.demo.vo.Article;
import com.kpk.exam.demo.vo.ResultData;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrAnswerController {
	
	@Autowired
	private AnswerService answerService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private Rq rq;
	
	// 답변 작성 처리
	@RequestMapping("/usr/answer/doWrite")
	@ResponseBody
	public String doWrite(String relTypeCode, int relId, String replaceUri, String body) {
		
		if (Ut.empty(relTypeCode)) {
			return rq.jsHistoryBack("잘못된 요청입니다.");
		}

		if (Ut.empty(relId)) {
			return rq.jsHistoryBack("잘못된 게시물입니다.");
		}

		if (Ut.empty(body)) {
			return rq.jsHistoryBack("내용을 입력해주세요");
		}
		
		ResultData writeAnswerRd = 
				answerService.writeAnswer(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		if (Ut.empty(replaceUri)) {
			switch (relTypeCode) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", relId);
				break;
			}
		}
		
		return rq.jsReplace(writeAnswerRd.getMsg(), replaceUri);
	}
	
	// 답변 수정 jsp 연결
	@RequestMapping("/usr/answer/modify")
	public String modify(Model model, int id) {

		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		Answer answer = answerService.getAnswer(rq.getLoginedMember(), id);

		if (answer == null) {
			return rq.jsHistoryBack("해당 답변은 존재하지 않습니다");
		}

		if (answer.isExtra__actorCanModify() == false) {
			return rq.jsHistoryBack("해당 답변을 수정할 권한이 없습니다.");
		}
		
		Article relArticle = null;
		switch (answer.getRelTypeCode()) {
		case "article":
			Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), answer.getRelId());
			relArticle = article;
			break;
		}
		
		model.addAttribute("article", relArticle);
		model.addAttribute("answer", answer);
		
		return "usr/answer/modify";
	}
	
	// 답변 수정 처리
	@RequestMapping("/usr/answer/doModify")
	@ResponseBody
	public String doModify(int id, String body, String replaceUri) {
		
		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		if (Ut.empty(body)) {
			return rq.jsHistoryBack("내용을 입력해주세요.");
		}
		
		Answer answer = answerService.getAnswer(rq.getLoginedMember(), id);

		if (answer == null) {
			return rq.jsHistoryBack(Ut.f("%d번 답변은 존재하지 않습니다.", id));
		}

		if (answer.isExtra__actorCanModify() == false) {
			return rq.jsHistoryBack("해당 답변을 수정할 권한이 없습니다.");
		}
		
		ResultData modifyAnswerRd = answerService.modifyAnswer(id, body);
		
		if (Ut.empty(replaceUri)) {
			switch (answer.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", answer.getRelId());
				break;
			}
		}
		
		return rq.jsReplace(modifyAnswerRd.getMsg(), replaceUri);
	}
	
	// 답변 삭제 처리
	@RequestMapping("/usr/answer/doDelete")
	@ResponseBody
	public String doDelete(int id, String replaceUri) {
		
		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		Answer answer = answerService.getAnswer(rq.getLoginedMember(), id);

		if (answer == null) {
			return rq.jsHistoryBack(Ut.f("%d번 답변은 존재하지 않습니다.", id));
		}

		if (answer.isExtra__actorCanDelete() == false) {
			return rq.jsHistoryBack("해당 답변을 삭제할 권한이 없습니다.");
		}
		
		ResultData deleteAnswerRd = answerService.deleteAnswer(id);
		
		if (Ut.empty(replaceUri)) {
			switch (answer.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", answer.getRelId());
				break;
			}
		}
		
		return rq.jsReplace(deleteAnswerRd.getMsg(), replaceUri);
	}
	
	// 답변 채택
	@RequestMapping("/usr/answer/doChoice")
	@ResponseBody
	public String doChoice(int id, String replaceUri){
		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		Answer answer = answerService.getAnswer(rq.getLoginedMember(), id);

		if (answer == null) {
			return rq.jsHistoryBack(Ut.f("%d번 답변은 존재하지 않습니다.", id));
		}
		
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), answer.getRelId());
		
		if (article.getExtra__choiceStatus() == 1) {
			return rq.jsReplace(Ut.f("%d번 글은 이미 채택된 상태입니다.", answer.getRelId()), 
					Ut.f("../article/detail?id=%d", answer.getRelId()));
		}
		
		ResultData choiceAnswerRd = answerService.choiceAnswer(id);
		
		if (Ut.empty(replaceUri)) {
			switch (answer.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", answer.getRelId());
				break;
			}
		}
		
		return rq.jsReplace(choiceAnswerRd.getMsg(), replaceUri);
	}
}
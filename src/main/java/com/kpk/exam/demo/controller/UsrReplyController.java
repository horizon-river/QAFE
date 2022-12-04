package com.kpk.exam.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.ArticleService;
import com.kpk.exam.demo.service.ReplyService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Article;
import com.kpk.exam.demo.vo.Reply;
import com.kpk.exam.demo.vo.ResultData;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrReplyController {
	
	@Autowired
	private ReplyService replyService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private Rq rq;
	
	// 댓글 작성
	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doWrite(String relTypeCode, int relId, String replaceUri, String body) {
		
		if (Ut.empty(relTypeCode)) {
			return rq.jsHistoryBack("relTypeCode을(를) 입력해주세요");
		}

		if (Ut.empty(relId)) {
			return rq.jsHistoryBack("relId을(를) 입력해주세요");
		}

		if (Ut.empty(body)) {
			return rq.jsHistoryBack("내용을 입력해주세요");
		}
		
		ResultData writeReplyRd = replyService.writeReply(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		if (Ut.empty(replaceUri)) {
			switch (relTypeCode) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", relId);
				break;
			}
		}
		
		return rq.jsReplace(writeReplyRd.getMsg(), replaceUri);
	}
	
	// 댓글 수정 페이지
	@RequestMapping("/usr/reply/modify")
	public String modify(Model model, int id) {

		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		Reply reply = replyService.getForPrintReply(rq.getLoginedMember(), id);

		if (reply == null) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if (reply.isExtra__actorCanModify() == false) {
			return rq.jsHistoryBack("해당 댓글을 수정할 권한이 없습니다.");
		}
		
		Object related = null;
		switch (reply.getRelTypeCode()) {
		case "article":
			Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), reply.getRelId());
			related = article;
			break;
		}
		
		model.addAttribute("related", related);
		model.addAttribute("reply", reply);
		
		return "usr/reply/modify";
	}
	
	// 댓글 수정
	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(int id, String body, String replaceUri) {
		
		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		if (Ut.empty(body)) {
			return rq.jsHistoryBack("내용을 입력해주세요.");
		}
		
		Reply reply = replyService.getForPrintReply(rq.getLoginedMember(), id);

		if (reply == null) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if (reply.isExtra__actorCanModify() == false) {
			return rq.jsHistoryBack("해당 댓글을 수정할 권한이 없습니다.");
		}
		
		ResultData modifyReplyRd = replyService.modifyReply(id, body);
		
		if (Ut.empty(replaceUri)) {
			switch (reply.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", reply.getRelId());
				break;
			}
		}
		
		return rq.jsReplace(modifyReplyRd.getMsg(), replaceUri);
	}
	
	// 댓글 삭제
	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(int id, String replaceUri) {
		
		if (Ut.empty(id)) {
			return rq.jsHistoryBack("id가 없습니다.");
		}
		
		Reply reply = replyService.getForPrintReply(rq.getLoginedMember(), id);

		if (reply == null) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if (reply.isExtra__actorCanDelete() == false) {
			return rq.jsHistoryBack("해당 댓글을 삭제할 권한이 없습니다.");
		}
		
		ResultData deleteReplyRd = replyService.deleteReply(id);
		
		if (Ut.empty(replaceUri)) {
			switch (reply.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", reply.getRelId());
				break;
			}
		}
		
		return rq.jsReplace(deleteReplyRd.getMsg(), replaceUri);
	}
}
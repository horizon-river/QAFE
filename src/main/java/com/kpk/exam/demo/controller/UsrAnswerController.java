package com.kpk.exam.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.AnswerService;
import com.kpk.exam.demo.service.ArticleService;
import com.kpk.exam.demo.service.ReplyService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Article;
import com.kpk.exam.demo.vo.Reply;
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
	
	@RequestMapping("/usr/answer/doWrite")
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
		
		ResultData writeReplyRd = answerService.writeAnswer(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		if (Ut.empty(replaceUri)) {
			switch (relTypeCode) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", relId);
				break;
			}
		}
		
		return rq.jsReplace(writeReplyRd.getMsg(), replaceUri);
	}
}
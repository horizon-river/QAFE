package com.kpk.exam.demo.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kpk.exam.demo.vo.Rq;

@Component
public class NeedAuthLevelInterceptor implements HandlerInterceptor{
	
	@Autowired
	private Rq rq;
	
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
		
		if (!rq.isLogined()) {
			rq.printHistoryBackJs("잘못된 접근입니다.");
			return false;
		}
		
		if(rq.getLoginedMember().getAuthLevel() != 7) {
			rq.printHistoryBackJs("잘못된 접근입니다.");
			return false;
		}
		
		return HandlerInterceptor.super.preHandle(req, resp, handler);
	}
	
}

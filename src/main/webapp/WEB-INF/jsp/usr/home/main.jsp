<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="메인"/>
<%@ include file="../common/head.jspf" %>

<section class="mt-8">
	<div class="container mx-auto">
		<div class="text-center main-box text-4xl">
			<h2>QAFE</h2>
			<h2 class="mt-3">코딩에 대한 질문, 답변을 위한 사이트</h2>
			<div class="mt-3">
				<a class="btn" href="${rq.joinUri }">회원가입</a>
				<a class="btn" href="${rq.loginUri }">로그인</a>
			</div>
		</div>
	</div>
</section>

<div class="layer-bg">
	<div class="layer">
	<h2>POPUP</h2>
	
	<button class="close-btn">close</button>
	</div>
</div>
	
<%@ include file="../common/foot.jspf" %>
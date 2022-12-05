<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="마이"/>
<%@ include file="../common/head.jspf" %>
<%@ page import="com.kpk.exam.demo.util.Ut" %>

<section class="mt-8">
	<div class="container mx-auto text-xl">
		<div class="table-box-type-1">
			<table class="table w-full">
				<tbody>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">가입일자</span>
							    <input name="regDate" value="${rq.loginedMember.regDate }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">총 답변 수</span>
							    <input name="loginId" value="${answerCount}" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">채택된 답변 수</span>
							    <input name="loginId" value="${choicedAnswerCount}" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">아이디</span>
							    <input name="loginId" value="${rq.loginedMember.loginId }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">이름</span>
							    <input name="name" value="${rq.loginedMember.name }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">닉네임</span>
							    <input name="nickname" value="${rq.loginedMember.nickname }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">전화번호</span>
							    <input name="cellphoneNum" value="${rq.loginedMember.cellphoneNum }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">이메일</span>
							    <input name="email" value="${rq.loginedMember.email }" disabled type="text" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td class="flex justify-between">							
							<button class="btn" type="button" onclick="history.back();">뒤로가기</button>
							<a href="../member/checkPassword?replaceUri=${Ut.getUriEncoded('../member/modify') }" class="btn accent">회원정보수정</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</section>

<%@ include file="../common/foot.jspf" %>
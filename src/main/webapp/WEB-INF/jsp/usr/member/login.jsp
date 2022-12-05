<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="로그인"/>
<%@ include file="../common/head.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl">
			<form class="table-box-type-1" method="post" action="../member/doLogin">
			<input type="hidden" name="afterLoginUri" value="${param.afterLoginUri }" />
				<table class="table w-full">
					<tbody>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">아이디</span>
								    <input name="loginId" type="text" placeholder="아이디를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>								
								<div class="loginId-msg"></div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">비밀번호</span>
								    <input name="loginPw" type="text" placeholder="비밀번호를 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-end">
								<a class="btn mr-1" href="${rq.joinUri }">회원가입</a> 
								<button class="btn accent" type="submit">로그인</button>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">뒤로가기</button>
								<div>
									<a href="${rq.findLoginIdUri }" class="btn btn-active btn-ghost" type="submit">아이디 찾기</a>
									<a href="${rq.findLoginPwUri }" class="btn btn-active btn-ghost" type="submit">비밀번호 찾기</a>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				
			</form>
		</div>
	</section>
	
<%@ include file="../common/foot.jspf" %>
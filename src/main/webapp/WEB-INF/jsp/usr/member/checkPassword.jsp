<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="비밀번호 재확인"/>
<%@ include file="../common/head.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl">
			<form class="table-box-type-1" method="post" action="../member/doCheckPassword">
				<input type="hidden" name="replaceUri" value="${param.replaceUri }"/>
				<table class="table w-full">
					<tbody>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">아이디</span>
								    <input name="loginId" value="${rq.loginedMember.loginId }" disabled type="text" placeholder="아이디를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
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
							<td class="flex justify-between">
								<button class="btn btn-warning" type="button" onclick="history.back();">뒤로가기</button>
								<button class="btn btn-accent" type="submit">확인</button>
							</td>
						</tr>
					</tbody>
				</table>
				
			</form>
		</div>
	</section>
	
<%@ include file="../common/foot.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="비밀번호 찾기" />
<%@ include file="../common/head.jspf"%>

<script>
	let MemberFindLoginPw__submitDone = false;
	function MemberFindLoginPw__submit(form) {
		if (MemberFindLoginPw__submitDone) {
			alert('처리중입니다');
			return;
		}
		form.loginId.value = form.loginId.value.trim();
		if (form.loginId.value.length == 0) {
			alert('아이디를 입력해주세요');
			form.loginId.focus();
			return;
		}
		form.email.value = form.email.value.trim();
		if (form.email.value.length == 0) {
			alert('이메일을 입력해주세요');
			form.email.focus();
			return;
		}
		MemberFindLoginPw__submitDone = true;
		form.submit();
	}
</script>

<section class="mt-8 text-xl">
	<div class="container mx-auto px-3">
		<form class="table-box-type-1" method="POST" action="../member/doFindLoginPw"
			onsubmit="MemberFindLoginPw__submit(this) ; return false;"
		>
			<input type="hidden" name="afterFindLoginPwUri" value="${param.afterFindLoginPwUri}" />
			<table class="table w-full">
				<colgroup>
					<col width="200" />
				</colgroup>

				<tbody>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">아이디</span>
							    <input name="loginId" type="text" placeholder="아이디를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">이메일</span>
							    <input name="email" type="text" placeholder="이메일을 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td class="flex justify-end">
							<button class="btn btn-active btn-ghost" type="submit">비밀번호 찾기</button>
						</td>
					</tr>
					<tr>
						<td class="flex justify-between">
							<button class="btn-text-link btn btn-active btn-ghost" type="button" onclick="history.back();">뒤로가기</button>
							
							<div>
								<a href="/usr/member/login" class="btn btn-active btn-ghost" type="submit">로그인</a>
								<a href="${rq.findLoginIdUri }" class="btn btn-active btn-ghost" type="submit">아이디 찾기</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</section>
<%@ include file="../common/foot.jspf"%>
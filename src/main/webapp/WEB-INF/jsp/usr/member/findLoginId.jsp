<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="아이디 찾기" />
<%@ include file="../common/head.jspf"%>

<script>
	let MemberFindLoginId__submitDone = false;
	function MemberFindLoginId__submit(form) {
		if (MemberFindLoginId__submitDone) {
			alert('처리중입니다');
			return;
		}
		form.name.value = form.name.value.trim();
		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요');
			form.name.focus();
			return;
		}
		form.email.value = form.email.value.trim();
		if (form.email.value.length == 0) {
			alert('이메일을 입력해주세요');
			form.email.focus();
			return;
		}
		MemberFindLoginId__submitDone = true;
		form.submit();
	}
</script>

<section class="mt-8 text-xl">
	<div class="container mx-auto px-3">
		<form class="table-box-type-1" method="POST" action="../member/doFindLoginId"
			onsubmit="MemberFindLoginId__submit(this) ; return false;"
		>
			<input type="hidden" name="afterFindLoginIdUri" value="${param.afterFindLoginIdUri}" />
			<table class="table w-full">

				<tbody>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
							    <span class="bg-primary">이름</span>
							    <input name="name" type="text" placeholder="이름을 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
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
							<button class="btn btn-active btn-ghost" type="submit">아이디 찾기</button>
						</td>
					</tr>
					<tr>
						<td class="flex justify-between">
							<button class="btn-text-link btn btn-active btn-ghost" type="button" onclick="history.back();">뒤로가기</button>
							<div>
								<a href="/usr/member/login" class="btn btn-active btn-ghost" type="submit">로그인</a>
								<a href="/usr/member/findLoginPw" class="btn btn-active btn-ghost" type="submit">비밀번호 찾기</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>

	<div class="container mx-auto btns">
	</div>

</section>
<%@ include file="../common/foot.jspf"%>
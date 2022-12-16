<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="비밀번호 확인"/>
<%@ include file="../common/head.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl">
			<form class="table-box-type-1" method="post" action="../member/doCheckPassword" onsubmit="MemberCheckPassword__submit(this); return false;">
				<input type="hidden" name="replaceUri" value="${param.replaceUri }"/>
				<input type="hidden" name="loginPw">
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
								    <input name="loginPwInput" type="text" placeholder="비밀번호를 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">뒤로가기</button>
								<button class="btn accent" type="submit">확인</button>
							</td>
						</tr>
					</tbody>
				</table>
				
			</form>
		</div>
	</section>
	
<script>
	let MemberCheckPassword__submitDone = false;
	function MemberCheckPassword__submit(form) {
		if (MemberCheckPassword__submitDone) {
			alert('처리중입니다.');
			return;
		}
		
		form.loginPwInput.value = form.loginPwInput.value.trim();
		
		if (form.loginPwInput.value.length == 0) {
			alert('비밀번호를 입력해주세요.');
			form.loginPwInput.focus();
			return;
		}
		
		form.loginPw.value = sha256(form.loginPwInput.value);
		form.loginPwInput.value = '';
		
		MemberCheckPassword__submitDone = true;
		form.submit();
	}
</script>
	
<%@ include file="../common/foot.jspf" %>
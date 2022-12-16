<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="회원가입"/>
<%@ include file="../common/head.jspf" %>
<%@ page import="com.kpk.exam.demo.util.Ut" %>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<section class="mt-8">
	<div class="container mx-auto text-xl">
		<form onsubmit="submitJoinForm(this); return false;" class="table-box-type-1" method="post" action="../member/doJoin">
		<input type="hidden" name="afterLoginUri" value="${param.afterLoginUri }" />
			<div class="table-box-type-1">
				<table class="table w-full">
					<tbody>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">아이디</span>
								    <input name="loginId" type="text" onkeyup="debouncedCheckLoginIdDup(this);" placeholder="아이디를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
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
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">비밀번호 확인</span>
								    <input name="loginPwConfirm" type="text" placeholder="비밀번호를 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">이름</span>
								    <input name="name" type="text" placeholder="이름을 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">닉네임</span>
								    <input name="nickname" type="text" placeholder="닉네임을 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">프로필 이미지</span>
	    							<input accept="image/gif, image/jpeg, image/png" name="file__member__0__extra__profileImg__1"
										placeholder="프로필 이미지를 선택해주세요" type="file"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">전화번호</span>
								    <input name="cellphoneNum" type="text" placeholder="전화번호를 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">이메일</span>
								    <input name="email" type="text" placeholder="이메일을 입력해주세요" class="input input-bordered w-full" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">취소</button>
								<button type="submit" class="btn accent">회원가입</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
		</form>
	
		<div class="btns mt-3">
		</div>
		
	</div>
</section>

<script>
	let validLoginId = "";

	let submitJoinFormDone = false;

	function checkLoginIdDup(el){
		const form = $(el).closest("form").get(0);
		
		if (form.loginId.value.length == 0){
			validLoginId = "";
			return;
		}
		if (validLoginId == form.loginId.value){
			return;
		}
		
		$(".loginId-msg").html('<div class="mt-2">확인중...</div>');
		
		$.get("../member/getLoginIdDup", {
			isAjax : "Y",
			loginId :form.loginId.value
		},function(data){
			if(data.success) {
				$(".loginId-msg").html("<div class='mt-2 text-green-600'>" + data.msg + "</div>");
				validLoginId = data.data1;
			}else {
				$(".loginId-msg").html("<div class='mt-2 text-red-600'>" + data.msg + "</div>");
				validLoginId = "";
			}
			
			if (data.resultCode == "F-B"){
				alert(data.msg);
				location.replace("/");
			}
		},"json");
	}
	
	const debouncedCheckLoginIdDup = _.debounce(checkLoginIdDup, 300);

	function submitJoinForm(form){
		if(submitJoinFormDone){
			alert('처리중 입니다.');
			return;
		}
		
		form.loginId.value = form.loginId.value.trim();
		
		if(form.loginId.value.length == 0){
			alert('아이디를 입력해주세요.');
			form.loginId.focus();
			return;
		}
		
		if(form.loginId.value != validLoginId){
			alert('사용할 수 없는 아이디입니다.');
			form.loginId.focus();
			return;
		}
		
		form.loginPw.value = form.loginPw.value.trim();
		
		if(form.loginPw.value.length == 0){
			alert('비밀번호를 입력해주세요.');
			form.loginPw.focus();
			return;
		}
		
		if(form.loginPwConfirm.value.length > 0){
			form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
			
			if(form.loginPwConfirm.value.length == 0){
				alert('비밀번호 확인을 입력해주세요.');
				form.loginPwConfirm.focus();
				return;
			}
		}
		
		if(form.loginPw.value != form.loginPwConfirm.value){
			alert('비밀번호가 일치하지 않습니다.');
			form.loginPw.focus();
			return;
		}
		
		form.name.value = form.name.value.trim();
		
		if(form.name.value.length == 0){
			alert('이름을 입력해주세요.');
			form.name.focus();
			return;
		}
		
		form.nickname.value = form.nickname.value.trim();
		
		if(form.nickname.value.length == 0){
			alert('닉네임을 입력해주세요.');
			form.nickname.focus();
			return;
		}
		
		form.cellphoneNum.value = form.cellphoneNum.value.trim();
		
		if(form.cellphoneNum.value.length == 0){
			alert('전화번호를 입력해주세요.');
			form.cellphoneNum.focus();
			return;
		}
		
		form.email.value = form.email.value.trim();
		
		if(form.email.value.length == 0){
			alert('이메일을 입력해주세요.');
			form.email.focus();
			return;
		}
		
		const maxSizeMb = 10;
		const maxSize = maxSizeMb * 1204 * 1204;
		
		const profileImgFileInput = form["file__member__0__extra__profileImg__1"];
		
		if (profileImgFileInput.value) {
			if (profileImgFileInput.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				profileImgFileInput.focus();
				return;
			}
		}
		
		form.submit();
		
		submitJoinFormDone = true;
	}
</script>

<%@ include file="../common/foot.jspf" %>
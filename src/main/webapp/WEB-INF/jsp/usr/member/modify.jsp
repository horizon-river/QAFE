<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.kpk.exam.demo.util.Ut"%>
<c:set var="pageTitle" value="회원정보 수정"/>
<%@ include file="../common/head.jspf" %>
<%@ page import="com.kpk.exam.demo.util.Ut" %>

<section class="mt-8">
	<div class="container mx-auto text-xl">
		<div class="table-box-type-1">
			<form class="table-box-type-1" method="post" enctype="multipart/form-data" action="../member/doModify" onsubmit="MemberModify__submit(this); return false;">
				<input type="hidden" name="memberModifyAuthKey" value="${param.memberModifyAuthKey }" />
				<input type="hidden" name="loginPw">
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
								    <span class="bg-primary">새 비밀번호</span>
								    <input name="newLoginPw" type="password" placeholder="새 비밀번호를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">새 비밀번호 확인</span>
								    <input name="loginPwConfirm" type="password" placeholder="새 비밀번호를 다시 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">이름</span>
								    <input name="name" value="${rq.loginedMember.name }" type="text" placeholder="이름을 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">닉네임</span>
								    <input name="nickname" value="${rq.loginedMember.nickname }" type="text" placeholder="닉네임을 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
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
								  
		
									<div class="mt-2">
									  	<img class="w-40 h-40 object-cover" src="${rq.getProfileImgUri(rq.loginedMember.id)}" alt=""
											onerror="${rq.removeProfileImgIfNotExitOnErrorHtmlAttr}"/>
										<label class="cursor-pointer inline-flex font-bold">
											<span class="label-text mr-2 mt-1">이미지 삭제</span>
											<input type="checkbox" name="deleteFile__member__0__extra__profileImg__1" class="checkbox" value="Y" />	
										</label>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">전화번호</span>
								    <input name="cellphoneNum" value="${rq.loginedMember.cellphoneNum }" type="text" placeholder="전화번호를 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">이메일</span>
								    <input name="email" value="${rq.loginedMember.email }" type="text" placeholder="이메일을 입력해주세요" class="input input-bordered w-full" autocomplete="off"/>
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">뒤로가기</button>
								<button class="btn accent" type="submit" >수정</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</section>
	
	<script type="text/javascript">
		let MemberModify__submitDone = false;
		function MemberModify__submit(form) {
			if(MemberModify__submitDone){
				alert('처리중입니다');
				return;
			}
			
			form.newLoginPw.value = form.newLoginPw.value.trim();
			
			if(form.newLoginPw.value.length > 0){
				form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
				
				if(form.loginPwConfirm.value.length == 0){
					alert('비밀번호확인을 입력해주세요.');
					form.loginPwConfirm.focus();
					return;
				}
			}
			
			if(form.newLoginPw.value != form.loginPwConfirm.value){
				alert('비밀번호확인이  일치하지 않습니다.');
				form.loginPwConfirm.focus();
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
			
			const deleteProfileImgFileInput = form["deleteFile__member__0__extra__profileImg__1"];
			if (deleteProfileImgFileInput.checked) {
				form["file__member__0__extra__profileImg__1"].value = '';
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
			
			if (form.newLoginPw.value.length > 0) {
				form.loginPw.value = sha256(form.newLoginPw.value);
				form.newLoginPw.value = '';
				form.loginPwConfirm.value = '';
			}
			
			MemberModify__submitDone = true;
			form.submit();
			
		}
	</script>

<%@ include file="../common/foot.jspf" %>
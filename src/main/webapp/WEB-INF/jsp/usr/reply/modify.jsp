<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REPLY MODIFY"/>
<%@ include file="../common/head.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto px-3 text-xl">
			<form class="table-box-type-1" method="post" action="../reply/doModify" onsubmit="ReplyModify__submit(this); return false;">
			<input name="id" type="hidden" value="${reply.id }"/>
			<input type="hidden" name="replaceUri" value="${param.replaceUri }"/>
				<table class="table table-zebra w-full">
					<tbody>
						<tr>
							<th>게시물 번호</th>
							<td>
								<div class="badge badge-lg">${reply.relId }</div>
							</td>
						</tr>
						<tr>
							<th>게시물 제목</th>
							<td>
								<div class="badge badge-lg">${relDataTitle }</div>
							</td>
						</tr>
						<tr>
							<th>번호</th>
							<td><div class="badge badge-lg">${reply.id }</div></td>
						</tr>
						<tr>
							<th>작성날짜</th>
							<td>${reply.regDate }</td>
						</tr>
						<tr>
							<th>수정날짜</th>
							<td>${reply.updateDate }</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td>${reply.writer }</td>
						</tr>
						<tr>
							<th>추천</th>
							<td>
								<span class="badge">${reply.goodReactionPoint }</span>
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td>
								<textarea class="w-full textarea textarea-bordered" name="body" placeholder="내용을 입력해주세요.">${reply.body}</textarea>
							</td>
						</tr>
						<tr>
							<th></th>
							<td><button class="btn btn-success" type="submit">수정</button></td>
						</tr>
					</tbody>
				</table>
				
			</form>
			
			<div class="btns mt-3">
				<a class="btn btn-warning" href="${param.replaceUri }">뒤로가기</a>
			</div>
		</div>
	</section>
	
	<script type="text/javascript">
		// 댓글 관련
		let ReplyModify__submitDone = false;
		function ReplyModify__submit(form) {
			if(ReplyModify__submitDone){
				return;
			}
			
			form.body.value = form.body.value.trim();
			
			if(form.body.value.length == 0){
				alert('내용을 입력해주세요.');
				form.body.focus();
				return;
			}
			
			if(form.body.value.length < 2){
				alert('2글자 이상 입력해주세요.');
				form.body.focus();
				return;
			}
			
			ReplyModify__submitDone = true;
			form.submit();
		}
	</script>
<%@ include file="../common/foot.jspf" %>
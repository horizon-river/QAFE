<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="댓글 수정"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl">
			<form class="table-box-type-1" method="post" action="../reply/doModify" onsubmit="ReplyModify__submit(this); return false;">
			<input name="id" type="hidden" value="${reply.id }"/>
			<input type="hidden" name="replaceUri" value="${param.replaceUri }"/>
				<table class="table w-full">
					<tbody>
						<tr>
							<td>
								<div>
									<p class="text-4xl">${related.title }</p>
								</div>
								<div class="mt-3 flex justify-between">
									<div>
										<span class="mr-3">${related.writer }</span>
										<span>
											<c:if test="${related.regDate != related.updateDate}">
												${related.updateDate }
												<span class="badge">수정됨</span>
											</c:if>
											<c:if test="${related.regDate == related.updateDate}">
												${related.regDate }
											</c:if>
										</span>
									</div>
									
									<div>
										<span class="badge">조회수&nbsp;<span class="article-detail__hit-count"> ${related.hitCount }</span></span>
										<span class="badge">추천수 ${related.goodReactionPoint }</span>
										<c:if test="${board.id == 2}">
											<span class="badge">답변수 ${related.extra__answerCount }</span>
										</c:if>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="toast-ui-viewer">
									<script type="text/x-template">${related.body }</script>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<div>
									댓글 작성/수정일
								</div>
								<div>
									<span class="badge">작성날짜 : ${reply.regDate }</span>
									<span class="badge">수정날짜 : ${reply.updateDate }</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<textarea class="w-full textarea textarea-bordered" name="body" placeholder="내용을 입력해주세요.">${reply.body}</textarea>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">취소</button>
								<button class="btn" type="submit">수정</button>
							</td>
						</tr>
					</tbody>
				</table>
				
			</form>
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
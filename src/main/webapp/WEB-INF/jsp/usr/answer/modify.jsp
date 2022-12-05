<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="답변 수정"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto px-3 text-xl">
			<form class="table-box-type-1" method="post" action="../answer/doModify" onsubmit="AnswerModify__submit(this); return false;">
				<input name="id" type="hidden" value="${answer.id }"/>
				<input type="hidden" name="replaceUri" value="${param.replaceUri }"/>
				<input type="hidden" name="body" />
				<table class="table w-full">
					<tbody>
						<tr>
							<td>
								<div>
									<p class="text-4xl">${article.title }</p>
								</div>
								<div class="mt-3 flex justify-between">
									<div>
										<span class="mr-3">${article.writer }</span>
										<span>
											<c:if test="${article.regDate != article.updateDate}">
												${article.updateDate }
												<span class="badge">수정됨</span>
											</c:if>
											<c:if test="${article.regDate == article.updateDate}">
												${article.regDate }
											</c:if>
										</span>
									</div>
									
									<div>
										<span class="badge">조회수&nbsp;<span class="article-detail__hit-count"> ${article.hitCount }</span></span>
										<span class="badge">추천수 ${article.goodReactionPoint }</span>
										<c:if test="${board.id == 2}">
											<span class="badge">답변수 ${article.extra__answerCount }</span>
										</c:if>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="toast-ui-viewer">
									<script type="text/x-template">${article.body }</script>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<div>
									답변 작성/수정일
								</div>
								<div>
									<span class="badge">작성날짜 : ${answer.regDate }</span>
									<span class="badge">수정날짜 : ${answer.updateDate }</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template">${answer.body}</script>
								</div>
							</td>
						</tr>
						<tr>
							<td class="flex justify-between">
								<button class="btn" type="button" onclick="history.back();">취소</button>
								<button class="btn accent" type="submit">수정</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</section>
	
	<script type="text/javascript">
		let AnswerModify__submitDone = false;
		function AnswerModify__submit(form) {
			if(AnswerModify__submitDone){
				return;
			}
			
			const editor = $(form).find('.toast-ui-editor').data('data-toast-editor');
			const markdown = editor.getMarkdown().trim();
					
			if(markdown.length == 0){
				alert('내용을 입력해주세요.');
				editor.focus();
				
				return;
			}
			
			form.body.value = markdown;
			
			form.submit();
			
			AnswerModify__submitDone = true;
		}
	</script>
<%@ include file="../common/foot.jspf" %>
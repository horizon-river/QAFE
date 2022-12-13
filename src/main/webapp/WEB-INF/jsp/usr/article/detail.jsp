<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="${board.name} 상세"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<script>
	const params = {};
	params.id = parseInt('${param.id}');
</script>

<script>
	// 조회수 관련
	function ArticleDetail__increaseHitCount(){
		const localStorageKey = 'article__' + params.id + '__alreadyView';
		
		if(localStorage.getItem(localStorageKey)){
			return;
		}
		localStorage.setItem(localStorageKey, true);
		
		$.get('../article/doIncreaseHitCountRd', {
			id : params.id,
			ajaxMode : 'Y',
		}, function(data) {
			$('.article-detail__hit-count').empty().html(data.data1);
		}, 'json');
	}
	
	ArticleDetail__increaseHitCount();
	
	$(function(){
		setTimeout(ArticleDetail__increaseHitCount(), 2000);
	});
</script>

<script type="text/javascript">
	// 댓글 관련
	let ReplyWrite__submitFormDone = false;
	function ReplyWrite__submitForm(form) {
		if(ReplyWrite__submitFormDone){
			alert('처리중 입니다.');
			return;
		}
		
		form.body.value = form.body.value.trim();
		
		if(form.body.value == 0){
			alert('내용을 입력해주세요.');
			form.body.focus();
			return;
		}
		
		form.submit();
		
		ReplyWrite__submitFormDone = true;
	}
</script>

<script type="text/javascript">
	// 답변 관련
	let AnswerWrite__submitFormDone = false;
	function AnswerWrite__submitForm(form) {
		if(AnswerWrite__submitFormDone){
			alert('처리중 입니다.');
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
		
		AnswerWrite__submitFormDone = true;
	}
</script>

<section class="mt-8">
	<div class="container mx-auto text-xl">
		<div class="table-box-type-1">
			<table class="table w-full">
				<tbody>
					<tr>
						<td>
							<div class="text-4xl">
								${article.title } 
								<c:if test="${article.extra__choiceStatus == 1 }">
									<span class="badge active">채택됨</span>
								</c:if></div>
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
                                    <c:set var="reactionPoint" value="${article.goodReactionPoint - article.badReactionPoint }" />
									<span class="badge">추천수 ${reactionPoint }</span>
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
						<td class="text-center">
							<c:if test="${actorCanMakeReaction }">
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.encodedCurrentUri}" 
								class="btn btn-outline btn-sm">좋아요 👍</a>
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doBadReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.encodedCurrentUri}" 
								class="btn btn-outline btn-sm">싫어요 👎</a>
							</c:if>
							<c:if test="${actorCanCancelGoodReaction }">
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doCancelGoodReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.encodedCurrentUri}"  
								class="btn active btn-sm">좋아요 👍</a>
								<span>&nbsp;</span>
								<a onclick="alert(this.title); return false;" title="좋아요를 먼저 취소해주세요." href="#"
								class="btn btn-outline btn-sm">싫어요 👎</a>	
							</c:if>
							<c:if test="${actorCanCancelBadReaction }">
								<span>&nbsp;</span>
								<a onclick="alert(this.title); return false;" title="싫어요를 먼저 취소해주세요." href="#" 
								class="btn btn-outline btn-sm">좋아요 👍</a>
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doCancelBadReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.encodedCurrentUri}" 
								class="btn active btn-sm">싫어요 👎</a>	
							</c:if>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</section>

<section class="mt-5">
	<div class="container mx-auto">
		<div class="btns mt-3 text-right">
			<c:if test="${article.extra__actorCanModify && article.extra__choiceStatus == 1}">
				<span class="mx-5 text-red-500 underline">채택된 게시물은 수정 및 삭제가 불가능합니다.</span>
			</c:if>
			<c:if test="${empty param.listUri}">
				<button class="btn primary" type="button" onclick="history.back();">뒤로가기</button>			
			</c:if>
			<c:if test="${not empty param.listUri}">
				<a class="btn primary" href="${param.listUri }">뒤로가기</a>			
			</c:if>
			<c:if test="${article.extra__actorCanModify && article.extra__choiceStatus == 0}">
				<a class="btn active"  href="../article/modify?id=${article.id }">수정</a>
			</c:if>
			<c:if test="${article.extra__actorCanDelete && article.extra__choiceStatus == 0}">
				<a class="btn accent" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" href="../article/doDelete?id=${article.id }">삭제</a>
			</c:if>
		</div>
	</div>
</section>

<section class="mt-5">
	<div class="container mx-auto py-3 reply-wrap">
		<h2>댓글 <span class="text-red-500">${replies.size() }</span>개</h2>
		<table class="table w-full mt-3 reply-table">
			<tbody>
				<c:forEach var="reply" items="${replies }" varStatus="status">
					<tr class="hover">
						<td class="flex justify-between">
							<div class="flex content-center items-center">
								<span class="w-40">
									${reply.writer }
									<c:if test="${reply.memberId == article.memberId}">
										<span class="badge badge-sm accent">글쓴이</span>
									</c:if>
								</span>
								<span>${reply.getForPrintBody()}</span>
							</div>
							<div>
								<c:if test="${reply.extra__actorCanModify}">
									<a class="btn btn-ghost btn-xs" href="../reply/modify?id=${reply.id }&replaceUri=${rq.encodedCurrentUri }">수정</a>
								</c:if>
								<c:if test="${reply.extra__actorCanDelete}">
									<a class="btn btn-ghost btn-xs" onclick="if(confirm('삭제 하시겠습니까?') == false) return false;" href="../reply/doDelete?id=${reply.id }&replaceUri=${rq.encodedCurrentUri }">삭제</a>
								</c:if>
								${reply.regDate }
							</div>
						</td>
					</tr>					
				</c:forEach>
			</tbody>
		</table>
	</div>
</section>

<section>
	<div class="container mx-auto py-3">
<!-- 		<h2>댓글 작성</h2> -->
		<c:if test="${rq.logined }">
			<form class="table-box-type-1" method="post" action="../reply/doWrite" onsubmit="ReplyWrite__submitForm(this); return false;">
				<input type="hidden" name="relTypeCode" value="article" />
				<input type="hidden" name="relId" value="${article.id }" />
				<input type="hidden" name="replaceUri" value="${rq.currentUri }"/>
				<table class="table w-full mt-3 reply-writer">
					<colgroup>
						<col width="120"/>
						<col />
					</colgroup>
					<tbody>
						<tr>
							<td>${rq.loginedMember.nickname }</td>
							<td class="flex">
								<textarea class="w-full textarea textarea-bordered" name="body" placeholder="댓글을 입력해주세요." rows="3"></textarea>
								<button class="btn primary" type="submit">댓글작성</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</c:if>
		<c:if test="${rq.notLogined }">
			<p>댓글 작성은 <a class="btn active" href="${rq.loginUri }">로그인</a> 후 이용해주세요.</p>
		</c:if>
	</div>
</section>

<c:if test="${board.id == 2}">
<section class="mt-10">
	<div class="container mx-auto mb-10">
		<h2>답변 <span class="text-red-500">${article.extra__answerCount }</span>개</h2>
		<table class="table w-full mt-3 answer-table">
			<tbody>
				<c:forEach var="answer" items="${answers }" varStatus="status">
					<tr>
						<td>
							<div class="mt-3 flex justify-between">
								<span class="mr-3 text-xl">
									${answer.writer }
									<c:if test="${answer.choiceStatus == 1 }">
										<span class="badge active">채택됨</span>
									</c:if>
									<c:if test="${article.extra__actorCanModify && article.extra__choiceStatus == 0}">
										<a class="badge" href="../answer/doChoice?id=${answer.id }" 
										onclick="if(confirm('이 답변을 채택 하시겠습니까?') == false) return false;" 
										>답변채택</a>
									</c:if>
								</span>
								<span>
									<c:if test="${answer.regDate != answer.updateDate}">
										${answer.updateDate }
										<span class="badge">수정됨</span>
									</c:if>
									<c:if test="${answer.regDate == answer.updateDate}">
										${answer.regDate }
									</c:if>
								</span>
							</div>
							<div class="toast-ui-viewer mt-5 mb-10">
								<script type="text/x-template">${answer.body }</script>
							</div>
							<div class="text-right">
								<c:if test="${answer.extra__actorCanModify }">
									<a class="btn active"  href="../answer/modify?id=${answer.id }">수정</a>
								</c:if>
								<c:if test="${answer.extra__actorCanDelete }">
									<a class="btn accent" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" href="../answer/doDelete?id=${answer.id }">삭제</a>
								</c:if>
							</div>
						</td>
					</tr>					
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<c:if test="${rq.logined && actorCanWriteAnswer && article.extra__actorCanModify == false && article.extra__choiceStatus == 0}">
		<div class="container mx-auto mb-10">
			<p class="text-3xl flex">답변 작성</p>
			<form class="table-box-type-1" method="post" action="../answer/doWrite" onsubmit="AnswerWrite__submitForm(this); return false;">
				<input type="hidden" name="body" />
				<input type="hidden" name="relTypeCode" value="article" />
				<input type="hidden" name="relId" value="${article.id }" />
				<input type="hidden" name="replaceUri" value="${rq.currentUri }"/>
				<table class="table w-full mt-3">
					<tbody>
						<tr>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template"></script>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<div>
					<button class="btn btn-block primary" type="submit">답변작성</button>
				</div>
			</form>
		</div>
	</c:if>
	<c:if test="${rq.notLogined && article.extra__choiceStatus == 0}">
		<div class="container mx-auto mb-10">
			답변 작성은 <a class="btn active" href="${rq.loginUri }">로그인</a> 후 이용해주세요.
		</div>
	</c:if>
</section>
</c:if>
<%@ include file="../common/foot.jspf" %>
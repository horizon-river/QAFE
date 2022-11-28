<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="ARTICLE MODIFY"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto px-3 text-xl">
			<form class="table-box-type-1" method="post" action="../article/doModify" onsubmit="ArticleModify__submit(this); return false;">
				<input type="hidden" name="body" />
				<table class="table table-zebra w-full">
					<tbody>
						<tr>
							<th>번호</th>
							<td><input name="id" type="hidden" value="${article.id }"/><div class="badge badge-lg">${article.id }</div></td>
						</tr>
						<tr>
							<th>작성날짜</th>
							<td>${article.regDate }</td>
						</tr>
						<tr>
							<th>수정날짜</th>
							<td>${article.updateDate }</td>
						</tr>
						<tr>
							<th>조회수</th>
							<td>
								<span class="badge article-detail__hit-count">${article.hitCount }</span>
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td>${article.writer }</td>
						</tr>
						<tr>
							<th>추천</th>
							<td>
								<span class="badge">${article.goodReactionPoint }</span>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input class="input input-bordered w-full" name="title" type="text" placeholder="제목을 입력해주세요." value="${article.title}" /></td>
						</tr>
						<tr>
							<th>내용</th>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template">${article.body}</script>
								</div>
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
				<button class="btn btn-warning" type="button" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</section>
	
	<script type="text/javascript">
		let ArticleModify__submitDone = false;
		function ArticleModify__submit(form) {
			if(ArticleModify__submitDone){
				return;
			}
			
			form.body.value = form.body.value.trim();
			
			if(form.title.value.length == 0){
				alert('제목을 입력해주세요.');
				form.body.focus();
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
			
			ArticleModify__submitDone = true;
		}
	</script>
<%@ include file="../common/foot.jspf" %>
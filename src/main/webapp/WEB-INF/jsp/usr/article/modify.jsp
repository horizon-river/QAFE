<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 수정"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl">
			<form class="table-box-type-1" method="post" action="../article/doModify" onsubmit="ArticleModify__submit(this); return false;">
				<input type="hidden" name="body" />
				<table class="table w-full">
					<tbody>
						<tr>
							<td class="flex justify-between">
								<div>
									번호 : <input name="id" type="hidden" value="${article.id }"/><div class="badge badge-lg">${article.id }</div>
								</div>
								<div>
									<span class="badge">작성날짜 : ${article.regDate }</span>
									<span class="badge">수정날짜 : ${article.updateDate }</span>
								</div>
								<div>
									<span class="badge">조회수 ${article.hitCount }</span>
									<span class="badge">추천 ${article.goodReactionPoint }</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-control">
								  <label class="input-group">
								    <span class="bg-primary">게시판 구분</span>
								    <input disabled type="text" value="Q&A" class="input input-bordered w-full" autocomplete="off" />
								  </label>
								</div>
							</td>
						</tr>
						<tr>
							<td><input required="required" type="text" value="${article.title }"  
							class="input input-bordered input-ghost w-full" name="title" placeholder="제목을 입력해주세요."/></td>
						</tr>
						<tr>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template">${article.body}</script>
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
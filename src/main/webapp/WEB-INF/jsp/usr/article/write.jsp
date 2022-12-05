<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="글쓰기"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<script>
	let submitWriteFormDone = false;

	function submitWriteForm(form){
		if(submitWriteFormDone){
			alert('처리중 입니다.');
			return;
		}
		
		form.title.value = form.title.value.trim();
		
		if(form.title.value == 0){
			alert('제목을 입력해주세요.');
			form.title.focus();
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
		
		submitWriteFormDone = true;
	}
</script>

<section class="mt-8">
	<div class="container mx-auto text-xl">
		<form onsubmit="submitWriteForm(this); return false;" class="table-box-type-1" method="post" action="../article/doWrite">
		<input type="hidden" name="body" />
			<table class="table w-full">
				<tbody>
					<tr>
						<td>
							<div class="form-control">
							  <label class="input-group">
                                <c:if test="${!rq.loginedMember.isAdmin() }">
    							    <span class="bg-primary">게시판 구분</span>
    							    <input disabled type="text" value="질문게시판" class="input input-bordered w-full" autocomplete="off" />
                            	    <input name="boardId" value="2" readonly type="hidden" autocomplete="off"/>
                                </c:if>
                                <c:if test="${rq.loginedMember.isAdmin() }">
                                    <select name="boardId" class="select select-bordered w-full">
                                      <option disabled selected>작성할 게시판을 선택해주세요</option>
                                      <option value="2">질문게시판</option>
                                      <option value="1">공지사항</option>
                                    </select>
                                </c:if>
							  </label>
							</div>
						</td>
					</tr>
					<tr>
						<td><input required="required" type="text" class="input input-bordered input-ghost w-full" name="title" placeholder="제목을 입력해주세요."/></td>
					</tr>
					<tr>
						<td>
							<div class="toast-ui-editor">
								<script type="text/x-template"></script>
							</div>
						</td>
					</tr>
					<tr>
						<td class="flex justify-between">
							<button class="btn" type="button" onclick="history.back();">취소</button>
							<button class="btn accent" type="submit">작성</button>
						</td>
					</tr>
				</tbody>
			</table>
			
		</form>
		
		<div class="btns mt-3">
		</div>
	</div>
</section>
	
<%@ include file="../common/foot.jspf" %>
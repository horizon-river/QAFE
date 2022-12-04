<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="랭킹 리스트"/>
<%@ include file="../common/head.jspf" %>

	<section class="mt-8">
		<div class="container mx-auto text-xl rank-wrap">
			<div class="flex w-full">
		  		<div class="grid flex-grow card rounded-box place-items-center">
					<h2>답변을 제일 많이 한 회원</h2>
					<table class="table w-full mt-3">
						<thead>
							<tr>
								<th>순위</th>
								<th>닉네임</th>
								<th>작성 수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="rank" items="${totalAnswerRank }" varStatus="status">
								<tr>
									<td>${status.index + 1 }</td>
									<td>${rank.nickname }</td>
									<td>${rank.resultCount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="w-10"></div>
				<div class="grid flex-grow card rounded-box place-items-center">
					<h2>질문을 제일 많이 한 회원</h2>
					<table class="table w-full mt-3">
						<thead>
							<tr>
								<th>순위</th>
								<th>닉네임</th>
								<th>작성 수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="rank" items="${totalQuestionRank }" varStatus="status">
								<tr>
									<td>${status.index + 1 }</td>
									<td>${rank.nickname }</td>
									<td>${rank.resultCount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			<div class="flex w-full mt-10">
		  		<div class="grid flex-grow card rounded-box place-items-center">
					<h2>답변 채택을 제일 많이 받은 회원</h2>
					<table class="table w-full mt-3">
						<thead>
							<tr>
								<th>순위</th>
								<th>닉네임</th>
								<th>작성 수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="rank" items="${totalChoicedAnswerRank }" varStatus="status">
								<tr>
									<td>${status.index + 1 }</td>
									<td>${rank.nickname }</td>
									<td>${rank.resultCount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="w-10"></div>
				<div class="grid flex-grow card rounded-box place-items-center">
					<h2>질문 채택을 제일 많이 한 회원</h2>
					<table class="table w-full mt-3">
						<thead>
							<tr>
								<th>순위</th>
								<th>닉네임</th>
								<th>작성 수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="rank" items="${totalChoicedMemberRank }" varStatus="status">
								<tr>
									<td>${status.index + 1 }</td>
									<td>${rank.nickname }</td>
									<td>${rank.resultCount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
	
<%@ include file="../common/foot.jspf" %>
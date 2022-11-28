<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>

<html lang="en">
<head>
	<meta charset="UTF-8" />
	<title>Ajax Test</title>
</head>
<!-- 제이쿼리 불러오기 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<style>
	.rs{
		border:6px solid black;
		margin-top: 30px;
		padding: 20px;
		font-size:3rem;
	}
	.rs-msg{
		border:6px solid red;
		margin-top: 30px;
		padding: 20px;
		font-size:3rem;
	}
	.rs-code{
		border:6px solid blue;
		margin-top: 30px;
		padding: 20px;
		font-size:3rem;
	}
</style>
<script>
	function callByAjaxV2(){
		var form = document.form1;
		
		var num1 = form.num1.value;
		var num2 = form.num2.value;
		
		let action = form.action;
		
		$.get(action, {
			num1 : num1,
			num2 : num2
		},function(data){
			$('.rs').empty().append(data);
		}, "html");
	}
	
	function callByAjaxV3(){
		var form = document.form1;
		
		var num1 = form.num1.value;
		var num2 = form.num2.value;
		
		let action = form.action;
		
		$.get(action, {
			num1 : num1,
			num2 : num2
		},function(data){
			data = data.split("/");
			var rs = data[0];
			var msg = data[1];
			
			$(".rs").text(rs);
			$(".rs-msg").text(msg);
		}, "html");
	}
	
	function callByAjaxV4(){
		var form = document.form1;
		
		var num1 = form.num1.value;
		var num2 = form.num2.value;
		
		let action = form.action;
		
		$.get(action, {
			num1 : num1,
			num2 : num2
		},function(data){
			data = data.split("/");
			var rs = data[0];
			var msg = data[1];
			var rsCode = data[2];
			
			$(".rs").text(rs);
			$(".rs-msg").text(msg);
			$(".rs-code").text(rsCode);
		}, "html");
	}
	
	// json 형태로 변환	
	function callByAjaxV5(){
		var form = document.form1;
		
		var num1 = form.num1.value;
		var num2 = form.num2.value;
		
		let action = './doPlusJson';
		
		$.get(action, {
			num1 : num1,
			num2 : num2
		},function(data){
			var rs = data.rs;
			var msg = data.msg;
			var rsCode = data.code;
			
			$(".rs").text(rs);
			$(".rs-msg").text(msg);
			$(".rs-code").text(rsCode);
		}, "json");
	}
</script>
<body>
	<h1>테스트</h1>
	
	<form name="form1" action="./doPlus">
		<div><input name="num1" type="text" placeholder="정수1"/></div>
		<div><input name="num2" type="text" placeholder="정수1"/></div>
		<input type="submit" value="더하기"/>
		<input onclick="callByAjaxV2();" type="button" value="더하기v2"/>
		<input onclick="callByAjaxV3();" type="button" value="더하기v3"/>
		<input onclick="callByAjaxV4();" type="button" value="더하기v4"/>
		<input onclick="callByAjaxV5();" type="button" value="더하기v5"/>
	</form>
	
	<h2>더한 결과</h2>
	<div class="rs"></div>
	
	<h2>더한 결과 메세지</h2>
	<div class="rs-msg"></div>
	
	<h2>더한 결과 코드</h2>
	<div class="rs-code"></div>
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="API Test" />

<%@ include file="../common/head.jspf" %>
<script>
	const API_KEY = 'h%2F%2FXvbDQnDribQf31tHLYvqMqrmh6ggZBRH7DkWnczgukxtocc1wux5ZaZGpfsNDhTucobqrOEwGbl6mLKeANw%3D%3D';

	let Lalocation;
	let Lolocation;
	
	async function getData() {
		const url = 'http://apis.data.go.kr/1180000/DaejeonNationalCemetery/Burialinfo042?name=홍길동&pageNo=1&numOfRows=10&serviceKey=' 
				+ API_KEY;
		const response = await fetch(url);
		const data = await response.json();
		console.log("data", data);
		
		Lalocation = data.body[0].latitude;
		Lolocation = data.body[0].longitude;
		console.log(Lalocation);
		console.log(Lolocation);
	}
	
	
	getData();
</script>


<div style="display:flex; justify-content:center;">
	<div id="map" style="width:100%; height:600px;"></div>
</div>
<button type="button" onclick="panTo();">지도 중심좌표 부드럽기 이동시키기</button>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=edf0e9cd1780a4fcc59d919c307c2c50"></script>
<script>
	var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
	var options = { //지도를 생성할 때 필요한 기본 옵션
		center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
		level: 3 //지도의 레벨(확대, 축소 정도)
	};
	
	var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
	
	const lat = 36.3701311788239;
	const lot = 127.298272866466;
	
	function panTo() {
	    // 이동할 위도 경도 위치를 생성합니다 
	    var moveLatLon = new kakao.maps.LatLng(lat, lot);
	    
	    // 지도 중심을 부드럽게 이동시킵니다
	    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
	    map.panTo(moveLatLon);            
	}      
	
	// 마커가 표시될 위치입니다 
	var markerPosition  = new kakao.maps.LatLng(lat, lot); 

	// 마커를 생성합니다
	var marker = new kakao.maps.Marker({
	    position: markerPosition
	});
	
	// 마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);	
</script>


<%@ include file="../common/foot.jspf" %>
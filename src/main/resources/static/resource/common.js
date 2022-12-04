$('select[data-value]').each(function(index, el){
	const $el = $(el);
	
	const defaultValue = $el.attr('data-value').trim();
	
	if(defaultValue.length > 0){
		$el.val(defaultValue);		
	}
});

$('.Popup').click(function(){
	//	$('.layer').show();
	$('.layer-bg').show();
	$('.layer').css('display', 'block');
});

$('.close-btn').click(function(){
	//	$('.layer').hide();
	$('.layer-bg').hide();
	$('.layer').css('display', 'none');
});

$(".menu-btn").click(function(){
	if($("header").hasClass("active")){
		$("header").css({
			right: "-100%",
		});
		$("header").removeClass("active");
		return;	
	}
	$("header").css({
		right: 0,
	});
	$(".back-board").addClass("active");
	$("header").addClass("active");
});

$(".close-menu").click(function(){
	$("header").css({
			right: "-100%",
	});
	$("header").removeClass("active");
	$(".back-board").removeClass("active");
});

$(".back-board").click(function(){
	$("header").css({
			right: "-100%",
	});
	$(this).removeClass("active");
	$("header").removeClass("active");
});

// 메뉴 액티브
let link = document.location.href.split("/");

if(link[4] === "article" && link[5].startsWith("list")){
	link[5] = link[5].split("?")[1].split("=")[1];
	if(link[5] === "2"){
		link[5] = "QA";
	}else if(link[5] === "1"){
		link[5] = "notice";
	}
}else if(link[5].startsWith("login")){
	link[5] = "login";
}else if(link[5].startsWith("join")){
	link[5] = "join";
}else if(link[4] === "rank"){
	link[5] = "rank";
}else if(link[5].startsWith("detail")){
	link[5] = link[5].split("%3F")[1].split("%3D")[1];
	if(link[5] === "2"){
		link[5] = "QA";
	}else if(link[5] === "1"){
		link[5] = "notice";
	}
}

$("header ul li").each(function(index, item){
	if($(item).attr("tag") === link[5]){
		$(item).addClass("active");
	}
});
// 메뉴 액티브

	
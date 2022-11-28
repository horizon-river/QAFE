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
});

$(".back-board").click(function(){
	$("header").css({
			right: "-100%",
	});
	$(this).removeClass("active");
	$("header").removeClass("active");
});
// Prototype version
function make_sliders() {
  $$(".te_slide_left").each(function(item){
  	$(item).observe('click', function(){
  		return slide_left($(item).readAttribute("linkto"));
  	});
  });
  $$(".te_slide_right").each(function(item){
  	$(item).observe('click', function(){
  		return slide_right($(item).readAttribute("linkto"));
  	});
  });	
}

// Prototype version
function cleanup_slide_left() {
  	$$(".viewport_offstage_right > .viewport_body").each(function(item){
  		$(item).removeClassName("viewport_body");
  	}); 
	$$(".viewport_body").each(function(item){
		$(item).addClassName("viewport_offstage_left");
	});
	$$(".viewport_offstage_right").each(function(item){
		$(item).addClassName("on_stage");
	});
	$$(".viewport_offstage_left").each(function(item){
		$(item).remove();
	});
	$$(".on_stage").each(function(item){
		$(item).removeClassName("viewport_offstage_right");
		$(item).addClassName("viewport_body");
	});
	$$(".viewport_body").each(function(item){
		$(item).removeClassName("on_stage");
	});	
	make_sliders();
}

// Prototype version
function cleanup_slide_right() {
	$$(".viewport_offstage_left > .viewport_body").each(function(item){
		$(item).removeClassName("viewport_body");
	}); 
	$$(".viewport_body").each(function(item){
		$(item).addClassName("viewport_offstage_right");
	});
	$$(".viewport_offstage_left").each(function(item){
		$(item).addClassName("on_stage");
	});
	$$(".viewport_offstage_right").each(function(item){
		$(item).remove();
	});
	$$(".on_stage").each(function(item){
		$(item).removeClassName("viewport_offstage_left");
		$(item).addClassName("viewport_body");
	});
	$$(".viewport_body").each(function(item){
		$(item).removeClassName("on_stage");
	}); 
	make_sliders();
}

// Prototype version
function append_offstage_div(side) {
	var HTML = "<div class='viewport_offstage_" + side + "'></div>";
		$("iphone-container").insert(HTML);
}

// Prototype version
function slide_left(href) {
	append_offstage_div("right");
	var left_div = $("iphone-container").down("div.viewport_body");
	var right_div = $("iphone-container").down("div.viewport_offstage_right");
	new Ajax.Updater(right_div, href, {
		method:'get',
		onComplete:function(){
			var height = $(right_div).getHeight();
			$("iphone-container").style.height = height + "px";		
			new Effect.Move(left_div, {
					x: -320, y: 0, mode: 'relative',
					transition: Effect.Transitions.linear
			});
			new Effect.Move(right_div, {
					x: -320, y: 0, mode: 'relative',
					transition: Effect.Transitions.linear,
					afterFinish: function(effect){
						cleanup_slide_left();
					}
			});
		}
	});
	return false;
}

// Prototype version
function slide_right(href) {
	append_offstage_div("left");
	var left_div = $("iphone-container").down("div.viewport_offstage_left");
	var right_div = $("iphone-container").down("div.viewport_body");
	new Ajax.Updater(left_div, href, {
		method:'get',
		onComplete:function(){
			var height = $(left_div).getHeight();
			$("iphone-container").style.height = height + "px";		
			
			new Effect.Move(right_div, {
					x: 320, y: 0, mode: 'relative',
					transition: Effect.Transitions.linear
			});
			new Effect.Move(left_div, {
					x: 320, y: 0, mode: 'relative',
					transition: Effect.Transitions.linear,
					afterFinish: function(effect){
						cleanup_slide_right();
					}
			});
		}
	});
	return false;
}

// a goofy workaround because the toggle object seems to get two click events
// per actual click

// JQuery version
//function make_toggles() {
//	$('.toggle').toggle(
//		function() {
//			$(this).attr("value", ($(this).attr("value") == 'OFF' ? 'ON' : 'OFF'));
//			$(this).attr("toggled", $(this).attr("value") == 'ON');
//			var hidden_selector = "#" + $(this).attr("id").replace("_toggle", "");
//			$(hidden_selector).attr("value", $(this).attr("value"));
//			return false;
//	 }, 
//		function() {});
//}

// Prototype version
function make_toggles() {
	$(this).readAttribute("value", ($(this).readAttribute("value") == 'OFF' ? 'ON' : 'OFF'));
	$(this).readAttribute("toggled", $(this).readAttribute("value") == 'ON');
	var hidden_selector = $(this).readAttribute("id").replace("_toggle", "");
	$(hidden_selector).readAttribute("value", $(this).readAttribute("value"));
	return false;
}


function init() {
	make_sliders();
	//make_toggles();
}

document.observe("dom:loaded", function() {
	init();
});
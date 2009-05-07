/*
	Videojuicer Management Panel Core JS
	This file contains the standard presentational and interactive JS for the Management Panel.
	
	Dependencies: jQuery 1.3, jQuery Easing
*/

// Document Boot
// ==============================================================================

$(document).ready(function() {

	// Cosmetic - Add .has-js to the <body> so that Markup can be styled for when the user has or doesnt have JS
		$("body").addClass("has-js");
	
	// Cosmetic - Add the correct wrapper to links that require it.
		$(".btn, nav > a").wrapInner("<span></span>").append("<i></i>");
		
	// Cosmetic - Add wrapping elements to box structures
		$(".box").each(function() { $box = $(this);
			// TOP wrapping
			$("h1:first", $box).before('<span class="outer-top"><span class="right"></span></span>');
			$("h1:first", $box).after('<span class="inner-top"><span class="right"></span></span>');
			// Conditionally insert footer
			footer = $(".footer", $box);
			if(footer.length < 1) footer = $(".footer", $box.append('<section class="footer"></section>'));
			// BOTTOM wrapping
			footer.before('<span class="inner-bottom"><span class="right"></span></span>')
			footer.after('<div class="clear"></div><span class="outer-bottom"><span class="right"></span></span>');
		});
		
		
	// Interactivity - Make active all nav-tab arrays.
		$("ul.nav-tabbed a").make_nav_tab();
		$("ul.nav-tabbed a:first").activate_nav_tab();
		
	
	// Interactivity - Hide All Tooltips whenever an input, textarea or select focuses
		$('textarea, input, select').focus(function() {
			remove_all_tooltips();
		});
	
	// Make necessary corrections for IE
	// Buttons are converted to anchors	
		if($.browser.msie) {
			// Change any <button class="btn" to an anchor
			convert_btns_to_anchors();
			
			// Make forms submit when enter is pressed
			$('input').keydown(function(e){
				if (e.keyCode == 13) {
					$(this).parents('form').submit();
					return false;
				}
			});
		}
});

// Tiny Extensions to jQuery (major extensions should get their own files)
// ==============================================================================

// Used on a link within a nav-tab controller bar to give it all the right interactivity.
$.fn.make_nav_tab = function(options) {
	return this.each(function() { $link = $(this);
		$link.click(function() {
			$(this).activate_nav_tab();
			return false;
		})
	});
}
// Used on a tab bar nav-tab to activate it and display the content it relates to.
$.fn.activate_nav_tab = function(options) {
	return this.each(function() { $link = $(this); $ul = $link.closest("ul"); $li = $link.closest("li");
		// Mark all containing LIs in the controller as inactive
		$("li", $ul).removeClass("active");
		// Mark this link's containing LI as active
		$li.addClass("active");
		// Hide all content blocks owned by this controller block
		$(".tabbed-content[data-group="+$ul.attr("data-controls")+"]").collapse();
		// Show the specific content block we're activating
		$($link.attr("href")).expand();
	});
}

// Animate the closing of all matched elements. 
// Used to keep animation settings consistent.
$.fn.collapse = function(options) {
	this.slideUp(250, 'easeOutQuad');
}
// Animate the opening of all matched elements. 
// Used to keep animation settings consistent.
$.fn.expand = function(options) {
	this.slideDown(250, 'easeOutQuad');
}


//	Tabbed Navigation
//	FOR: Switching between different tabs on the page
// ==============================================================================

function TabbedNavigation(num_tabs, tab_handle, content_handle, classname, default_tab) {

	this.num_tabs = num_tabs;				// -> number of tabs on page
	this.tab_handle = tab_handle;			// -> name of tab IDs minus number (e.g. "tab1" would be "tab")
	this.content_handle = content_handle;	// -> name of content box IDs minus number (e.g. "content1" would be "content")
	this.classname = classname;				// -> css class to be applied to open tab
	this.default_tab = default_tab;			// -> which tab is open by default

	TabbedNavigation.prototype.hide_all_content_boxes_except = function(num, fade) {
		var css = { display:'none'}
		for(i = 1; i <= this.num_tabs; i++) {
			$(this.content_handle + i).css(css);
		}	
		if(!fade) {	
			var css = { display:'block'}
			$(this.content_handle + num).css(css);
		} else {
			$(this.content_handle + num).fadeIn(750);
		}
	}

	TabbedNavigation.prototype.set_current_tab_to = function(num) {
		for(i = 1; i <= this.num_tabs; i++) {
			$(this.tab_handle + i).removeClass(this.classname);
		}
		$(this.tab_handle + num).addClass(this.classname);
	}

	TabbedNavigation.prototype.set_tab_to = function(num) {
		this.set_current_tab_to(num);
		this.hide_all_content_boxes_except(num);
	}

	this.set_tab_to(this.default_tab);
}

// Tooltips
// FOR: Showing & Hiding the relevant tooltips when the user clicks tooltip icon

function remove_all_tooltips() {
	$('.tool-tip-msg').fadeOut('fast');
	$('.tool-tip-icon').removeClass('active');
};

function trigger_tooltip(id)	{
	if(id) {
		if	($(id).hasClass('active'))	{
			$(id + '-msg').fadeOut('fast');
			$(id).removeClass('active');
		} else {	
			remove_all_tooltips();			
			$(id).addClass('active');
			$(id + '-msg').fadeIn('fast');
		};
	}
};

// Expandable Fieldset
// FOR: Allowing the user to expand or contract a fieldset
function close_expandable_fieldsets()	{
	$('fieldset.expandable').addClass('closed');
};

function trigger_fieldset(id)	{
	if(id)	{
		var fieldset = id + '-parent'
		if ($(fieldset).hasClass('closed'))	{	
			close_expandable_fieldsets();
			$(fieldset).removeClass('closed').addClass('open');
		} else	{
			close_expandable_fieldsets();
		};
	};
};

// Submit forms
// FOR: Fake Submitting forms 

function submit_form(id, submitted_by) {
	var frm = document.forms[id];
	
	// If we passed a submitted_by array then add the elements to the form
	if (submitted_by !== undefined) {

		for(var key in submitted_by){
			ff = document.createElement("INPUT");
			ff.type = "hidden";
			ff.name = key;
			ff.value = submitted_by[key];
			frm.appendChild(ff);
		} 

		// Make the form revalidate so that the new values are passed
		if (frm.normalize) {frm.normalize();}
	}
	
	frm.submit();
}

function reset_form(id) {
	document.forms[id].reset();
}

// Convert Buttons
// FOR: Convert button.btn to a.btn in ie6

function convert_btns_to_anchors() {

	$('button.btn').each(function() {

		var id 			= $(this).attr('id');		
		var form_id 	= id.replace(/-submit(.)*/, '');
		var classes 	= $(this).attr('class');
		var type 		= $(this).attr('type');
		var name		= $(this).attr('name');
		var value		= $(this).attr('value');
		var content 	= $(this).html();

		
		var str = "<a href=\"#\" ";			// <-- remove green border
		if(type =='submit') {
			str += "onclick=\"submit_form('" + form_id + "', {'" + name + "' : '" + value + "'}); return false;\" ";
		} else if(type =='reset') {
			str += "onclick=\"reset_form('" + form_id + "'); return false;\" ";
		}
		if(classes) str += "class=\"" + classes + "\" ";
		if(id) str += "id=\"" + id + "\" ";
		str += ">" + content + "</a>";
		

		$(this).replaceWith(str);
	});

}





// Tzzatziki default template JS

$(document).ready(function() {

	// Boot the tzatziki doc (default layout)
	
	// Columnar view. These are nested lists which are going to be recursed.
	$(".view-columnar").columnify();

});

// Columnify plugin for jQuery. 
// Takes a nested set of list elements (OL/UL) as seen
// in the default Tzatziki template, and turns it into a
// progressively-switchable set of lists that can be
// styled to resemble OSX's columnar view.
// Was authored as a part of the initial Tzatziki release.
$.fn.columnify = function(options) {
	var $this = $(this);
	// Default options
	var defaults = {
		id: "column_browser"
	};
  	var opts = $.extend(defaults, options);

	var links = $.fn.columnify.extract($this);
	var wrapper = $("<div id=\""+opts.id+"\" class=\"view-columnar\"></div>").insertAfter($this);
	$.fn.columnify.render(wrapper, links);
	$this.remove();	
};
	
	// Renders a tier of the list into a wrapper, and recurses to child lists
	// to place them in further wrappers.
	$.fn.columnify.render = function(target, links, _tier) {
		var tier = _tier || 0;
		var target = $(target);
		// Create a wrapper for this tier if none exists
		var tier_wrapper_id = target.attr("id")+"_tier"+tier;
		if($("#"+tier_wrapper_id).length > 0) {
			var tier_wrapper = $("#"+tier_wrapper_id);
		} else {
			var tier_wrapper = $("<div id=\""+tier_wrapper_id+"\"></div>").appendTo(target);
		}
		// Create a this list if none exists
		
		// Render the links into the list
		
			// Attach events
		// Render the child lists
	}

	// Goes over nested links in an LI and extracts to an object like:
	/*
		[
			{
				label: "a category",
				href: "/foo.html",
				children: [
					another array like the root...
				]
			},
			{
				label: "another category"
				href: .......
			}
		]
			*/
	// Run this function against an OL or UL element.
	$.fn.columnify.extract = function(on, _tier) {
		var tier = _tier || 0;
	   	var r_arr = [];
		// Create a virtual "all" object for this tier
		var r_all = {label: "All", href: "#", children: []};
		
	   	$("li", on).each(function(i) {
			// Looping over the direct child LIs on this list only
			if($(this).parent().html() == on.html()) {
				var this_obj = {children: []};
				// We're in a select list of the LI's directly inside our 'on' element.
				var this_child_list = $("ol, ul", this);
		       		this_obj.children = $.fn.columnify.extract(this_child_list, tier+1);
		       		this_child_list.remove();
				this_obj.label = $("a", this).html();
				this_obj.href = $("a", this).attr("href");
				r_arr.push(this_obj);
			} // if parent
			return true; // don't stop the rock
		}); // each loop
		return r_arr;	
	};
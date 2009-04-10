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
	$.fn.columnify.list_counter = 0;
	
	// Renders a tier of the list into a wrapper, and recurses to child lists
	// to place them in further wrappers.
	$.fn.columnify.render = function(target, links, _tier) {
		var tier = _tier || 0;
		var target = $(target);

		console.log("Rendering at tier "+tier);
		console.log(links)
		
		// Create a wrapper for this tier if none exists
		var tier_wrapper_id = target.attr("id")+"_tier"+tier;
		if($("#"+tier_wrapper_id).length > 0) {
			var tier_wrapper = $("#"+tier_wrapper_id);
		} else {
			var tier_wrapper = $("<div id=\""+tier_wrapper_id+"\" class=\"tier_wrapper\"></div>").appendTo(target);
		}
		
		// Start processing the child links into the lists below this one
		// Determine list ID and create or get reference
		var list_id = target.attr("id")+"_tier"+tier+"_list"+$.fn.columnify.list_counter;
		$.fn.columnify.list_counter++;
		if($("#"+list_id).length > 0) {
			var tier_list = $("#"+list_id);
		} else {
			var tier_list = $("<ol id=\""+list_id+"\"></ol>").appendTo(tier_wrapper);
		}
		
		// Loopit
		$(links).each(function() { var $link = this;
			// Render the link into the list
			console.log("rendering tier link...");
			$("<li><a href=\""+$link.href+"\">"+$link.label+"</a></li>").appendTo(tier_list);
				// Attach events
			// Render the child lists
			if($link.children.length > 0) {
				$.fn.columnify.render(target, $link.children, tier+1);
			}
		});
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
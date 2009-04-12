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
	var wrapper = $("<nav id=\""+opts.id+"\" class=\"view-columnar\"></nav>").insertAfter($this);
	$.fn.columnify.render(wrapper, links);	

	$this.remove();
};
	$.fn.columnify.list_counter = 0;
	$.fn.columnify.getListRef = function() {
		var r = $.fn.columnify.list_counter;
		$.fn.columnify.list_counter++;
		return r;
	}
	
	// Selects a list item given the <a /> node of the link. The parent list will be inferred from the
	// HTML5 data attributes on the parent list, and any child lists will be searched for.
	// When selecting an item, the parent list is not affected but the child lists will be reset.
	$.fn.columnify.select = function(link) {
		var link = $(link);
		var child_tier = $("#"+link.attr("data-owned-list-tier-id"));
		var show_list = $("#"+link.attr("data-owns-list"));
		
	
		// Work on all tiers beyond this one
		var this_tier = link.closest("section");
			$("a", this_tier).attr("class", "");
		var next_tier = this_tier.next();
		while(next_tier.length > 0) {
			// Mark links in the onward tiers as not current
			$("a", next_tier).attr("class", "");
			// Hide lists in the onward tiers
			$("ol, ul", next_tier).hide();
			next_tier = next_tier.next();
		}
		
		// Show the list we want to control
		show_list.show();
		
		// Add class to this link
		link.attr("class", "current");
	}
	
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
			var tier_wrapper = $("<section id=\""+tier_wrapper_id+"\" class=\"tier_wrapper wraps_tier_"+tier+"\" data-tier=\""+tier+"\"></section>").appendTo(target);
		}
		
		// Start processing the child links into the lists below this one
		// Determine list ID and create or get reference
		var list_ref = $.fn.columnify.getListRef();
		var list_id = target.attr("id")+"_tier"+tier+"_list"+list_ref;
		if($("#"+list_id).length > 0) {
			var tier_list = $("#"+list_id);
		} else {
			var tier_list = $("<ol id=\""+list_id+"\"></ol>").appendTo(tier_wrapper);
		}
		
		// Loopit
		$(links).each(function() { var $link = this;
			// Render the child lists
			var child_props = $.fn.columnify.render(target, $link.children, tier+1);
			// Render the parent link into the list
			li = $("<li></li>").appendTo(tier_list);
			link = $("<a href=\""+$link.href+"\" data-owns-list=\""+child_props.list_id+"\" data-owns-list-in-tier=\""+tier+1+"\" data-owned-list-tier-id=\""+child_props.tier_wrapper_id+"\">"+$link.label+"</a>").appendTo(li);
				// Attach events
				link.mouseover(function() {
					$.fn.columnify.select(this);
				});
		});
		return {"list_id": list_id, "tier_wrapper_id": tier_wrapper_id};
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
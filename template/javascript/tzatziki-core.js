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
	// Default options
	var defaults = {
    	recursive: true
	};
  	var opts = $.extend(defaults, options);

	var links = $(this).columnify.extract(opts.recursive);
		
};
	// Goes over nested links in an LI and extracts to an object like:
	/*
		{
			links: jQuery array of references to the <a /> tags at the this-list > li > a level
			children: [
				// array of list objects like this one				
			]
		}
			*/
	// Run this function against an OL or UL element.
	$.fn.columnify.extract = function(recurse) {
	   var r_obj = {
	   	links: [],
	   	children: []
	   };		
	   // Find the child lists if present and intern them before removing them from the DOM
	   //var this_child_lists = $("ol, ul", $(this));
	   //if(recurse) {
	   //	this_child_lists.each(function() {
	   //		r_obj.children.push(this.columnify.extract());
	   //	});
	   //	this_child_lists.remove();		
	   //}
	   // Remaining links are direct descendants
	   //obj.links = $("li > a", $(this));		
	   return r_obj;		
	};
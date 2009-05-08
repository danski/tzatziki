Tzatziki
========

**This README is work in progress because there's a lot to cover**

Document and test your app's developer API in one go.
-----------------------------------------------------

So I was working on the Videojuicer API and figuring out a strategy for testing and documentation, and I realised that if we did things the usual way, we'd have redundancy:

1. Unit specs for the app
2. Integration specs for the app
3. Public API specs that simulate inbound calls over HTTP to check adherence to the documentation
4. The documentation itself.

So every time we create a new app revision, we have to update the public API specs, and the documentation, and somehow enforce parity between the two. There's too much room for human error in that process, and consistency is really business critical when it comes to publishing APIs. What if we miss something? Why do I have to document my public API once so that a computer can test it and once again so that a human can understand it? Can't I automated this problem away? As it turns out, we can.

WTF is Tzatziki?
----------------
It's a dip containing cucumber and yoghurt. It's also a tool that lets you write API documentation for your application that not only gets converted into an attractive ready-to-upload developer site, but is also tested and enforced prior to being published. Where existing testing tools are *tests that can be used as documentation*, Tzatziki docs are *documents that can be tested and verified*.

Tzatziki tests are of the "black box" variety. While your ruby/python/whatever tests run within your application and can peek/poke at internal information, Tzatziki tests as if it itself were a client for your API. Tzatziki treats everything you tell it about the request as a means of generating *request fixtures*, and everything you tell it about the response as *assertions* about the data expected to be returned by your API. The advantages of black box testing are manyfold:

* You can use Tzatziki with any application that serves over HTTP, regardless of the language or framework used to build that app.
* You can make your Tzatziki tests available to developers, and developers can run Tzatziki tests against their own accounts if they so choose.
* You can use Tzatziki to document APIs on *other services that you don't own*.

Tzatziki's documentation format is heavily based on patterns seen in [Jekyll](http://github.com/mojombo/jekyll) and uses the [Liquid](http://github.com/tobi/liquid) templating system. Templates are completely user-serviceable and can be altered to match your product's existing site.

Getting to Hello World
----------------------

Start out by install the gem and making a couple of folders. One will be the source, and one will be the destination where your docs are saved.

	sudo gem install danski-tzatziki -s http://gems.github.com
	mkdir myapi
	mkdir myapi_out

Now just for fun, let's make something that tests the new [Github API](http://develop.github.com). Create a file in the **myapi** folder called **show_repo.markdown**. Textile and HTML extensions are also permitted and will be processed accordingly. Write into the file:

	---
	title: Getting Repo information
	===
	
	To retrieve the Information for a repo, you can make an unsigned request to a path like:
	
		/api/v2/:type/repos/show/:user/:repo
		
	Here is an example request:
	
	---
	request:
	  host: github.com
	  uri: /api/v2/xml/repos/show/danski/tzatziki
	===
	
	The response that comes back should be something like:
	
	---
	response:
	  status: ok
	  kind: json
	  headers:
	    arbitrary: lol
	===

As you can see, your Tzatziki docs can contain YAML blocks in a similar way to Jekyll, but we do things slightly differently to allow the inclusion of multiple YAML blocks within the document body. Each YAML block should begin with three dashes (---) and end with three equal signs (===) with each being on their own line. When the document is processed, the YAML declare at the top of the document will be removed and processed, and each subsequent declare will be deep-merged into the first and replaced with a data table containing the data for that YAML block.

Let's run this document through Tzatziki and see what comes back:

	Jet-Jaguar:tmp danski$ taz myapi myapi_out
	Tzatziki is reading the specifications from myapi...
	=> Done.
	Tzatziki is testing against the specifications...
	-- Document bundle located in myapi
	---- Getting Repo information
	------ [1] Header 'arbitrary' was expected to be 'lol' but was ''
	------ [2] Expected kind to be "json" but was "xml"
	       Request data          
	       {:host=>"github.com", :uri=>"/api/v2/xml/repos/show/danski/tzatziki"}
	       Response assertions   
	       {:headers=>{:arbitrary=>"lol"}, :status=>"ok", :kind=>"json"}

Ooh! Errors! What just happened? Tzatziki made a request to http://github.com/api/v2/xml/repos/show/danski/tzatziki and checked to see that the response was OK and had a content-type of application/xml. And it failed, because we told Tzatziki to expect something different. Let's fix up the document by replacing the response block with:

	---
	response:
	  status: ok
	  kind: xml
	===

And running it again:

	Jet-Jaguar:tmp danski$ taz myapi myapi_out
	Tzatziki is reading the specifications from myapi...
	=> Done.
	Tzatziki is testing against the specifications...
	-- Document bundle located in myapi
	---- Getting Repo information
	Tzatziki is writing the documentation to myapi_out 
	Done. Enjoy your Tzatziki. 

See? All passed. We could just as easily change the status to 'redirect' or '201' or '30X' and see another failed case. We'll go into all the options Tzatziki supports for requests and responses shortly.

Try opening the resulting HTML file in the myapi_out folder. Ugh. Ugly. This brings us neatly onto:

Making the output pretty
------------------------


Refactoring your docs with Specifications and Types
---------------------------------------------------

* What are specifications?
	* Examples of specifications
	* Signing specifications
	* Included specifications
* What are data types?
	* Examples of data types
	* Included data types

Adding examples to your API methods
-----------------------------------
* What are examples?
	* Examples of examples (very meta)

Sub-Apis and inheritance
------------------------

* User-configurable config file
* Folder structure

Reference
=========

Customising the HTML
--------------------
	* Liquid reference


Supported request variables
---------------------------
method
protocol
host
uri
query_string
form_data
headers
multipart_form
basic_auth

Supported type variables
------------------------
description
pattern
values
default
required
example


Supported response variables
---------------------------
status
	- by number
	- by mask (20X)
	- by name (ok/success/redirect/servererror etc.)
headers
body
	- xpath
	- css
	- matches
	- values
	- kind

Other stuff
===========

Design principles checklist
---------------------------

* Documentation-led testing, rather than testing-led documentation
* Scalable logic. Same classes and patterns apply to one-file Tzatziki sites as to 50-level/500-file sites.
* Nesting and inheritance
* Out of the box experience:
	* Must be easy to start a new site
	* Portable directory structure should allow sites to migrate seamlessly to new versions of this gem
	* Must provide a great cross-browser default template set, and...
	* ...must allow users to replace it completely or partially as they choose.
* Interactivity through rake and the `taz` terminal command
* It should be safe to make an uncompiled Tzatziki site available for public download
* Users should be able to run Tzatziki tests against their own accounts (depending on your APIs ability to sandbox API calls or to provide a test environment)

COPYRIGHT
=========

Copyright (c) 2008 Dan Glegg. See LICENSE for details.
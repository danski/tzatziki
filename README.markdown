Tzatziki
========
**Work in progress not ready for installation**

This README is actually a TODO of things I need to write in the README so that people understand WTF this gem is for.

* Description of gem purpose
** Documentation system based on [Jekyll](http://github.com/mojombo/jekyll)
** Tests your API as you document
* Examples of use
** Documenting existing APIs
** Documenting new APIs
** BDD for APIs

* Hello world with a single text file

* User-configurable config file
* Folder structure

* Why test over HTTP?
** Verify API documentation integrity
** Abstract public API docs from private functional docs
** Allow the public to run the test suites
** Your API docs use your API!

* What are api calls?
* What are specifications?
** Examples of specifications
** Signing specifications
** Included specifications
* What are data types?
** Examples of data types
* What are examples?
** Examples of examples (very meta)
** Included data types
* Customising the HTML
** Liquid reference

Supported request variables
---------------------------
method
protocol
domain
uri
query string
form body
headers
multipart form
basic auth


Supported response variables
---------------------------

Design principles checklist
---------------------------

* Documentation-led testing, rather than testing-led documentation
* Scalable logic. Same classes and patterns apply to one-file Tzatziki sites as to 50-level/500-file sites.
* Nesting and inheritance
* Out of the box experience:
** Must be easy to start a new site
** Portable directory structure should allow sites to migrate seamlessly to new versions of this gem
** Must provide a great cross-browser default template set, and...
** ...must allow users to replace it completely or partially as they choose.
* Interactivity primarily through rake and the `taz` terminal command
* It should be safe to make an uncompiled Tzatziki site available for public download
* Users should be able to run Tzatziki tests against their own accounts (depending on your APIs ability to sandbox API calls or to provide a test environment)

COPYRIGHT
=========

Copyright (c) 2008 Dan Glegg. See LICENSE for details.
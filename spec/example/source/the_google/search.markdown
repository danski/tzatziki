---
title: Requesting the search results from The Google
request:
  protocol: http
  domain: www.google.com
  uri: /search
	method: get
  query_string:
    q:
      description: An entity-escaped string that you wish to search for on The Google.
      example: google (now you're thinking with portals)
			format: /.*/
specifications:
	successful: true
---

This is an example API document designed to document and test parts of the The Google Search API.
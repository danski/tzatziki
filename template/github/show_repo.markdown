---
title: Getting Repo information
request:
  host: github.com
  uri: /api/v2/xml/repos/show/{{config.github.user}}/{{config.github.repo}}
  query_string:
    q:
      type: string
specifications:
  oauth: true
===

To retrieve the Information for a repo, you can make an unsigned request to a path like:

	/api/v2/:type/repos/show/:user/:repo

Because the request is defined in the opening YAML block, no request table will be inserted inline in my content. The layout will instead automatically add the request table at the end of the document.

The response that comes back looks like this (defining a response YAML block inline to force Tzatziki to render the response table within my content):

---
response:
  status: ok
  kind: xml
===

This content comes after the response block but before any content automatically inserted by Tzatziki.
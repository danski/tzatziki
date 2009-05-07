---
title: JSON
request:
  uri: /api/v2/json/repos/show/{{config.github.user}}/{{config.github.repo}}
response:
  kind: json
===

To retrieve the Information for a repo, you can make a request like this:

Request
=======

<dl>
	<dt>Host</dt>
	<dd>{{ document.request.host }}</dd>
	
	<dt>URI</dt>
	<dd>{{ document.request.uri }}</dd>
</dl>

Response
========

The response that comes back, in the appropriate format, looks like so:

{% highlight xml %}
	{{document.response.body}}
{% endhighlight %}

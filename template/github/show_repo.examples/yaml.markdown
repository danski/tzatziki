---
title: YAML
request:
  uri: /api/v2/yaml/repos/show/{{config.github.user}}/{{config.github.repo}}
response:
  kind: yaml
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

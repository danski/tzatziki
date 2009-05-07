---
title: Getting Repo information
request:
  host: github.com
  uri: /api/v2/yaml/repos/show/{{config.github.user}}/{{config.github.repo}}
response:
  status: ok
  kind: yaml
===

I am the content
----------------

**Paragraph**

{% highlight 'yaml' %}
	{{document.response.body}}
{% endhighlight %}

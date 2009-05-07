---
title: Getting Repo information
request:
  host: github.com
  uri: /api/v2/yaml/repos/show/{{config.github.user}}/{{config.github.repo}}
response:
  status: ok
  kind: yaml
===
---
title: Times & Dates in web browser timezone with Rails 6
date: 2020-12-06
tags: time, date, timezone, rails
---

Times & Dates in web browser timezone with Ruby&nbsp;on&nbsp;Rails&nbsp;6
===

I like to have times and dates presented in the user's timezone.

Basecamp's `local_time`
---

Tried ruby gem `local_time` ([github.com/basecamp/local_time](https://github.com/basecamp/local_time/))
and I liked it. But I am missing the knowledge to apply I18n to it.

Custom with JavaScript, Cookies and ApplicationController
---

I droped `local_time` und did something custom with JavaScript, cookies and
ApplicationController `around_action`.

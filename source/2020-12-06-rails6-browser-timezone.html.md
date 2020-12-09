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

```ruby
# app/controlers/application_controller.rb
class ApplicationController < ActionController::Base
  around_action :switch_timezone

  private

  def switch_timezone(&action)
    Time.use_zone(timezone_from_cookies, &action)
  end

  def timezone_from_cookies
    cookies.fetch(:timezone, nil)
  end
end
```


```js
/* app/javascript/user_agent_timezone/index.js */
function setTimezoneCookie() {
    var timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    var expires  = new Date();

    expires.setTime(expires.getTime() + 60*60*24);
    expires = expires.toGMTString();

    document.cookie = "timezone=" + timezone + "; Path=/";
}

export default setTimezoneCookie()
```

```js
/* app/javascript/packs/application.js */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("user-agent-timezone")
```

---
title: Times & Dates in web browser timezone with Ruby on Rails 6.0
date: 2020-12-06
tags: time, date, timezone, rails
---

Times & Dates in web browser timezone with Ruby&nbsp;on&nbsp;Rails&nbsp;6.0
===

With Ruby on Rails 6, I like to have times and dates presented in the user's timezonea.

Basecamp's `local_time`
---

My first search results lead me to Basecamp's [`local_time`](https: //github.com/basecamp/local_time/) ruby gem for Ruby on Rails. It makes it easy to diesplay times and dates in the local timezon of the user. Times and dates are rendered to `<time`> elements in UTC, and user agent JavaScript converts those to the local timezone.

Pretty nice and very cache friendly, as all pages/partials with times and dates contain the same HTML with UTC times and dates.

Unfortunately, I was not skilled enought to add internationalization or localization of the time and date formates to ` local_time`. Whatever I tried, I ended up with a weird mix of localized and not-localized time/date formats and translations for weekdays and month.

`local_time` includes US English internationalization/localization of the JavaScript part in [`i18n.coffee`](https://github.com/quatauta/local_time/blob/master/lib/assets/javascripts/src/local-time/config/i18n.coffee) . The [ruby gem](https://rubygems.org/gems/local_time) delivers a [minimized JavaScript asset](https://github.com/quatauta/local_time/blob/master/app/assets/javascripts/local-time.js) which I was not able to enrich with time/date formats and translations in other languages. Most likely because of all the advancements in the JavaScript ecosystem. And those are not covered by the [internationalization section](https://github.com/basecamp/local_timeconfiguration) of `local_time`'s documentation.


Custom with JavaScript, Cookies and ApplicationController
---

Due to my inability to add translations to `local_time`'s JavaScript, I droped `local_time` (until I advance to the required level) und did something custom with JavaScript, cookies and ApplicationController `around_action`.

1. Page contains JavaScript to get the local timezone with [`Intl.DateTimeFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions). The timezone is added to cookie `timezone`.
1. On the next request, the browser sends cookie `timezone` to Rails
1. Rails `ApplicationController` takes the timezone from cookie `timezone` and uses [`Times#use_zone`](https://api.rubyonrails.org/classes/Time.HTMLmethodmethod-c-use_zone) in [`around_action`](https://api.rubyonrails.org/classes/AbstractController/Callbacks/ClassMethods.HTMLmethod-i-around_action) to change the timezone for this request
1. The view renders times and dates in the current timezone

`app/javascript/user_agent_timezone/index.js`:
```js
function setTimezoneCookie() {
    var timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    var expires  = new Date();

    expires.setTime(expires.getTime() + 60*60*24);
    expires = expires.toGMTString();

    document.cookie = "timezone=" + timezone + "; Path=/";
}

export default setTimezoneCookie()
```

`app/javascript/packs/application.js`:
```js
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("user-agent-timezone")
```

`app/controlers/application_controller.rb`:
```ruby
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

`app/views/articles/show.html.erb`:
```erb
<p><strong>Title:</strong> <%= article.title %></p>
<p><strong>Text:</strong> <%= article.text %></p>
<p>Created <%= I18n.l(article.created_at, format: :short) %>,
   updated <%= I18n.l(article.updated_at, format: :short) %></p>
```

Next time, I will explain to you what is provided by `I18n.l`. Stay tuned, but patient ...

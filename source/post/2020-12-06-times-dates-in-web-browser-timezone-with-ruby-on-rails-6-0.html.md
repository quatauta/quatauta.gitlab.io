---
title: Times & Dates in web browser timezone with Ruby on Rails 6.0
date: 2020-12-06
tags: ["time", "date", "timezone", "rails"]
---

With Ruby on Rails 6, I like to have times and dates presented in the user's timezone.

## Basecamp's `local_time`

My first search results lead me to Basecamp's [`local_time`](https://github.com/basecamp/local_time/) ruby gem for Ruby on Rails. It makes it easy to display times and dates in the local timezone of the user. Ruby on Rails renders times and dates to `<time`> elements in UTC timezone. User-agent JavaScript converts those to the local timezone of the user's web browser.

`local_time` is very cache-friendly, as all pages/partials with times and dates contain the same HTML with UTC times and dates.

Unfortunately, I was not skilled enough to add internationalization or localization of the time and date formats to `local_time`. Whatever I tried, I ended up with a weird mix of localized and not-localized time/date formats and translations for weekdays and months.

`local_time` includes US English internationalization/localization of the JavaScript part in [`i18n.coffee`](https://github.com/quatauta/local_time/blob/master/lib/assets/javascripts/src/local-time/config/i18n.coffee) . The [ruby gem](https://rubygems.org/gems/local_time) delivers a [minimized JavaScript asset](https://github.com/quatauta/local_time/blob/master/app/assets/javascripts/local-time.js) for localization. I was not able to enrich it with time/date formats and translations in other languages. Maybe because of all the advancements in the JavaScript ecosystem. I was not able to interpret the [internationalization section](https://github.com/basecamp/local_timeconfiguration) of `local_time`'s documentation :frowning_face:

## Custom with JavaScript, Cookies, and `ApplicationController`

Due to my inability to add translations to `local_time`'s JavaScript, I dropped `local_time` (until I advance to the required level) and did something custom with JavaScript, cookies, and ApplicationController `around_action`.

1. The web page contains JavaScript to get the local timezone with [`Intl.DateTimeFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions). The JavaScript code adds the web browser's timezone to the `timezone` cookie.
1. On the next request, the browser sends cookie `timezone` to Rails
1. Rails `ApplicationController` takes the timezone from cookie `timezone` and uses [`Times#use_zone`](https://api.rubyonrails.org/classes/Time.HTMLmethodmethod-c-use_zone) in [`around_action`](https://api.rubyonrails.org/classes/AbstractController/Callbacks/ClassMethods.HTMLmethod-i-around_action) to change the timezone for this request
1. The view renders times and dates in the current timezone

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
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("user-agent-timezone")
```

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

```plaintext
# app/views/articles/show.html.erb
<p><strong>Title:</strong> <%= article.title %></p>
<p><strong>Text:</strong> <%= article.text %></p>
<p>Created <%= I18n.l(article.created_at, format: :short) %>,
   updated <%= I18n.l(article.updated_at, format: :short) %></p>
```

## Conclusion

Next time, I will explain to you what is provided by `I18n.l`. Stay tuned, but patient ...

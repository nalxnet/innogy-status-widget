# Smashing Innogy Status Widget

Hi, I'm a [Smashing](https://github.com/Smashing/smashing) widget that displays the current state of charge points operated by innogy.

##Dependencies

[faraday](https://github.com/lostisland/faraday) and [faraday_middleware](https://github.com/lostisland/faraday_middleware)

Add it to smashings' gemfile:

    gem 'faraday'
    gem 'faraday_middleware'

and run `bundle install`.

##Usage

To use this widget, copy `innogy_cp.html`, `innogy_cp.coffee`, and `innogy_cp.scss` into a `/widgets/innogy_cp` directory, and copy the `innogy_cp.rb` file into your `/jobs` folder.


To include the widget in a dashboard, add the following snippet to the dashboard layout file:


```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="innogy-cp-1" data-view="InnogyCp" data-chargepoint="my-chargepoint-id-1"></div>
</li>

<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="innogy-cp-2" data-view="InnogyCp" data-chargepoint="my-chargepoint-id-2"></div>
</li>
```

Create a widget for each chargepoint with the widget title in the `data-chargepoint` attribute. You also have to set the chargepoint IDs in the URLs used in `innogy_cp.rb` job.

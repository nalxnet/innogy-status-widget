# Smashing Innogy Status Widget

Hi, I'm a [Smashing](https://github.com/Smashing/smashing) widget that displays the current state of charge points operated by innogy.

## Usage

To use this widget, copy `innogy_cp.html`, `innogy_cp.coffee`, and `innogy_cp.scss` into a `/widgets/innogy_cp` directory, and copy the `innogy_cp.rb` file into your `/jobs` folder. You also have to set the chargepoint IDs of your charging station in the `innogy_cp.rb` job.


To include the widget in a dashboard, add the following snippet to the dashboard layout file:


```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="innogy-cp" data-view="InnogyCp"></div>
</li>
```

using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class Background extends Ui.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {

        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("backgroundColor"));
        dc.clear();
    }
}

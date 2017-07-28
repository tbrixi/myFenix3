using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;

function renderTime(dc)
{
	var xPercent = 50;
	var yPercent = 57;
	var timeString;
	var clockTime = Sys.getClockTime();
	var hours = clockTime.hour;
		
	if (!Sys.getDeviceSettings().is24Hour)
	{
		if (hours > 12)
		{
			hours = hours - 12;
		}
	}

	if (!sleepMode)
	{
		timeString = Lang.format("$1$:$2$:$3$", [hours, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
	}
	else
	{
		timeString = Lang.format("$1$:$2$", [hours, clockTime.min.format("%02d")]);
	}	
	
	var font = Gfx.FONT_LARGE;
	dc.setColor(App.getApp().getProperty("digitalTimeColor"), Gfx.COLOR_TRANSPARENT);
			
	dc.drawText(xPercent * screenPercent, yPercent * screenPercent, font, timeString, Gfx.TEXT_JUSTIFY_CENTER);
}
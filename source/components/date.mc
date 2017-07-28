using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function renderDate(dc)
{
	var xPercent = 50;
	var yPercent = 40;
	var now = Time.now();
	var nowInfo = Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
	var day = nowInfo.day;
	var month = nowInfo.month;
	var year = nowInfo.year;
	var dayOfWeek = nowInfo.day_of_week;
	var dateString = Lang.format("$1$ $2$ $3$", [dayOfWeek, day, month]);

	dc.setColor(App.getApp().getProperty("dateColor"), Gfx.COLOR_TRANSPARENT);
	dc.drawText(xPercent * screenPercent, yPercent * screenPercent -16, Gfx.FONT_TINY, dateString, Gfx.TEXT_JUSTIFY_CENTER);
}
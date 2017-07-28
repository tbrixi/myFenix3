using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function renderHands(dc)
{
	var clockTime = Sys.getClockTime();
	var clock_hour = clockTime.hour;
	var clock_min = clockTime.min;
	var clock_sec = clockTime.sec;

	var hour = ( ( ( clock_hour % 12 ) * 60 ) + clock_min );
	hour = hour / (12 * 60.0);
	hour = hour * Math.PI * 2;
	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	renderHand(dc, hour, 65, 8, 15);
	dc.setColor(App.getApp().getProperty("analogTimeColor"), Gfx.COLOR_TRANSPARENT);
	renderHand(dc, hour, 45, 6, 14);

	var min = ( clock_min / 60.0) * Math.PI * 2;
	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	renderHand(dc, min, 100, 4, 15);
	dc.setColor(App.getApp().getProperty("analogTimeColor"), Gfx.COLOR_TRANSPARENT);
	renderHand(dc, min, 75, 2, 14);

	if (!sleepMode)
	{
		var sec = ( clock_sec / 60.0) *  Math.PI * 2;
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		renderHand(dc, sec, 105, 2, 20);
	}

	dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
	dc.fillCircle(centerX, centerY, 7);
	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	dc.fillCircle(centerX, centerY, 5);
	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
	dc.fillCircle(centerX, centerY, 2);
}


function renderHand(dc, angle, length, width, overheadLength)
{
	var hand = [
		[-(width/2), 0 + overheadLength],
		[-(width/2), -length],
		[width/2, -length],
		[width/2, 0 + overheadLength]
	];
	var result = new [4];
	var cos = Math.cos(angle);
	var sin = Math.sin(angle);

	for (var i = 0; i < 4; i += 1)
	{
		var x = (hand[i][0] * cos) - (hand[i][1] * sin);
		var y = (hand[i][0] * sin) + (hand[i][1] * cos);
		result[i] = [ centerX + x, centerY + y];
	}

	dc.fillPolygon(result);
}
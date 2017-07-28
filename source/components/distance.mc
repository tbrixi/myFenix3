using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function renderDistance(dc, x, y, fieldColor)
{
	var info = ActivityMonitor.getInfo();
	var meter = info.distance / 100;
	
	if (meter == 0)
	{
		return;
	}
	
	var distanceString = "";
	
	if (unit == Sys.UNIT_METRIC)
	{
		if (meter < 999)
		{
			distanceString = Lang.format("$1$m", [meter.format("%01d")]);
		}
		else
		{
			var km = meter.toFloat() / 1000;
			if (km.toNumber() < 100)
			{
				distanceString = Lang.format("$1$km", [km.format("%0.2f")]);
			}
			else
			{
				distanceString = Lang.format("$1$km", [km.format("%0.1f")]);
			}
		}
	}

	if (unit == Sys.UNIT_STATUTE)
	{
		var feet = meter * feetScale;
		if (feet.toNumber() < 999)
		{
			distanceString = Lang.format("$1$ft", [feet.format("%01d")]);
		}
		else
		{
			var miles = meter.toFloat() / mileScale;
			if (miles.toNumber() < 100)
			{
				distanceString = Lang.format("$1$mi", [miles.format("%0.2f")]);
			}
			else
			{
				distanceString = Lang.format("$1$mi", [miles.format("%0.1f")]);
			}
		}
	}

	dc.setColor(fieldColor, Gfx.COLOR_TRANSPARENT);
	dc.drawText(x * screenPercent, y * screenPercent, Gfx.FONT_TINY, distanceString, Gfx.TEXT_JUSTIFY_CENTER);
	
}
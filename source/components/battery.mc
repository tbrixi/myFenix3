using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function renderBatery(dc)
{
	var xPercent = 50;
	var yPercent = 20;
	var batteryLevel = Sys.getSystemStats().battery;
	var batteryString = Lang.format("$1$%", [batteryLevel.format("%01d")]);

	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);

	if (batteryLevel < 50)
	{
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
	}

	if (batteryLevel < 25)
	{
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	}

	dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, batteryString, Gfx.TEXT_JUSTIFY_CENTER);
}
using Toybox.Application as App;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

function renderAltitude(dc, x, y, fieldColor)
{
	
	var meter = Act.getActivityInfo().altitude;
	
	if (meter.toNumber() == 0)
	{
		return;
	}

	var altitudeString = "";
	var font = Gfx.FONT_TINY;

	dc.setColor(fieldColor, Gfx.COLOR_TRANSPARENT);
	
	var unit = Sys.getDeviceSettings().distanceUnits;
	
	if (unit == Sys.UNIT_METRIC)
	{
		altitudeString = Lang.format("$1$m", [meter.format("%01d")]);
	}
	
	if (unit == Sys.UNIT_STATUTE)
	{
		var feet = meter * feetScale;
		altitudeString= Lang.format("$1$ft", [feet.format("%01d")]);
		
	}
	
	var stringWidth = dc.getTextWidthInPixels(altitudeString, font);
	var stringHeight = dc.getFontHeight(font);
	
	dc.drawText(x * screenPercent, y * screenPercent, font, altitudeString, Gfx.TEXT_JUSTIFY_CENTER);
	
	
	var scale = 0.5;
	var xOffset = x * screenPercent - stringWidth/2 - 16;
	var yOffset = y * screenPercent + stringHeight - 6;
	
	
	dc.setColor(0xFFFFFF, Gfx.COLOR_TRANSPARENT);
	dc.setPenWidth(1);	
	
	var x1= 0;
	var y1= 0;
	var x2= 6;
	var y2= -12;
	dc.drawLine(scale * x1 + xOffset, scale * y1 + yOffset, scale * x2 + xOffset, scale * y2 + yOffset);
	
	x1= x2;
	y1= y2;
	x2= x2 + 3;
	y2= y2 + 6;
	dc.drawLine(scale * x1 + xOffset, scale * y1 + yOffset, scale * x2 + xOffset, scale * y2 + yOffset);
	
	x1= x2;
	y1= y2;
	x2= x2 + 6;
	y2= y2 - 12;
	dc.drawLine(scale * x1 + xOffset, scale * y1 + yOffset, scale * x2 + xOffset, scale * y2 + yOffset);
	
	x1= x2;
	y1= y2;
	x2= x2 + 9;
	y2= y2 + 19;
	dc.drawLine(scale * x1 + xOffset, scale * y1 + yOffset, scale * x2 + xOffset, scale * y2 + yOffset);
}

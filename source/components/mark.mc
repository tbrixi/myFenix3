using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function renderHourMarks(dc)
{
	var hourMarkArray = new [60];
	for(var i = 0; i < 60; i+=1)
	{
		hourMarkArray[i] = new [2];
		if (i != 0 && i != 15 && i != 30 && i != 45)
		{
			hourMarkArray[i][0] = (i / 60.0) * Math.PI * 2;
		}
	}

	var numArray = ["12","3","6"," 9"];
	if (Sys.getDeviceSettings().is24Hour)
	{
		var clockTime = Sys.getClockTime();
		var hours = clockTime.hour;
		if (hours >= 12)
		{
			numArray = ["24","15","18","21"];
		}
	}

	dc.setColor(App.getApp().getProperty("analogTimeColor"), Gfx.COLOR_TRANSPARENT);
	dc.drawText((screenWidth/2), 0, Gfx.FONT_LARGE, numArray[0],Gfx.TEXT_JUSTIFY_CENTER);
	dc.drawText(screenWidth, screenHeight/2, Gfx.FONT_LARGE, numArray[1], Gfx.TEXT_JUSTIFY_RIGHT + Gfx.TEXT_JUSTIFY_VCENTER);
	dc.drawText(screenWidth/2, screenHeight-35, Gfx.FONT_LARGE, numArray[2], Gfx.TEXT_JUSTIFY_CENTER);
	dc.drawText(0, screenHeight/2, Gfx.FONT_LARGE, numArray[3],Gfx.TEXT_JUSTIFY_LEFT + Gfx.TEXT_JUSTIFY_VCENTER);

	dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);

	var max = centerX;
	var min = max - 20;
	var width = 10;
	var width2 = 4;
	for(var i = 0; i < 60; i += 5)
	{
		if (i != 0 && i != 15 && i != 30 && i != 45)
		{
			renderHand(dc, hourMarkArray[i][0], max, width, -min);
		}
	}

	dc.setColor(Gfx.COLOR_LT_GRAY , Gfx.COLOR_TRANSPARENT);
	for(var i = 0; i < 60; i += 5)
	{
		if (i != 0 && i != 15 && i != 30 && i != 45)
		{
			renderHand(dc, hourMarkArray[i][0], max - width, width, -min);
		}
	}

	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	for(var i = 0; i < 60; i += 5)
	{
		if (i != 0 && i != 15 && i != 30 && i != 45)
		{
			renderHand(dc, hourMarkArray[i][0], max, width2, -max + 7);
		}
	}

	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	for(var i = 0; i < 60; i += 5)
	{
		if (i != 0 && i != 15 && i != 30 && i != 45)
		{
			renderHand(dc, hourMarkArray[i][0], max - 7, width2, -min - 3);
		}
	}
}
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Application as App;

class myFenixView extends Ui.WatchFace
{
	var screenWidth;
	var screenHeight;
	var screenPercent;
	var centerX;
	var centerY;
	var sleepMode = false;

	function initialize() {
		WatchFace.initialize();
	}

	function onLayout(dc) {
		screenWidth = dc.getWidth();
		screenHeight = dc.getHeight();
		screenPercent = screenWidth.toFloat() / 100;
		centerX = screenWidth / 2;
		centerY = screenHeight / 2;

		setLayout(Rez.Layouts.WatchFace(dc));
	}

	function onShow() {
	}

	function onHide() {
	}

	function onUpdate(dc) {
		View.onUpdate(dc);

		renderBatery(dc);
		renderDate(dc);
		renderCalories(dc);
		renderDistance(dc);
		renderTime(dc);
		renderSteps(dc);

		renderHourMarks(dc);
		renderConnection(dc);
		renderAlarm(dc);
		renderNotification(dc);
		renderHR(dc);

		renderHands(dc);
	}

	function onExitSleep() {
		sleepMode = false;
	}

	function onEnterSleep() {
	 	sleepMode = true;
 	}

 	function renderBatery(dc)
	{
		var xPercent = 50;
		var yPercent = 18;
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

	function renderDate(dc)
	{
		var xPercent = 50;
		var yPercent = 30;
		var now = Time.now();
		var nowInfo = Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
		var day = nowInfo.day;
		var month = nowInfo.month;
		var year = nowInfo.year;
		var dayOfWeek = nowInfo.day_of_week;
		var dateString = Lang.format("$1$ $2$ $3$", [dayOfWeek, day, month]);

		dc.setColor(App.getApp().getProperty("DateColor"), Gfx.COLOR_TRANSPARENT);
		dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, dateString, Gfx.TEXT_JUSTIFY_CENTER);
	}

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

		dc.setColor(App.getApp().getProperty("DigitalTimeColor"), Gfx.COLOR_TRANSPARENT);
		dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_LARGE, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function renderSteps(dc)
	{
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		if (steps > 0)
		{
			var xPercent = 50;
			var yPercent = 75;
			var stepGoal = info.stepGoal;
			var stepsString = Lang.format("$1$", [steps.format("%01d")]);

			dc.setColor(App.getApp().getProperty("StepColor"), Gfx.COLOR_TRANSPARENT);
			dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, stepsString, Gfx.TEXT_JUSTIFY_CENTER);

			var stepsStringWidth = dc.getTextWidthInPixels(stepsString, Gfx.FONT_TINY);
			var icon = Ui.loadResource(Rez.Drawables.step);
			var yIco = yPercent + 2;
			var gap = 5;
			dc.drawBitmap(xPercent * screenPercent + stepsStringWidth / 2 + gap, screenPercent * yIco, icon);

			dc.setColor(App.getApp().getProperty("StepProgressColor"), Gfx.COLOR_TRANSPARENT);

			var width = screenWidth / 3;
			var yProgress = 85;
			dc.drawRectangle(width, yProgress * screenPercent, width, 4);

			var progress = width * steps / stepGoal;
			if (progress > width)
			{
				progress = width;
			}
			dc.fillRectangle(width, yProgress * screenPercent, progress, 4);
		}
	}

	function renderDistance(dc)
	{
		var info = ActivityMonitor.getInfo();
		var meter = info.distance / 100;
		if (meter > 0)
		{
			var xPercent = 72;
			var yPercent = 45;
			var distanceString = "";
			var feetScale = 3.2808399;
			var mileScale = 1609.344;

			var unit = Sys.getDeviceSettings().distanceUnits;

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

			dc.setColor(App.getApp().getProperty("DistanceColor"), Gfx.COLOR_TRANSPARENT);
			dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, distanceString, Gfx.TEXT_JUSTIFY_CENTER);
		}
	}

	function renderCalories(dc)
	{
		var calories = ActivityMonitor.getInfo().calories;
		if (calories > 0)
		{
			var xPercent = 28;
			var yPercent = 45;
			var caloriesString = Lang.format("$1$kC", [calories.format("%01d")]);
			dc.setColor(App.getApp().getProperty("CaloriesColor"), Gfx.COLOR_TRANSPARENT);
			dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, caloriesString, Gfx.TEXT_JUSTIFY_CENTER);
		}
	}

	function renderHR(dc)
	{
		if (ActivityMonitor has :getHeartRateHistory)
		{
			var hrIter = ActivityMonitor.getHeartRateHistory(null, true);
			var hr = hrIter.next();
			var bpm = (hr.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && hr.heartRate > 0) ? hr.heartRate : 0;
			if (bpm > 0)
			{
				var xPercent = 90;
				var yPercent = 57;
				var bpmString = bpm.toString();
				dc.setColor(App.getApp().getProperty("HRColor"), Gfx.COLOR_TRANSPARENT);
				dc.drawText(xPercent * screenPercent, yPercent * screenPercent, Gfx.FONT_TINY, bpmString, Gfx.TEXT_JUSTIFY_RIGHT);

				var icon = Ui.loadResource(Rez.Drawables.bpm);
				var xIco = 92;
				var yIco = 60;
				dc.drawBitmap(screenPercent * xIco, screenPercent * yIco, icon);
			}
		}
	}

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
		dc.setColor(App.getApp().getProperty("AnalogTimeColor"), Gfx.COLOR_TRANSPARENT);
		renderHand(dc, hour, 45, 6, 14);

		var min = ( clock_min / 60.0) * Math.PI * 2;
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		renderHand(dc, min, 100, 4, 15);
		dc.setColor(App.getApp().getProperty("AnalogTimeColor"), Gfx.COLOR_TRANSPARENT);
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

		dc.setColor(App.getApp().getProperty("AnalogTimeColor"), Gfx.COLOR_TRANSPARENT);
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

	function renderConnection(dc)
	{
		var connected = Sys.getDeviceSettings().phoneConnected;
		if (connected)
		{
			var xPercent = 61.5;
			var yPercent = 7;
			var icon = Ui.loadResource(Rez.Drawables.bluetooth);
			dc.drawBitmap(xPercent * screenPercent, yPercent * screenPercent, icon);
		}
	}

	function renderAlarm(dc)
	{
		var alarmCount = Sys.getDeviceSettings().alarmCount;
		if (alarmCount > 0)
		{
			var xPercent = 92;
			var yPercent = 35;
			var icon = Ui.loadResource(Rez.Drawables.alarm);
			dc.drawBitmap(xPercent * screenPercent, yPercent * screenPercent, icon);
		}
	}

	function renderNotification(dc)
	{
		var notificationCount = Sys.getDeviceSettings().notificationCount;
		if (notificationCount > 0)
		{
			var xPercent = 79;
			var yPercent = 16;
			var icon = Ui.loadResource(Rez.Drawables.notification);
			dc.drawBitmap(xPercent * screenPercent, yPercent * screenPercent, icon);
		}
	}
}

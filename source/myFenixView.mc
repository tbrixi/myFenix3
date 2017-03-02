using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Application as App;

class myFenixView extends Ui.WatchFace {

	var screenWidth;
	var screenHeight;
	var centerX;
	var centerY;
	var sleepMode = false;

	function initialize() {
		WatchFace.initialize();
	}

	function onLayout(dc) {
		screenWidth = dc.getWidth();
		screenHeight = dc.getHeight();
		centerX = screenWidth / 2;
		centerY = screenHeight / 2;

		setLayout(Rez.Layouts.WatchFace(dc));
	}

	function onShow() {
	}

	function onHide() {
	}

	function onUpdate(dc) {

		renderDate();
		renderTime();
		renderBatery();
		renderSteps();
		renderDistance();
		renderCalories();

		View.onUpdate(dc);

		renderHourMarks(dc);
		renderStepsProgress(dc);
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

	function renderDate()
	{
		var now = Time.now();
		var nowInfo = Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
		var day = nowInfo.day;
		var month = nowInfo.month;
		var year = nowInfo.year;
		var dayOfWeek = nowInfo.day_of_week;
		var dateString = Lang.format("$1$ $2$ $3$", [dayOfWeek, day, month]);
		var view = View.findDrawableById("DateLabel");
		view.setColor(App.getApp().getProperty("DateColor"));
		view.setText(dateString);
	}

	function renderTime()
	{
		var timeString;
		var clockTime = Sys.getClockTime();
		var hours = clockTime.hour;
		if (!Sys.getDeviceSettings().is24Hour) {
			if (hours > 12) {
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
		var view = View.findDrawableById("TimeLabel");
		view.setColor(App.getApp().getProperty("DigitalTimeColor"));
		view.setText(timeString);
	}

	function renderBatery()
	{
		var batteryLevel = Sys.getSystemStats().battery;
		var batteryString = Lang.format("$1$%", [batteryLevel.format("%01d")]);

		var view = View.findDrawableById("BateryLabel");
		view.setText(batteryString);

		if (batteryLevel < 50)
		{
			view.setColor(Gfx.COLOR_ORANGE);
		}

		if (batteryLevel < 25)
		{
			view.setColor(Gfx.COLOR_RED);
		}
	}

	function renderSteps()
	{
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		if (steps > 0)
		{
			var stepsGoal = info.stepGoal;
			var stepsString = Lang.format("$1$ft", [steps.format("%01d")]);
			var view = View.findDrawableById("StepsLabel");
			view.setColor(App.getApp().getProperty("StepColor"));
			view.setText(stepsString);
		}
	}

	function renderStepsProgress(dc)
	{
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		if (steps > 0)
		{
			var stepGoal = info.stepGoal;

			dc.setColor(App.getApp().getProperty("StepProgressColor"), Gfx.COLOR_TRANSPARENT);

			var off = 70;
			var width = screenWidth - 2 * off;
			dc.drawRectangle(off, 183, width, 4);

			var progress = width * steps / stepGoal;
			if (progress > width)
			{
				progress = width;
			}
			dc.fillRectangle(off, 183, progress, 4);
		}
	}

	function renderDistance()
	{
		var distance = ActivityMonitor.getInfo().distance/100;
		if (distance > 0)
		{
			var distanceString = Lang.format("$1$m", [distance.format("%01d")]);
			var view = View.findDrawableById("DistanceLabel");
			view.setColor(App.getApp().getProperty("DistanceColor"));
			view.setText(distanceString);
		}
	}

	function renderCalories()
	{
		var calories = ActivityMonitor.getInfo().calories;
		if (calories > 0)
		{
			var caloriesString = Lang.format("$1$kC", [calories.format("%01d")]);
			var view = View.findDrawableById("CaloriesLabel");
			view.setColor(App.getApp().getProperty("CaloriesColor"));
			view.setText(caloriesString);
		}
	}

	function renderHR(dc)
	{
		var hrIter = ActivityMonitor.getHeartRateHistory(null, true);
		var hr = hrIter.next();
		var bpm = (hr.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && hr.heartRate > 0) ? hr.heartRate : 0;
		if (bpm > 0)
		{
			var bpmString = bpm.toString();
			var x = 184;
			var y = 125;
			dc.setColor(App.getApp().getProperty("HRColor"), Gfx.COLOR_TRANSPARENT);
			dc.drawText(x, y, Gfx.FONT_TINY, bpmString, Gfx.TEXT_JUSTIFY_CENTER);

			var icon = Ui.loadResource(Rez.Drawables.bpm);
			dc.drawBitmap(screenWidth - 20, y + 6, icon);
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
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				hourMarkArray[i][0] = (i / 60.0) * Math.PI * 2;
				if(i % 5 == 0)
				{
					hourMarkArray[i][1] = -90;
				}
				else
				{
					hourMarkArray[i][1] = -108;
				}
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
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				renderHand(dc, hourMarkArray[i][0], 110, 10, hourMarkArray[i][1]);
			}
		}

		dc.setColor(Gfx.COLOR_LT_GRAY , Gfx.COLOR_TRANSPARENT);
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				renderHand(dc, hourMarkArray[i][0], 100, 10, hourMarkArray[i][1]);
			}
		}

		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				renderHand(dc, hourMarkArray[i][0], 110, 4, hourMarkArray[i][1]);
			}
		}

		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				renderHand(dc, hourMarkArray[i][0], 104, 4, hourMarkArray[i][1]);
			}
		}

		dc.setColor(Gfx.COLOR_LT_GRAY , Gfx.COLOR_TRANSPARENT);
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				renderHand(dc, hourMarkArray[i][0], 93, 10, hourMarkArray[i][1]);
			}
		}
	}

	function renderConnection(dc)
	{
		var connected = Sys.getDeviceSettings().phoneConnected;
		if (connected)
		{
			var icon = Ui.loadResource(Rez.Drawables.bluetooth);
			dc.drawBitmap(screenWidth - 83, 13, icon);
		}
	}

	function renderAlarm(dc)
	{
		var alarmCount = Sys.getDeviceSettings().alarmCount;
		if (alarmCount > 0)
		{
			var icon = Ui.loadResource(Rez.Drawables.alarm);
			dc.drawBitmap(screenWidth - 20, 75, icon);
		}
	}

	function renderNotification(dc)
	{
		var notificationCount = Sys.getDeviceSettings().notificationCount;
		if (notificationCount > 0)
		{
			var icon = Ui.loadResource(Rez.Drawables.notification);
			dc.drawBitmap(screenWidth - 50, 38, icon);
		}
	}
}

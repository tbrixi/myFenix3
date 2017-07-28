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
	var feetScale = 3.2808399;
	var mileScale = 1609.344;
	var unit = Sys.getDeviceSettings().distanceUnits;

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
		renderTime(dc);
		
		renderField1(dc);
		renderField2(dc);
		renderField3(dc);
		renderFieldHR(dc);

		renderHourMarks(dc);
		renderConnection(dc);
		renderAlarm(dc);
		renderNotification(dc);
		
		renderHands(dc);
	}
	
	function renderField1(dc)
	{
		var x;
		var y;
		var fieldType = App.getApp().getProperty("field1");
		var fieldColor = App.getApp().getProperty("field1Color");
		
		if (fieldType == 1)
		{
			x = 33;
			y = 45;
			renderAltitude(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 2)
		{
			x = 30;
			y = 45;
			renderCalories(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 3)
		{
			x = 30;
			y = 45;
			renderDistance(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 4)
		{
			x = 35;
			y = 45;
			renderHR(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 5)
		{
			x = 32;
			y = 45;
			renderSteps(dc, x, y, fieldColor, false);
		}		
	}
	
	function renderField2(dc)
	{
		var x;
		var y;
		var fieldType = App.getApp().getProperty("field2");
		var fieldColor = App.getApp().getProperty("field2Color");
		
		if (fieldType == 1)
		{
			x = 74;
			y = 45;
			renderAltitude(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 2)
		{
			x = 73;
			y = 45;
			renderCalories(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 3)
		{
			x = 72;
			y = 45;
			renderDistance(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 4)
		{
			x = 75;
			y = 45;
			renderHR(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 5)
		{
			x = 76;
			y = 45;
			renderSteps(dc, x, y, fieldColor, false);
		}		
	}
	
	function renderField3(dc)
	{
		var x;
		var y;
		var fieldType = App.getApp().getProperty("field3");
		var fieldColor = App.getApp().getProperty("field3Color");
		
		if (fieldType == 1)
		{
			x = 50;
			y = 74;
			renderAltitude(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 2)
		{
			x = 50;
			y = 75;
			renderCalories(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 3)
		{
			x = 50;
			y = 75;
			renderDistance(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 4)
		{
			x = 53;
			y = 75;
			renderHR(dc, x, y, fieldColor);
		}
		
		else if (fieldType == 5)
		{
			x = 50;
			y = 74;
			renderSteps(dc, x, y, fieldColor, true);
		}		
	}
	
	function renderFieldHR(dc)
	{
		var fieldHR = App.getApp().getProperty("fieldHR");
		if (fieldHR)
		{
			renderHR(dc, 92, 57, 0xFF0000);
		} 
	}
	
	function onExitSleep()
	{
		sleepMode = false;
	}

	function onEnterSleep()
	{
		sleepMode = true;
	}	
}

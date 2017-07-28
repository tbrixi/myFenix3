using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

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
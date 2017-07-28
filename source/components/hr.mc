using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

function renderHR(dc, x , y, fieldColor)
{
	if (ActivityMonitor has :getHeartRateHistory)
	{
		var hrIter = ActivityMonitor.getHeartRateHistory(null, true);
		var hr = hrIter.next();
		var bpm = (hr.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && hr.heartRate > 0) ? hr.heartRate : 0;
		if (bpm > 0)
		{
			var bpmString = bpm.toString();
			dc.setColor(fieldColor, Gfx.COLOR_TRANSPARENT);
			dc.drawText(x * screenPercent, y * screenPercent, Gfx.FONT_TINY, bpmString, Gfx.TEXT_JUSTIFY_CENTER);
			
			var stringWidth = dc.getTextWidthInPixels(bpmString, Gfx.FONT_TINY);

			var icon = Ui.loadResource(Rez.Drawables.bpm);
			dc.drawBitmap(x * screenPercent - stringWidth/2 - 16 , y * screenPercent + 6, icon);
		}
	}
}
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

function renderCalories(dc, x, y, fieldColor)
{
	var calories = ActivityMonitor.getInfo().calories;
	if (calories > 0)
	{
		var caloriesString = Lang.format("$1$kC", [calories.format("%01d")]);
		dc.setColor(fieldColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x * screenPercent, y * screenPercent, Gfx.FONT_TINY, caloriesString, Gfx.TEXT_JUSTIFY_CENTER);
	}
}
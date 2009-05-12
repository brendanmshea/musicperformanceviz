// gonna put all the stuff for drawing and showing circles in here.
import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.core.UIComponent;

private function scaleXToCanvas(mev: MusicEvent, c: Canvas): Number {
	var minl: Number = getMinLong();
	var maxl: Number = getMaxLong();
	
	var l: Number = mev.getVenue().getLong();
	var range: Number = c.width;
	
	return (l - minl) * (maxl - minl) / range;
}

private function scaleYToCanvas(mev: MusicEvent, c: Canvas): Number {
	var minl: Number = getMinLat();
	var maxl: Number = getMaxLat();
	
	var l: Number = mev.getVenue().getLat();
	var range: Number = c.height;
	
	return (l - minl) * (maxl - minl) / range;
}

private function drawEventCircles(): void {
	for each ( var mev:MusicEvent in _events ) {
		drawEventCircle(mev);
	}
}

private function drawEventCircle(mev: MusicEvent): void {

	var comp:MEVComponent = new MEVComponent(mev, this.graph);

}


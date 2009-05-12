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

  var circleSize:uint = randomNumber(2, 50); // e.getPrice();
	var circleX:uint = scaleXToCanvas(mev, this.graph);
	var circleY:uint = scaleYToCanvas(mev, this.graph);

	var circle:Shape = new Shape();
	circle.graphics.beginFill(0xFF0000, 0.5);
	circle.graphics.drawCircle(circleX, circleY, circleSize);
	circle.graphics.endFill();

	var comp:MEVComponent = new MEVComponent(mev);

	comp.addChild(circle);
	this.graph.addChild(comp);
}


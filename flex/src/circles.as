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

private function drawEventCircles(c: Canvas): void {
	for each ( var mev:MusicEvent in _events ) {
		drawEventCircle(mev, c);
	}
}

private function drawEventCircle(mev: MusicEvent, c: Canvas): void {

  var circleSize:uint = randomNumber(2, 50); // e.getPrice();
	var circleX:uint = scaleXToCanvas(mev, c);
	var circleY:uint = scaleYToCanvas(mev, c);

	var circle:Shape = new Shape();
	circle.graphics.beginFill(0xFF0000, 0.5);
	circle.graphics.drawCircle(circleX, circleY, circleSize);
	circle.graphics.endFill();

	var comp:UIComponent = new UIComponent();
	comp.addEventListener(MouseEvent.MOUSE_OVER, circleHover);
	comp.addEventListener(MouseEvent.MOUSE_OUT, circleUnHover);
	comp.addEventListener(MouseEvent.CLICK, circleClick);

	comp.addChild(circle);
	c.addChild(comp);
}

private function drawCircle(c: Canvas): void {
	var circleSize:uint = randomNumber(2, 50);
	var circleX:uint = randomNumber(circleSize, c.width - circleSize);
	var circleY:uint = randomNumber(circleSize, c.height - circleSize);

	var circle:Shape = new Shape();
	circle.graphics.beginFill(0xFF0000, 0.5);
	circle.graphics.drawCircle(circleX, circleY, circleSize);
	circle.graphics.endFill();

	var comp:UIComponent = new UIComponent();
	comp.addEventListener(MouseEvent.MOUSE_OVER, circleHover);
	comp.addEventListener(MouseEvent.MOUSE_OUT, circleUnHover);
	comp.addEventListener(MouseEvent.CLICK, circleClick);

	comp.addChild(circle);
	c.addChild(comp);
}

private function circleHover(event:MouseEvent):void {
	event.target.alpha = 1.8;
}

private function circleUnHover(event:MouseEvent):void {
	event.target.alpha = 1.0;
}

private function circleClick(event:MouseEvent):void {
	mx.controls.Alert.show("click!");
}

      
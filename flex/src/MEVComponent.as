package
{
import flash.display.Shape;
import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Application;
import mx.core.UIComponent;

public class MEVComponent extends UIComponent
{
	internal var mev: MusicEvent;
	public function MEVComponent(p_mev: MusicEvent, color: int, c: Canvas, nth:Number, ccenter:Object) {
		super();
		mev = p_mev;

		var circle:Shape = new Shape();

		var circleSize:uint = Math.pow(p_mev.getPrice(), 0.7) + 3;
		if (p_mev.getPrice() == 0) {
			circleSize = 3;
			circle.graphics.lineStyle(3, 0x33FF00, 0.8);
		}
		if (p_mev.getPrice() < 0) {
			circleSize = 3;
			circle.graphics.lineStyle(3, 0xFF0000, 0.8);
		}

		//		trace("at " + ccenter.x + ", " + ccenter.y);

		var offset:Object = getSpiralOffset(nth);
		var circleX:uint = ccenter.x + offset.x;
		var circleY:uint = ccenter.y + offset.y;

		circle.graphics.beginFill(color, 0.5);
		circle.graphics.drawCircle(circleX, circleY, circleSize);
		circle.graphics.endFill();

		addChild(circle);

		addEventListener(MouseEvent.MOUSE_OVER, handleHover);
		addEventListener(MouseEvent.MOUSE_OUT, handleUnHover);
		addEventListener(MouseEvent.CLICK, handleClick);

		toolTip = mev.getEventName() + "\n"
			+ mev.getDisplayPrice() + "\n"
			+ mev.getType();
		c.addChild(this);
	}

	private function handleClick(event:MouseEvent):void {
		Alert.show(mev.getEventName() + " - " + mev.getPrice());
	}
		
	private function handleHover(event:MouseEvent):void {
		alpha = 1.8;
		// Highlight the genre...
		var genreLabel:Label = Application.application.genreSelections.getChildByName(mev.getType());
		genreLabel.setStyle("color", 0x00FFCC);
		// ...and the Neighborhood.
		var neighborhoodLabel:Label = Application.application.neighborhoodsSelections.getChildByName(mev.getVenue().getZip());
		neighborhoodLabel.setStyle("color", 0x00FFCC);
	}
		
	private function handleUnHover(event:MouseEvent):void {
		alpha = 1.0;
		// Unhighlight the genre...
		var genreLabel:Label = Application.application.genreSelections.getChildByName(mev.getType());
		genreLabel.setStyle("color", 0x000000);
		// ...and the Neighborhood.
		var neighborhoodLabel:Label = Application.application.neighborhoodsSelections.getChildByName(mev.getVenue().getZip());
		neighborhoodLabel.setStyle("color", 0x000000);
	}
		
	public function randomNumber(low:Number=0, high:Number=100):Number {
		var low:Number = low;
		var high:Number = high;
			
		return Math.floor(Math.random() * (1+high-low)) + low;
	}
		
	private function getSpiralOffset(nth:Number):Object {
		var inFirstRing:uint = 2; // number in the inner ring
		var angle:Number = 8 * Math.sqrt(nth);
		var radius:Number = inFirstRing + 10 * Math.sqrt(nth);

		//		trace(nth + " - " + angle + " - " + radius);
		//		trace("radius: "+ radius);
		return {x:radius * Math.cos(angle), y:radius * Math.sin(angle)};
	}

}
}
// Music Event UI component -- the circle on the graph view.
package
{
import flash.display.Shape;
import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.core.Application;
import mx.core.UIComponent;

public class MEVComponent extends UIComponent
{
	internal var mev: MusicEvent;
	internal var highlight: Function;
	internal var unhighlight: Function;
	internal var formatDate: Function;
	public function MEVComponent(p_mev: MusicEvent, color: int, c: Canvas, nth:Number, ccenter:Object, p_highlight:Function, p_unhighlight:Function, p_formatDate:Function) {
		super();
		mev = p_mev;
		highlight = p_highlight;
		unhighlight = p_unhighlight;
		formatDate = p_formatDate;

		var circle:Shape = new Shape();

		var circleSize:uint = Math.pow(p_mev.getPrice(), 0.7) + 3;
		// Free events get a fixed, small size.
		if (p_mev.getPrice() == 0) {
			circleSize = 4;
		}

		var offset:Object = getSpiralOffset(nth);
		var circleX:uint = ccenter.x + offset.x;
		var circleY:uint = ccenter.y + offset.y;

		circle.graphics.beginFill(color, 0.6);
		// Unknown price events are squares.
		if (p_mev.getPrice() < 0) {
			circle.graphics.drawRect(circleX, circleY, 8, 8);
		} else {
			circle.graphics.drawCircle(circleX, circleY, circleSize);
		}
		circle.graphics.endFill();

		addChild(circle);

		addEventListener(MouseEvent.MOUSE_OVER, handleHover);
		addEventListener(MouseEvent.MOUSE_OUT, handleUnHover);
		addEventListener(MouseEvent.CLICK, handleClick);

		toolTip = mev.getEventName() + "\n"
			+ mev.getDisplayPrice();
		c.addChild(this);
	}

	private function handleClick(event:MouseEvent):void {
		var info:String = mev.getEventName() + "<br/><br/>"
			+ mev.getVenue().getVenue() + "<br/>"
			+ "<a href='" + mev.getVenueUrl() + "'>" + mev.getVenueUrl() + "</a><br/>"
			+ mev.getDisplayPrice() + "<br/>"
			+ formatDate(mev.getStartTime()) + "<br/>"
			+ "<a href='" + mev.getEventUrl() + "'>" + mev.getEventUrl() + "</a><br/>"
			;

		Application.application.eventDescriptionBox.setVisible(true);
		Application.application.eventDescription.htmlText = info;
	}
	
	private function handleHover(event:MouseEvent):void {
		alpha = 1.8;
		highlight(mev);
	}
		
	private function handleUnHover(event:MouseEvent):void {
		alpha = 1.0;
		unhighlight(mev);
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
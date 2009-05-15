package
{
import flash.display.Shape;
import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.containers.Box;
import mx.controls.Label;
import mx.controls.Text;
import mx.core.Application;
import mx.core.UIComponent;

public class MEVComponent extends UIComponent
{
	internal var mev: MusicEvent;
	internal var highlight: Function;
	internal var unhighlight: Function;
	public function MEVComponent(p_mev: MusicEvent, color: int, c: Canvas, nth:Number, ccenter:Object, p_highlight:Function, p_unhighlight:Function) {
		super();
		mev = p_mev;
		highlight = p_highlight;
		unhighlight = p_unhighlight;

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
			+ mev.getDisplayPrice();
		c.addChild(this);
	}

	private function handleClick(event:MouseEvent):void {
		var info:String = mev.getEventName() + "<br/>"
			+ "Price: " + mev.getDisplayPrice() + "<br/>"
			+ "Venue: " + mev.getVenue().getVenue() + "<br/>"
			+ "Genre: " + mev.getType() + "<br/>"
			+ "<a href='" + mev.getUrl() + "'>" + mev.getUrl() + "</a><br/>"
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